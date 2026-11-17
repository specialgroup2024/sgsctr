namespace Sgsctr.Api.Data;

/// <summary>
/// Draft-only stock transfer request. Requests in Draft/Submitted/PendingApproval/Rejected/Cancelled
/// status do not affect balances. Approval creates Draft StockMovement entries only; posting to
/// balance-affecting status remains gated pending Q12/Q13 approval.
/// </summary>
public sealed class StockTransferRequest
{
    public Guid Id { get; set; }
    public Guid SourceLocationId { get; set; }
    public Guid DestinationLocationId { get; set; }
    public string Status { get; set; } = "Draft";
    public string? Reason { get; set; }
    public string RequestedBySubject { get; set; } = string.Empty;
    public string? ApprovedBySubject { get; set; }
    public DateTimeOffset RequestedAtUtc { get; set; }
    public DateTimeOffset? ApprovedAtUtc { get; set; }
    public DateTimeOffset UpdatedAtUtc { get; set; }
    public string UpdatedBySubject { get; set; } = string.Empty;

    public OrganizationLocation SourceLocation { get; set; } = null!;
    public OrganizationLocation DestinationLocation { get; set; } = null!;
    public ICollection<StockTransferRequestLine> Lines { get; set; } = new List<StockTransferRequestLine>();
    public ICollection<StockMovement> Movements { get; set; } = new List<StockMovement>();
}

/// <summary>
/// A line within a stock transfer request.
/// </summary>
public sealed class StockTransferRequestLine
{
    public Guid Id { get; set; }
    public Guid StockTransferRequestId { get; set; }
    public Guid ProductId { get; set; }
    public Guid UnitId { get; set; }
    public decimal Quantity { get; set; }
    public string? LotNumber { get; set; }
    public DateOnly? ExpiryDate { get; set; }

    public StockTransferRequest StockTransferRequest { get; set; } = null!;
    public CatalogueProduct Product { get; set; } = null!;
    public UnitOfMeasure Unit { get; set; } = null!;
}