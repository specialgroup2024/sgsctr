namespace Sgsctr.Api.Data;

public sealed class PharmacyReceiptDraft
{
    public Guid Id { get; set; }
    public Guid LocationId { get; set; }
    public string SupplierReference { get; set; } = string.Empty;
    public string? DeliveryReference { get; set; }
    public string Status { get; set; } = "Draft";
    public string CreatedBySubject { get; set; } = string.Empty;
    public DateTimeOffset CreatedAtUtc { get; set; }
    public string UpdatedBySubject { get; set; } = string.Empty;
    public DateTimeOffset UpdatedAtUtc { get; set; }
    public string ChangeReason { get; set; } = string.Empty;
    public OrganizationLocation Location { get; set; } = null!;
    public ICollection<PharmacyReceiptDraftLine> Lines { get; set; } = new List<PharmacyReceiptDraftLine>();
}
