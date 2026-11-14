namespace Sgsctr.Api.Data;

public sealed class UnitOfMeasure
{
    public Guid Id { get; set; }
    public string Code { get; set; } = string.Empty;
    public string Name { get; set; } = string.Empty;
    public string? Symbol { get; set; }
    public DateTimeOffset CreatedAtUtc { get; set; }
    public string CreatedBySubject { get; set; } = string.Empty;
}
