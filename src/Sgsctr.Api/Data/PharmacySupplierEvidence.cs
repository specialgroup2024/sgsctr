namespace Sgsctr.Api.Data;

public sealed class PharmacySupplierEvidence
{
    public Guid Id { get; set; }
    public Guid SupplierId { get; set; }
    public string EvidenceKind { get; set; } = string.Empty;
    public string Title { get; set; } = string.Empty;
    public string? Issuer { get; set; }
    public string? ReferenceNumber { get; set; }
    public string? SourceReference { get; set; }
    public DateOnly? IssuedOn { get; set; }
    public DateOnly? ExpiresOn { get; set; }
    public string VerificationStatus { get; set; } = "Unverified";
    public string AddedBySubject { get; set; } = string.Empty;
    public DateTimeOffset AddedAtUtc { get; set; }
    public string ChangeReason { get; set; } = string.Empty;
    public PharmacySupplier Supplier { get; set; } = null!;
}
