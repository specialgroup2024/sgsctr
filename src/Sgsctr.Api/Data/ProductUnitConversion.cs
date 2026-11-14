namespace Sgsctr.Api.Data;

public sealed class ProductUnitConversion
{
    public Guid Id { get; set; }
    public Guid ProductId { get; set; }
    public Guid FromUnitId { get; set; }
    public Guid ToUnitId { get; set; }
    public long Numerator { get; set; }
    public long Denominator { get; set; }
    public string Status { get; set; } = "Draft";
    public DateTimeOffset CreatedAtUtc { get; set; }
    public string CreatedBySubject { get; set; } = string.Empty;
    public CatalogueProduct Product { get; set; } = null!;
    public UnitOfMeasure FromUnit { get; set; } = null!;
    public UnitOfMeasure ToUnit { get; set; } = null!;
}
