namespace Sgsctr.Api.Data;

public sealed class GovernanceApproval
{
    public Guid Id { get; set; }
    public string ApprovalCode { get; set; } = "";
    public string Title { get; set; } = "";
    public string RequiredApproverRole { get; set; } = "";
    public string Status { get; set; } = "Pending";
    public string ScopeDescription { get; set; } = "";
    public string EvidenceReference { get; set; } = "";
    public DateTimeOffset CreatedAtUtc { get; set; }
    public DateTimeOffset UpdatedAtUtc { get; set; }
    public DateTimeOffset? DecisionAtUtc { get; set; }
    public string? DecisionBySubject { get; set; }
    public string? DecisionReference { get; set; }
    public string? DecisionNotes { get; set; }
    public string? Conditions { get; set; }
}
