namespace Sgsctr.Api.PharmacySuppliers;

public static class SupplierAssuranceRules
{
    public const string LegalLicenceVerification = "LegalLicenceVerification";
    public const string DueDiligenceExecution = "DueDiligenceExecution";
    public const string ReviewerAuthorityApplication = "ReviewerAuthorityApplication";
    public const string QualificationReview = "QualificationReview";
    public const string PurchasingEligibilityEvaluation = "PurchasingEligibilityEvaluation";
    public const string ReceivingEligibilityEvaluation = "ReceivingEligibilityEvaluation";

    public static bool IsKnownCaseType(string? value) => value is
        LegalLicenceVerification or DueDiligenceExecution or ReviewerAuthorityApplication or
        QualificationReview or PurchasingEligibilityEvaluation or ReceivingEligibilityEvaluation;

    public static bool IsEligibilityCase(string? value) =>
        value is PurchasingEligibilityEvaluation or ReceivingEligibilityEvaluation;

    public static bool IsValidRequest(string? caseType, string? reason, string? scopeReference) =>
        IsKnownCaseType(caseType) &&
        !string.IsNullOrWhiteSpace(reason) && reason.Trim().Length <= 500 &&
        (scopeReference is null || scopeReference.Trim().Length <= 200);

    public static (string Status, string? BlockerCode) InitialState(string caseType) =>
        IsEligibilityCase(caseType)
            ? ("Blocked", "POLICY_AND_QUALIFICATION_NOT_APPROVED")
            : ("Pending", null);
}
