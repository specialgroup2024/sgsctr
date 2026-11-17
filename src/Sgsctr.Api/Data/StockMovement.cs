namespace Sgsctr.Api.Data;

/// <summary>
/// Append-only stock movement ledger entry. Movements in Draft status do not affect balances.
/// Only Posted movements contribute to computed location/product/lot balances.
/// Reversal movements link back to the original via ReversalOfId.
/// </summary>
public sealed class StockMovement
{
    public Guid Id { get; set; }
    public Guid LocationId { get; set; }
    public Guid ProductId { get; set; }
    public Guid UnitId { get; set; }
    public decimal Quantity { get; set; }
    public string MovementType { get; set; } = string.Empty;
    public string? LotNumber { get; set; }
    public DateOnly? ExpiryDate { get; set; }
    public string? Reference { get; set; }
    public string Reason { get; set; } = string.Empty;
    public string Status { get; set; } = "Draft";
    public Guid? ReversalOfId { get; set; }
    public Guid? StockTransferRequestId { get; set; }
    public string CreatedBySubject { get; set; } = string.Empty;
    public DateTimeOffset CreatedAtUtc { get; set; }

    public OrganizationLocation Location { get; set; } = null!;
    public CatalogueProduct Product { get; set; } = null!;
    public UnitOfMeasure Unit { get; set; } = null!;
    public StockMovement? ReversalOf { get; set; }
    public ICollection<StockMovement> Reversals { get; set; } = new List<StockMovement>();
}