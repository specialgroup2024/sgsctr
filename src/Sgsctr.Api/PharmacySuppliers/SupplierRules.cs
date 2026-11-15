namespace Sgsctr.Api.PharmacySuppliers;

public static class SupplierRules
{
    public static string NormalizeCode(string value) => value.Trim().ToUpperInvariant();

    public static bool IsValidCode(string? value) =>
        !string.IsNullOrWhiteSpace(value) &&
        value.Trim().Length is >= 2 and <= 32 &&
        value.Trim().All(c => char.IsAsciiLetterOrDigit(c) || c is '-' or '_');

    public static bool IsValidDisplayName(string? value) =>
        !string.IsNullOrWhiteSpace(value) && value.Trim().Length <= 200;

    public static bool IsValidEvidence(string? kind, string? title, string? reason) =>
        !string.IsNullOrWhiteSpace(kind) && kind.Trim().Length <= 80 &&
        !string.IsNullOrWhiteSpace(title) && title.Trim().Length <= 200 &&
        !string.IsNullOrWhiteSpace(reason) && reason.Trim().Length <= 500;
}
