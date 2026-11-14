namespace Sgsctr.Api.Data;

public sealed class CatalogueProductIdentifier
{
    public Guid Id { get; set; }
    public Guid ProductId { get; set; }
    public string SchemeCode { get; set; } = string.Empty;
    public string Value { get; set; } = string.Empty;
    public string? PackagingLevel { get; set; }
    public string VerificationStatus { get; set; } = "PendingVerification";
    public string? SourceUri { get; set; }
    public DateTimeOffset CreatedAtUtc { get; set; }
    public string CreatedBySubject { get; set; } = string.Empty;
    public CatalogueProduct Product { get; set; } = null!;
}
