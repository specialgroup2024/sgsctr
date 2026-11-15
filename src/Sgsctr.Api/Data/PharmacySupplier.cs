namespace Sgsctr.Api.Data;

public sealed class PharmacySupplier
{
    public Guid Id { get; set; }
    public string Code { get; set; } = string.Empty;
    public string DisplayName { get; set; } = string.Empty;
    public string Status { get; set; } = "Draft";
    public int Version { get; set; } = 1;
    public string CreatedBySubject { get; set; } = string.Empty;
    public DateTimeOffset CreatedAtUtc { get; set; }
    public string UpdatedBySubject { get; set; } = string.Empty;
    public DateTimeOffset UpdatedAtUtc { get; set; }
    public string ChangeReason { get; set; } = string.Empty;
    public ICollection<PharmacySupplierDeclaration> Declarations { get; set; } = new List<PharmacySupplierDeclaration>();
    public ICollection<PharmacySupplierBusinessContact> BusinessContacts { get; set; } = new List<PharmacySupplierBusinessContact>();
    public ICollection<PharmacySupplierDueDiligenceCase> DueDiligenceCases { get; set; } = new List<PharmacySupplierDueDiligenceCase>();
    public ICollection<PharmacySupplierEvidence> Evidence { get; set; } = new List<PharmacySupplierEvidence>();
    public ICollection<PharmacySupplierReviewRequest> ReviewRequests { get; set; } = new List<PharmacySupplierReviewRequest>();
}
