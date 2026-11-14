namespace Sgsctr.Api.Data;

/// <summary>Append-only at the application layer; retention and tamper-evidence policy remain pending review.</summary>
public sealed class CatalogueAuditEvent
{
    public Guid Id { get; set; }
    public string ActorSubject { get; set; } = string.Empty;
    public string Action { get; set; } = string.Empty;
    public string ResourceType { get; set; } = string.Empty;
    public Guid ResourceId { get; set; }
    public DateTimeOffset OccurredAtUtc { get; set; }
    public string Outcome { get; set; } = "Succeeded";
    public string? Reason { get; set; }
    public string CorrelationId { get; set; } = string.Empty;
}
