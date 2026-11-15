using Sgsctr.Api.PharmacySuppliers;
using Xunit;

namespace Sgsctr.Api.Tests;

public sealed class SupplierRulesTests
{
    [Theory]
    [InlineData(" sg-001 ", "SG-001")]
    [InlineData("pharm_22", "PHARM_22")]
    public void NormalizeCode_TrimsAndUppercases(string input, string expected) =>
        Assert.Equal(expected, SupplierRules.NormalizeCode(input));

    [Theory]
    [InlineData("A")]
    [InlineData("")]
    [InlineData("   ")]
    [InlineData("SUPPLIER/01")]
    [InlineData("SUPPLIER 01")]
    public void IsValidCode_RejectsInvalidValues(string input) =>
        Assert.False(SupplierRules.IsValidCode(input));

    [Theory]
    [InlineData("SUP-01")]
    [InlineData("ABC_2")]
    public void IsValidCode_AcceptsSafeCodes(string input) =>
        Assert.True(SupplierRules.IsValidCode(input));

    [Fact]
    public void IsValidDisplayName_RequiresNonEmptyNameWithinLimit()
    {
        Assert.True(SupplierRules.IsValidDisplayName("Example supplier"));
        Assert.False(SupplierRules.IsValidDisplayName(" "));
        Assert.False(SupplierRules.IsValidDisplayName(new string('x', 201)));
    }

    [Theory]
    [InlineData("LegalName")]
    [InlineData("RegistrationNumber")]
    [InlineData("LicenceNumber")]
    public void IsValidDeclaration_AcceptsSupportedOwnerDeclaredFields(string field) =>
        Assert.True(SupplierRules.IsValidDeclaration(field, "Supplier-declared value", "Initial capture"));

    [Fact]
    public void IsValidDeclaration_RejectsUnknownOrOversizedValues()
    {
        Assert.False(SupplierRules.IsValidDeclaration("VerifiedStatus", "Approved", "Reason"));
        Assert.False(SupplierRules.IsValidDeclaration("LegalName", new string('x', 501), "Reason"));
        Assert.False(SupplierRules.IsValidDeclaration("LegalName", "Name", " "));
    }

    [Fact]
    public void IsValidBusinessContact_RequiresBusinessChannelAndDepartment()
    {
        Assert.True(SupplierRules.IsValidBusinessContact("DepartmentEmail", "procurement@example.test", "Procurement", true, "Initial capture"));
        Assert.False(SupplierRules.IsValidBusinessContact("DepartmentEmail", "procurement@example.test", "Procurement", false, "Initial capture"));
        Assert.False(SupplierRules.IsValidBusinessContact("PersonalMobile", "01000000000", "General", true, "Reason"));
        Assert.False(SupplierRules.IsValidBusinessContact("DepartmentEmail", "name@example.test", "Individual", true, "Reason"));
        Assert.False(SupplierRules.IsValidBusinessContact("DepartmentEmail", "not-an-email", "General", true, "Reason"));
        Assert.False(SupplierRules.IsValidBusinessContact("BusinessWebsite", "javascript:alert(1)", "General", true, "Reason"));
        Assert.False(SupplierRules.IsValidBusinessContact("BusinessPhone", "123", "General", true, "Reason"));
        Assert.True(SupplierRules.IsValidBusinessContact("BusinessPhone", "+20 (2) 1234-5678", "General", true, "Initial capture"));
        Assert.True(SupplierRules.IsValidBusinessContact("BusinessWebsite", "https://supplier.example.test", "General", true, "Initial capture"));
        Assert.False(SupplierRules.IsValidBusinessContact("DepartmentEmail", "mail@example.test", "General", true, " "));
    }

    [Fact]
    public void IsValidEvidence_RequiresKindTitleAndReason()
    {
        Assert.True(SupplierRules.IsValidEvidence("Business document", "Supplier-provided document", "Initial capture"));
        Assert.False(SupplierRules.IsValidEvidence("", "Title", "Reason"));
        Assert.False(SupplierRules.IsValidEvidence("Kind", "", "Reason"));
        Assert.False(SupplierRules.IsValidEvidence("Kind", "Title", " "));
    }
    [Fact]
    public void IsValidCode_AcceptsMaximumLengthAndRejectsOverflow()
    {
        Assert.True(SupplierRules.IsValidCode(new string('a', 32)));
        Assert.False(SupplierRules.IsValidCode(new string('a', 33)));
    }

    [Fact]
    public void IsValidDisplayName_AcceptsMaximumLengthAndRejectsOverflow()
    {
        Assert.True(SupplierRules.IsValidDisplayName(new string('x', 200)));
        Assert.False(SupplierRules.IsValidDisplayName(new string('x', 201)));
    }

    [Fact]
    public void IsValidEvidence_EnforcesAllFieldLimits()
    {
        Assert.True(SupplierRules.IsValidEvidence(new string('k', 80), new string('t', 200), new string('r', 500)));
        Assert.False(SupplierRules.IsValidEvidence(new string('k', 81), "Title", "Reason"));
        Assert.False(SupplierRules.IsValidEvidence("Kind", new string('t', 201), "Reason"));
        Assert.False(SupplierRules.IsValidEvidence("Kind", "Title", new string('r', 501)));
    }

}
