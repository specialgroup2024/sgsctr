namespace Sgsctr.Api.Data;

public sealed class RegulatoryScanRun
{
    public Guid Id { get; set; }
    public Guid SourceId { get; set; }
    public RegulatorySource? Source { get; set; }
    public DateTimeOffset StartedAtUtc { get; set; }
    public DateTimeOffset? CompletedAtUtc { get; set; }
    public int DiscoveredCount { get; set; }
    public int NewDocumentCount { get; set; }
    public string Status { get; set; } = "Running";
    public string? ErrorMessage { get; set; }
}
