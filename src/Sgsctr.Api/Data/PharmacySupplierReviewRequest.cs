namespace Sgsctr.Api.Data;

public sealed class PharmacySupplierReviewRequest
{
    public Guid Id { get; set; }
    public Guid SupplierId { get; set; }
    public string Status { get; set; } = "Pending";
    public string RequestedBySubject { get; set; } = string.Empty;
    public DateTimeOffset RequestedAtUtc { get; set; }
    public string Reason { get; set; } = string.Empty;
    public string CorrelationId { get; set; } = string.Empty;
    public PharmacySupplier Supplier { get; set; } = null!;
}
