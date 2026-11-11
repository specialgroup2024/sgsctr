namespace Sgsctr.Api.Data;

public sealed class RegulatoryDocument
{
    public Guid Id { get; set; }
    public Guid SourceId { get; set; }
    public RegulatorySource? Source { get; set; }
    public string Title { get; set; } = "";
    public string SourceUrl { get; set; } = "";
    public string ContentHash { get; set; } = "";
    public string ContentType { get; set; } = "text/html";
    public string Language { get; set; } = "und";
    public string SourceClass { get; set; } = "B";
    public string Topic { get; set; } = "Unclassified";
    public string Modules { get; set; } = "[]";
    public string VerificationStatus { get; set; } = "Unverified";
    public string ReviewStatus { get; set; } = "Pending";
    public string Severity { get; set; } = "ReviewRequired";
    public DateTimeOffset? PublishedAtUtc { get; set; }
    public DateTimeOffset RetrievedAtUtc { get; set; }
    public byte[] OriginalContent { get; set; } = [];
    public RegulatoryAlert? Alert { get; set; }
}
