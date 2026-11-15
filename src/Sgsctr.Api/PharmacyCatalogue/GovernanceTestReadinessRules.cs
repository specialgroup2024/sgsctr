namespace Sgsctr.Api.PharmacyCatalogue;

public static class GovernanceTestReadinessRules
{
    public static Dictionary<string, string[]>? Validate(
        bool executionBlocked, string status, string? evidenceReference, string? notes)
    {
        var errors = new Dictionary<string, string[]>();
        if (status is not ("Passed" or "Failed" or "Blocked"))
            errors["status"] = ["Choose Passed, Failed or Blocked."];
        if (executionBlocked && status != "Blocked")
            errors["status"] = ["This test is blocked by an unresolved approval or implementation dependency; it cannot be marked Passed or Failed."];
        if (status == "Passed" && string.IsNullOrWhiteSpace(evidenceReference))
            errors["evidenceReference"] = ["A verifiable evidence reference is required for a passed test."];
        if (status is "Failed" or "Blocked" && string.IsNullOrWhiteSpace(notes))
            errors["notes"] = ["Explain the failure or blocking reason."];
        if (evidenceReference?.Length > 500)
            errors["evidenceReference"] = ["Evidence reference must be at most 500 characters."];
        if (notes?.Length > 2000)
            errors["notes"] = ["Notes must be at most 2000 characters."];
        return errors.Count == 0 ? null : errors;
    }
}
