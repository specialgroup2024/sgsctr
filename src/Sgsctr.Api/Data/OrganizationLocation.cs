namespace Sgsctr.Api.Data;

public sealed class OrganizationLocation
{
    public Guid Id { get; set; }
    public string Code { get; set; } = string.Empty;
    public string Name { get; set; } = string.Empty;
    public string SectorCode { get; set; } = "PHARMACIES";
    public string LocationType { get; set; } = "Branch";
    public string? Notes { get; set; }
    public string RecordStatus { get; set; } = "OwnerProvided";
    public bool IsActive { get; set; } = true;
    public DateTimeOffset CreatedAtUtc { get; set; }
    public DateTimeOffset UpdatedAtUtc { get; set; }
}
