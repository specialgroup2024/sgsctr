namespace Sgsctr.Api.Data;

public sealed class PharmacyReceiptDraftLine
{
    public Guid Id { get; set; }
    public Guid ReceiptDraftId { get; set; }
    public Guid ProductId { get; set; }
    public Guid UnitId { get; set; }
    public decimal Quantity { get; set; }
    public string? SupplierItemReference { get; set; }
    public PharmacyReceiptDraft ReceiptDraft { get; set; } = null!;
    public CatalogueProduct Product { get; set; } = null!;
    public UnitOfMeasure Unit { get; set; } = null!;
}
