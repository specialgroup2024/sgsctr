namespace Sgsctr.Api.Data;

public sealed class CatalogueRegulatoryEvidence
{
    public Guid Id { get; set; }
    public Guid ProductId { get; set; }
    public string AuthorityCode { get; set; } = string.Empty;
    public string EvidenceType { get; set; } = string.Empty;
    public string ReferenceNumber { get; set; } = string.Empty;
    public string? DocumentUri { get; set; }
    public Guid? RegulatoryDocumentId { get; set; }
    public DateOnly? PublishedOn { get; set; }
    public DateOnly? EffectiveFrom { get; set; }
    public DateOnly? ExpiresOn { get; set; }
    public string VerificationStatus { get; set; } = "PendingReview";
    public DateTimeOffset CreatedAtUtc { get; set; }
    public string CreatedBySubject { get; set; } = string.Empty;
    public CatalogueProduct Product { get; set; } = null!;
    public RegulatoryDocument? RegulatoryDocument { get; set; }
}
