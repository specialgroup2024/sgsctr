using System.Net;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using System.Text.RegularExpressions;
using Microsoft.EntityFrameworkCore;
using Sgsctr.Api.Data;

namespace Sgsctr.Api.RegulatoryIntelligence;

public interface IRegulatoryIngestionService
{
    Task<RegulatoryScanSummary> RunAsync(bool force, CancellationToken cancellationToken);
}

public sealed record RegulatoryScanSummary(int SourcesChecked, int Discovered, int NewDocuments, int FailedSources);

public sealed class RegulatoryIngestionService(
    AppDbContext db,
    IHttpClientFactory clients,
    ILogger<RegulatoryIngestionService> logger) : IRegulatoryIngestionService
{
    private const int MaxPageBytes = 4 * 1024 * 1024;
    private const int MaxDocumentBytes = 5 * 1024 * 1024;
    private const int MaxNewDocumentsPerCycle = 12;
    private static readonly SemaphoreSlim ScanLock = new(1, 1);
    private const int MaxLinksPerSource = 20;
    private static readonly Regex AnchorPattern = new("<a\\b[^>]*href\\s*=\\s*(['\"])(.*?)\\1[^>]*>(.*?)</a>", RegexOptions.IgnoreCase | RegexOptions.Singleline | RegexOptions.Compiled);
    private static readonly Regex TagPattern = new("<[^>]+>", RegexOptions.Singleline | RegexOptions.Compiled);
    private static readonly string[] Keywords =
    [
        "recall", "alert", "safety", "pharmacovigilance", "decree", "regulation", "regulatory",
        "guideline", "circular", "announcement", "notice", "news", "update", "publication", "decision", "medicine", "medicinal", "pharmaceutical",
        "pharmacy", "drug", "cosmetic", "medical device", "medical supply", "track", "price",
        "استدعاء", "تنبيه", "سلامة", "قرار", "لائحة", "دليل", "دواء", "صيدلية", "مستحضر", "تسعير"
    ];

    private static readonly (string Code, string Name, string Url, string Host)[] SeedSources =
    [
        ("EDA-ANNOUNCEMENTS", "EDA announcements", "https://www.edaegypt.gov.eg/en/media-center/announcements/", "edaegypt.gov.eg"),
        ("EDA-NEWS", "EDA news", "https://www.edaegypt.gov.eg/en/media-center/news/", "edaegypt.gov.eg"),
        ("EDA-SAFETY", "EDA pharmaceutical-care safety alerts", "https://www.edaegypt.gov.eg/en/awareness/ca-of-pharmaceutical-care-publications/pharmacovigilance-publications/third-safety-alerts/", "edaegypt.gov.eg"),
        ("EDA-DECREE-CURRENT", "EDA chairman decrees (current year)", $"https://www.edaegypt.gov.eg/en/the-regulatory-reference-of-the-egyptian-drug-authority-eda/eda-chairman-decree/eda-chairman-decree-of-year-{DateTime.UtcNow.Year}/", "edaegypt.gov.eg"),
        ("EDA-GUIDELINES", "EDA regulatory guidelines", "https://www.edaegypt.gov.eg/en/the-regulatory-reference-of-the-egyptian-drug-authority-eda/regulatory-guidelines/", "edaegypt.gov.eg")
    ];

    public async Task<RegulatoryScanSummary> RunAsync(bool force, CancellationToken cancellationToken)
    {
        await ScanLock.WaitAsync(cancellationToken);
        try
        {
        await EnsureSeedSourcesAsync(cancellationToken);
        var now = DateTimeOffset.UtcNow;
        var sources = await db.RegulatorySources.Where(x => x.IsEnabled).OrderBy(x => x.Code).ToListAsync(cancellationToken);
        var checkedCount = 0; var discovered = 0; var added = 0; var failed = 0;
        foreach (var source in sources)
        {
            if (!force && source.LastCheckedAtUtc is not null &&
                source.LastCheckedAtUtc.Value > now.AddMinutes(-source.PollIntervalMinutes)) continue;
            checkedCount++;
            var run = new RegulatoryScanRun { Id = Guid.NewGuid(), SourceId = source.Id, StartedAtUtc = now, Status = "Running" };
            db.RegulatoryScanRuns.Add(run);
            try
            {
                var page = await FetchAsync(source.Url, source.AllowedHost, MaxPageBytes, cancellationToken);
                if (!page.ContentType.Contains("html", StringComparison.OrdinalIgnoreCase))
                    throw new InvalidOperationException("Configured EDA source page did not return HTML.");
                var links = ExtractLinks(page.Bytes, source.Url, source.AllowedHost);
                run.DiscoveredCount = links.Count;
                discovered += links.Count;
                string? linkError = null;
                foreach (var link in links)
                {
                    if (added >= MaxNewDocumentsPerCycle) break;
                    if (await db.RegulatoryDocuments.AnyAsync(x => x.SourceUrl == link.Url, cancellationToken)) continue;
                    try
                    {
                        var item = await FetchAsync(link.Url, source.AllowedHost, MaxDocumentBytes, cancellationToken);
                        if (!IsSupportedContent(item.ContentType, link.Url)) continue;
                        var hash = Convert.ToHexString(SHA256.HashData(item.Bytes)).ToLowerInvariant();
                        if (await db.RegulatoryDocuments.AnyAsync(x => x.ContentHash == hash, cancellationToken)) continue;
                        var title = CleanTitle(link.Title);
                        if (string.IsNullOrWhiteSpace(title)) title = Path.GetFileName(item.FinalUri.AbsolutePath);
                        var modules = ClassifyModules(title + " " + link.Url);
                        var topic = ClassifyTopic(title + " " + link.Url);
                        var document = new RegulatoryDocument
                        {
                            Id = Guid.NewGuid(), SourceId = source.Id, Title = title.Length > 500 ? title[..500] : title,
                            SourceUrl = link.Url, ContentHash = hash, ContentType = item.ContentType.Contains("octet-stream", StringComparison.OrdinalIgnoreCase) && link.Url.EndsWith(".pdf", StringComparison.OrdinalIgnoreCase) ? "application/pdf" : item.ContentType,
                            Language = ContainsArabic(title) ? "ar" : "en", SourceClass = source.SourceClass,
                            Topic = topic, Modules = JsonSerializer.Serialize(modules),
                            VerificationStatus = "Unverified", ReviewStatus = "Pending",
                            Severity = IsUrgent(title) ? "UrgentReview" : "ReviewRequired",
                            RetrievedAtUtc = DateTimeOffset.UtcNow, OriginalContent = item.Bytes
                        };
                        db.RegulatoryDocuments.Add(document);
                        db.RegulatoryAlerts.Add(new RegulatoryAlert
                        {
                            Id = Guid.NewGuid(), DocumentId = document.Id,
                            AlertType = IsUrgent(title) ? "SafetyOrRecall" : "NewPublication",
                            Status = "Unread", CreatedAtUtc = DateTimeOffset.UtcNow
                        });
                        await db.SaveChangesAsync(cancellationToken);
                        added++; run.NewDocumentCount++;
                    }
                    catch (Exception exception) when (exception is HttpRequestException or InvalidOperationException)
                    {
                        linkError = exception.Message.Length > 1000 ? exception.Message[..1000] : exception.Message;
                        logger.LogWarning(exception, "Skipped EDA document link {Url} from source {SourceCode}.", link.Url, source.Code);
                    }
                }
                source.LastSuccessAtUtc = DateTimeOffset.UtcNow;
                source.LastError = linkError;
                run.Status = linkError is null ? "Succeeded" : "Partial";
                run.ErrorMessage = linkError;
            }
            catch (OperationCanceledException) when (cancellationToken.IsCancellationRequested)
            {
                throw;
            }
            catch (Exception exception)
            {
                failed++;
                source.LastError = exception.Message.Length > 1000 ? exception.Message[..1000] : exception.Message;
                run.Status = "Failed";
                run.ErrorMessage = source.LastError;
                logger.LogError(exception, "EDA source scan failed for {SourceCode}.", source.Code);
            }
            source.LastCheckedAtUtc = DateTimeOffset.UtcNow;
            run.CompletedAtUtc = DateTimeOffset.UtcNow;
            await db.SaveChangesAsync(cancellationToken);
        }
        return new RegulatoryScanSummary(checkedCount, discovered, added, failed);
        }
        finally
        {
            ScanLock.Release();
        }
    }

    private async Task EnsureSeedSourcesAsync(CancellationToken cancellationToken)
    {
        foreach (var seed in SeedSources)
        {
            var existing = await db.RegulatorySources.SingleOrDefaultAsync(x => x.Code == seed.Code, cancellationToken);
            if (existing is not null)
            {
                if (seed.Code == "EDA-DECREE-CURRENT" && existing.Url != seed.Url)
                {
                    existing.Url = seed.Url;
                    existing.LastCheckedAtUtc = null;
                }
                continue;
            }
            db.RegulatorySources.Add(new RegulatorySource
            {
                Id = Guid.NewGuid(), Code = seed.Code, Name = seed.Name, Url = seed.Url,
                AllowedHost = seed.Host, SourceClass = "B", IsEnabled = true,
                PollIntervalMinutes = 360, CreatedAtUtc = DateTimeOffset.UtcNow
            });
        }
        await db.SaveChangesAsync(cancellationToken);
    }

    private async Task<DownloadedContent> FetchAsync(string url, string allowedHost, int maxBytes, CancellationToken cancellationToken)
    {
        if (!Uri.TryCreate(url, UriKind.Absolute, out var uri) || uri.Scheme != Uri.UriSchemeHttps ||
            !(uri.Host.Equals(allowedHost, StringComparison.OrdinalIgnoreCase) ||
              uri.Host.EndsWith("." + allowedHost, StringComparison.OrdinalIgnoreCase)))
            throw new InvalidOperationException("Only HTTPS URLs on the configured EDA host are allowed.");
        using var request = new HttpRequestMessage(HttpMethod.Get, uri);
        request.Headers.UserAgent.ParseAdd("SGSCTR-RegulatoryMonitor/1.0 (+authorized EDA public-page monitoring)");
        request.Headers.Accept.ParseAdd("text/html,application/pdf,application/octet-stream;q=0.9,*/*;q=0.5");
        var client = clients.CreateClient("eda-regulatory");
        using var response = await client.SendAsync(request, HttpCompletionOption.ResponseHeadersRead, cancellationToken);
        if ((int)response.StatusCode is >= 300 and < 400)
            throw new InvalidOperationException("Redirects are not followed by the ingestion service; verify the official source URL.");
        response.EnsureSuccessStatusCode();
        if (response.Content.Headers.ContentLength > maxBytes)
            throw new InvalidOperationException("Source content exceeds the configured ingestion size limit.");
        await using var stream = await response.Content.ReadAsStreamAsync(cancellationToken);
        using var output = new MemoryStream();
        var buffer = new byte[81920];
        int read;
        while ((read = await stream.ReadAsync(buffer, cancellationToken)) > 0)
        {
            if (output.Length + read > maxBytes) throw new InvalidOperationException("Source content exceeds the configured ingestion size limit.");
            output.Write(buffer, 0, read);
        }
        return new DownloadedContent(output.ToArray(), response.Content.Headers.ContentType?.MediaType ?? "application/octet-stream", uri);
    }

    private static List<DiscoveredLink> ExtractLinks(byte[] bytes, string pageUrl, string allowedHost)
    {
        var html = Encoding.UTF8.GetString(bytes);
        var result = new List<DiscoveredLink>();
        foreach (Match match in AnchorPattern.Matches(html))
        {
            var href = WebUtility.HtmlDecode(match.Groups[2].Value).Trim();
            var title = CleanTitle(match.Groups[3].Value);
            if (!Uri.TryCreate(new Uri(pageUrl), href, out var uri) || uri.Scheme != Uri.UriSchemeHttps ||
                !(uri.Host.Equals(allowedHost, StringComparison.OrdinalIgnoreCase) ||
                  uri.Host.EndsWith("." + allowedHost, StringComparison.OrdinalIgnoreCase))) continue;
            var candidate = (title + " " + uri.AbsolutePath).ToLowerInvariant();
            if (!Keywords.Any(keyword => candidate.Contains(keyword, StringComparison.OrdinalIgnoreCase))) continue;
            var normalized = uri.GetLeftPart(UriPartial.Query);
            if (result.Any(x => x.Url.Equals(normalized, StringComparison.OrdinalIgnoreCase))) continue;
            result.Add(new DiscoveredLink(normalized, title));
            if (result.Count >= MaxLinksPerSource) break;
        }
        return result;
    }

    private static string CleanTitle(string value) =>
        WebUtility.HtmlDecode(TagPattern.Replace(value, " ")).Replace("&nbsp;", " ", StringComparison.OrdinalIgnoreCase)
            .Replace('\\n', ' ').Replace('\\r', ' ').Trim();

    private static bool IsSupportedContent(string contentType, string url) =>
        contentType.Contains("pdf", StringComparison.OrdinalIgnoreCase) ||
        contentType.Contains("html", StringComparison.OrdinalIgnoreCase) ||
        url.EndsWith(".pdf", StringComparison.OrdinalIgnoreCase);

    private static bool ContainsArabic(string value) => value.Any(c => c is >= '\\u0600' and <= '\\u06FF');
    private static bool IsUrgent(string value) => new[] { "recall", "safety alert", "urgent", "withdrawal", "استدعاء", "تنبيه هام", "تحذير", "سحب" }.Any(x => value.Contains(x, StringComparison.OrdinalIgnoreCase));
    private static string ClassifyTopic(string value)
    {
        if (IsUrgent(value)) return "SafetyOrRecall";
        if (value.Contains("price", StringComparison.OrdinalIgnoreCase) || value.Contains("تسعير")) return "Pricing";
        if (value.Contains("license", StringComparison.OrdinalIgnoreCase) || value.Contains("ترخيص")) return "Licensing";
        if (value.Contains("track", StringComparison.OrdinalIgnoreCase) || value.Contains("تتبع")) return "Traceability";
        if (value.Contains("guideline", StringComparison.OrdinalIgnoreCase) || value.Contains("دليل")) return "Guidance";
        return "RegulatoryOrMarketUpdate";
    }

    private static string[] ClassifyModules(string value)
    {
        var modules = new List<string>();
        if (new[] { "medicine", "drug", "pharmaceutical", "دواء", "دوائي" }.Any(x => value.Contains(x, StringComparison.OrdinalIgnoreCase))) modules.Add("RegularMedicines");
        if (new[] { "chemotherapy", "oncology", "cytotoxic", "أورام", "كيماوي" }.Any(x => value.Contains(x, StringComparison.OrdinalIgnoreCase))) modules.Add("Chemotherapy");
        if (new[] { "medical device", "medical supply", "device", "مستلزمات طبية", "أجهزة طبية" }.Any(x => value.Contains(x, StringComparison.OrdinalIgnoreCase))) modules.Add("MedicalSupplies");
        if (new[] { "cosmetic", "cosmetics", "مستحضرات تجميل" }.Any(x => value.Contains(x, StringComparison.OrdinalIgnoreCase))) modules.Add("Cosmetics");
        return modules.Count == 0 ? ["AllPharmacyModulesReview"] : modules.ToArray();
    }

    private sealed record DiscoveredLink(string Url, string Title);
    private sealed record DownloadedContent(byte[] Bytes, string ContentType, Uri FinalUri);
}
