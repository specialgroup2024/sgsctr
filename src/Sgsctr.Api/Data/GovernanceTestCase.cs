namespace Sgsctr.Api.Data;

public sealed class GovernanceTestCase
{
    public Guid Id { get; set; }
    public string GateCode { get; set; } = "";
    public string TestCode { get; set; } = "";
    public string Title { get; set; } = "";
    public string Objective { get; set; } = "";
    public string ExpectedResult { get; set; } = "";
    public string TestMode { get; set; } = "Manual";
    public bool ExecutionBlocked { get; set; }
    public string? BlockReason { get; set; }
    public DateTimeOffset CreatedAtUtc { get; set; }
}

public sealed class GovernanceTestExecution
{
    public Guid Id { get; set; }
    public Guid TestCaseId { get; set; }
    public GovernanceTestCase TestCase { get; set; } = null!;
    public string Status { get; set; } = "";
    public string Environment { get; set; } = "";
    public string? EvidenceReference { get; set; }
    public string? Notes { get; set; }
    public DateTimeOffset ExecutedAtUtc { get; set; }
    public string ExecutedBySubject { get; set; } = "";
}
