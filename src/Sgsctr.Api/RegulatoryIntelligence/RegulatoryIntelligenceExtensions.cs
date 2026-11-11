using Microsoft.EntityFrameworkCore;
using Sgsctr.Api.Data;

namespace Sgsctr.Api.RegulatoryIntelligence;

public static class RegulatoryIntelligenceExtensions
{
    public static IServiceCollection AddRegulatoryIntelligence(this IServiceCollection services)
    {
        services.AddHttpClient("eda-regulatory", client =>
        {
            client.Timeout = TimeSpan.FromSeconds(45);
            client.DefaultRequestHeaders.Accept.ParseAdd("text/html,application/pdf");
        }).ConfigurePrimaryHttpMessageHandler(() => new HttpClientHandler { AllowAutoRedirect = false });
        services.AddScoped<IRegulatoryIngestionService, RegulatoryIngestionService>();
        services.AddHostedService<RegulatoryMonitorWorker>();
        return services;
    }

    public static WebApplication MapRegulatoryIntelligenceEndpoints(this WebApplication app)
    {
        var localDevelopmentScan = app.Environment.IsDevelopment() &&
            !app.Configuration.GetValue<bool>("Authentication:Enabled", true);
        var api = app.MapGroup("/api/v1/pharmacy/regulatory-intelligence").RequireAuthorization();

        api.MapGet("/overview", async (System.Security.Claims.ClaimsPrincipal user, AppDbContext db, CancellationToken ct) =>
        {
            var documents = await db.RegulatoryDocuments.AsNoTracking()
                .OrderByDescending(x => x.RetrievedAtUtc).Take(50)
                .Select(x => new
                {
                    x.Id, x.Title, x.SourceUrl, x.ContentType, x.Language, x.SourceClass,
                    x.Topic, x.Modules, x.VerificationStatus, x.ReviewStatus, x.Severity, x.PublishedAtUtc, x.RetrievedAtUtc
                }).ToListAsync(ct);
            var alerts = await db.RegulatoryAlerts.AsNoTracking().Where(x => x.Status == "Unread")
                .OrderByDescending(x => x.CreatedAtUtc).Take(50)
                .Select(x => new { x.Id, x.AlertType, x.Status, x.CreatedAtUtc, documentTitle = x.Document!.Title, documentId = x.DocumentId })
                .ToListAsync(ct);
            var sources = await db.RegulatorySources.AsNoTracking().OrderBy(x => x.Code)
                .Select(x => new { x.Id, x.Code, x.Name, x.Url, x.SourceClass, x.IsEnabled, x.PollIntervalMinutes, x.LastCheckedAtUtc, x.LastSuccessAtUtc, x.LastError })
                .ToListAsync(ct);
            var lastRun = await db.RegulatoryScanRuns.AsNoTracking().OrderByDescending(x => x.StartedAtUtc)
                .Select(x => new { x.StartedAtUtc, x.CompletedAtUtc, x.Status, x.DiscoveredCount, x.NewDocumentCount, x.ErrorMessage })
                .FirstOrDefaultAsync(ct);
            var recentSuccess = sources.Any(x => x.IsEnabled && x.LastSuccessAtUtc >= DateTimeOffset.UtcNow.AddHours(-12));
            var monitoringStatus = !sources.Any(x => x.IsEnabled) ? "No active sources" :
                recentSuccess ? "Source checks active" : "No successful source check in the last 12 hours";
            return Results.Ok(new { documents, alerts, sources, lastRun, monitoringEnabled = recentSuccess,
                monitoringStatus, pollingIntervalMinutes = 15,
                canTriggerScan = localDevelopmentScan || user.IsInRole("Administrator"),
                canAcknowledgeAlerts = localDevelopmentScan || user.IsInRole("Administrator") });
        });

        api.MapPost("/scan", async (IRegulatoryIngestionService monitor, CancellationToken ct) =>
            Results.Ok(await monitor.RunAsync(true, ct)))
            .RequireAuthorization(policy => policy.RequireAssertion(context => localDevelopmentScan || context.User.IsInRole("Administrator")));

        api.MapPost("/alerts/{id:guid}/acknowledge", async (
            Guid id, System.Security.Claims.ClaimsPrincipal user, AppDbContext db, CancellationToken ct) =>
        {
            var alert = await db.RegulatoryAlerts.SingleOrDefaultAsync(x => x.Id == id, ct);
            if (alert is null) return Results.NotFound();
            alert.Status = "Acknowledged";
            alert.AcknowledgedAtUtc = DateTimeOffset.UtcNow;
            alert.AcknowledgedBy = user.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value
                ?? user.FindFirst("sub")?.Value ?? "authenticated-user";
            await db.SaveChangesAsync(ct);
            return Results.NoContent();
        }).RequireAuthorization(policy => policy.RequireAssertion(context => localDevelopmentScan || context.User.IsInRole("Administrator")));

        api.MapGet("/documents/{id:guid}/content", async (Guid id, AppDbContext db, CancellationToken ct) =>
        {
            var document = await db.RegulatoryDocuments.AsNoTracking().SingleOrDefaultAsync(x => x.Id == id, ct);
            if (document is null) return Results.NotFound();
            var extension = document.ContentType.Contains("pdf", StringComparison.OrdinalIgnoreCase) ? ".pdf" : ".html";
            return Results.File(document.OriginalContent, document.ContentType, $"{document.Id}{extension}");
        });
        return app;
    }
}
