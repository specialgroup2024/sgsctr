using Sgsctr.Api.PharmacyCatalogue;
using Xunit;

namespace Sgsctr.Api.Tests;

public sealed class GovernanceTestReadinessRulesTests
{
    [Fact]
    public void Passed_requires_evidence_reference() =>
        Assert.NotNull(GovernanceTestReadinessRules.Validate(false, "Passed", null, null));

    [Fact]
    public void Passed_with_evidence_is_valid() =>
        Assert.Null(GovernanceTestReadinessRules.Validate(false, "Passed", "CI-RUN-123", null));

    [Theory]
    [InlineData("Failed")]
    [InlineData("Blocked")]
    public void Failed_or_blocked_requires_notes(string status) =>
        Assert.NotNull(GovernanceTestReadinessRules.Validate(false, status, null, null));

    [Theory]
    [InlineData("Passed")]
    [InlineData("Failed")]
    public void Approval_blocked_test_cannot_be_passed_or_failed(string status) =>
        Assert.NotNull(GovernanceTestReadinessRules.Validate(true, status, "EVIDENCE-1", "Review pending"));

    [Fact]
    public void Approval_blocked_test_can_record_blocker() =>
        Assert.Null(GovernanceTestReadinessRules.Validate(true, "Blocked", null, "Awaiting qualified reviewer"));

    [Fact]
    public void Unknown_status_is_rejected() =>
        Assert.NotNull(GovernanceTestReadinessRules.Validate(false, "DemoApproved", "EVIDENCE-1", null));
}
