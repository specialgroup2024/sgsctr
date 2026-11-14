namespace Sgsctr.Api.PharmacyCatalogue;

public static class CatalogueRules
{
    public static bool TryNormalizeRatio(long numerator, long denominator, out long normalizedNumerator, out long normalizedDenominator)
    {
        normalizedNumerator = 0;
        normalizedDenominator = 0;
        if (numerator <= 0 || denominator <= 0) return false;

        var a = numerator;
        var b = denominator;
        while (b != 0)
        {
            var remainder = a % b;
            a = b;
            b = remainder;
        }

        normalizedNumerator = numerator / a;
        normalizedDenominator = denominator / a;
        return true;
    }

    public static string NormalizeUnitCode(string code) => code.Trim().ToUpperInvariant();
}
