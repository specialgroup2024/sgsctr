using Xunit;
using Sgsctr.Api.PharmacyCatalogue;

namespace Sgsctr.Api.Tests;

public sealed class CatalogueRulesTests
{
    [Theory]
    [InlineData(2, 4, 1, 2)]
    [InlineData(24, 6, 4, 1)]
    [InlineData(7, 9, 7, 9)]
    public void TryNormalizeRatio_ReducesPositiveRatio(long numerator, long denominator, long expectedNumerator, long expectedDenominator)
    {
        var result = CatalogueRules.TryNormalizeRatio(numerator, denominator, out var actualNumerator, out var actualDenominator);

        Assert.True(result);
        Assert.Equal(expectedNumerator, actualNumerator);
        Assert.Equal(expectedDenominator, actualDenominator);
    }

    [Theory]
    [InlineData(0, 1)]
    [InlineData(1, 0)]
    [InlineData(-1, 2)]
    [InlineData(2, -1)]
    [InlineData(9_007_199_254_740_992, 1)]
    public void TryNormalizeRatio_RejectsNonPositiveValues(long numerator, long denominator)
    {
        Assert.False(CatalogueRules.TryNormalizeRatio(numerator, denominator, out _, out _));
    }

    [Fact]
    public void NormalizeUnitCode_TrimsAndUppercases()
    {
        Assert.Equal("EA", CatalogueRules.NormalizeUnitCode(" ea "));
    }
}
