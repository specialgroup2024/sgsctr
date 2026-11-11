namespace Sgsctr.Api.Data;

public sealed class RegulatoryAlert
{
    public Guid Id { get; set; }
    public Guid DocumentId { get; set; }
    public RegulatoryDocument? Document { get; set; }
    public string AlertType { get; set; } = "NewPublication";
    public string Status { get; set; } = "Unread";
    public DateTimeOffset CreatedAtUtc { get; set; }
    public DateTimeOffset? AcknowledgedAtUtc { get; set; }
    public string? AcknowledgedBy { get; set; }
}
