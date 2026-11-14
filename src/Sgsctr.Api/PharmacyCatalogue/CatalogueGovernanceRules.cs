namespace Sgsctr.Api.PharmacyCatalogue;

public static class CatalogueGovernanceRules
{
    // These are provisional business labels supplied by the owner, not EDA legal classifications.
    public static readonly IReadOnlySet<string> FamilyCodes = new HashSet<string>(StringComparer.Ordinal)
    {
        "RegularMedicine", "Chemotherapy", "MedicalDevice", "MedicalSupply", "Cosmetic"
    };

    // Product/package-level identifiers only. UDI-PI, batch, serial, expiry and EPTTS serial events
    // belong to later lot/package traceability workflows and are deliberately not accepted here.
    public static readonly IReadOnlySet<string> IdentifierSchemes = new HashSet<string>(StringComparer.Ordinal)
    {
        "GTIN", "UDI-DI", "EDA-Registration", "EDA-Cosmetics-Notification"
    };

    public static bool IsAllowedFamilyCode(string? value) =>
        value is not null && FamilyCodes.Contains(value);

    public static bool IsAllowedIdentifierScheme(string? value) =>
        value is not null && IdentifierSchemes.Contains(value);
}
