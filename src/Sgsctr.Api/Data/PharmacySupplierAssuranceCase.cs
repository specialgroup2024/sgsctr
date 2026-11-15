namespace Sgsctr.Api.Data;

/// <summary>
/// Append-only request/gate record for supplier assurance work. It deliberately cannot
/// store an approved verification, qualification, reviewer grant or eligibility outcome.
/// </summary>
public sealed class PharmacySupplierAssuranceCase
{
    public Guid Id { get; set; }
    public Guid SupplierId { get; set; }
    public string CaseType { get; set; } = string.Empty;
    public string Status { get; set; } = "Pending";
    public string RequestedBySubject { get; set; } = string.Empty;
    public DateTimeOffset RequestedAtUtc { get; set; }
    public string Reason { get; set; } = string.Empty;
    public string? ScopeReference { get; set; }
    public Guid? EvidenceId { get; set; }
    public string? BlockerCode { get; set; }
    public string CorrelationId { get; set; } = string.Empty;
    public PharmacySupplier Supplier { get; set; } = null!;
    public PharmacySupplierEvidence? Evidence { get; set; }
}
