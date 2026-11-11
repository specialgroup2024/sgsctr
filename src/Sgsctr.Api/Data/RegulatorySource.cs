namespace Sgsctr.Api.Data;

public sealed class RegulatorySource
{
    public Guid Id { get; set; }
    public string Code { get; set; } = "";
    public string Name { get; set; } = "";
    public string Url { get; set; } = "";
    public string AllowedHost { get; set; } = "";
    public string SourceClass { get; set; } = "B";
    public bool IsEnabled { get; set; } = true;
    public int PollIntervalMinutes { get; set; } = 360;
    public DateTimeOffset? LastCheckedAtUtc { get; set; }
    public DateTimeOffset? LastSuccessAtUtc { get; set; }
    public string? LastError { get; set; }
    public DateTimeOffset CreatedAtUtc { get; set; }
    public ICollection<RegulatoryDocument> Documents { get; set; } = new List<RegulatoryDocument>();
    public ICollection<RegulatoryScanRun> ScanRuns { get; set; } = new List<RegulatoryScanRun>();
}
