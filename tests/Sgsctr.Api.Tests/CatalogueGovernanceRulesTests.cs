using Xunit;
using Sgsctr.Api.PharmacyCatalogue;

namespace Sgsctr.Api.Tests;

public sealed class CatalogueGovernanceRulesTests
{
    [Theory]
    [InlineData("RegularMedicine")]
    [InlineData("Chemotherapy")]
    [InlineData("MedicalDevice")]
    [InlineData("MedicalSupply")]
    [InlineData("Cosmetic")]
    public void IsAllowedFamilyCode_AcceptsProvisionalOwnerFamily(string value) =>
        Assert.True(CatalogueGovernanceRules.IsAllowedFamilyCode(value));

    [Theory]
    [InlineData("UDI-PI")]
    [InlineData("EPTTS-Serial")]
    [InlineData("Unknown")]
    [InlineData("")]
    public void IsAllowedFamilyCode_RejectsUnsupportedFamily(string value) =>
        Assert.False(CatalogueGovernanceRules.IsAllowedFamilyCode(value));

    [Theory]
    [InlineData("GTIN")]
    [InlineData("UDI-DI")]
    [InlineData("EDA-Registration")]
    [InlineData("EDA-Cosmetics-Notification")]
    public void IsAllowedIdentifierScheme_AcceptsProductLevelIdentifier(string value) =>
        Assert.True(CatalogueGovernanceRules.IsAllowedIdentifierScheme(value));

    [Theory]
    [InlineData("UDI-PI")]
    [InlineData("EPTTS-Serial")]
    [InlineData("Batch")]
    [InlineData("Expiry")]
    [InlineData("Unknown")]
    public void IsAllowedIdentifierScheme_RejectsTraceabilityValues(string value) =>
        Assert.False(CatalogueGovernanceRules.IsAllowedIdentifierScheme(value));
}
