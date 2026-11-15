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

    public static bool IsValidDeclaration(string? claimType, string? value, string? reason) =>
        (claimType is "LegalName" or "TradingName" or "LegalForm" or "Jurisdiction" or
            "RegistrationAuthority" or "RegistrationNumber" or "TaxReference" or "RegisteredAddress" or
            "LicenceCategory" or "LicenceHolder" or "LicenceNumber" or "LicenceIssuingAuthority" or
            "LicenceScope" or "LicenceIssueDate" or "LicenceExpiryDate") &&
        !string.IsNullOrWhiteSpace(value) && value.Trim().Length <= 500 &&
        !string.IsNullOrWhiteSpace(reason) && reason.Trim().Length <= 500;

    public static bool IsValidBusinessContact(string? channelType, string? value, string? department,
        bool businessUseConfirmed, string? reason)
    {
        if (!(channelType is "DepartmentEmail" or "BusinessPhone" or "BusinessWebsite") ||
            string.IsNullOrWhiteSpace(value) || value.Trim().Length > 320 ||
            !(department is "Procurement" or "Sales" or "Accounts" or "Regulatory" or "Quality" or "General") ||
            !businessUseConfirmed || string.IsNullOrWhiteSpace(reason) || reason.Trim().Length > 500)
            return false;

        var normalized = value.Trim();
        return channelType switch
        {
            "DepartmentEmail" => System.Net.Mail.MailAddress.TryCreate(normalized, out var email) &&
                string.Equals(email.Address, normalized, StringComparison.OrdinalIgnoreCase),
            "BusinessPhone" => normalized.Count(char.IsAsciiDigit) >= 7 &&
                normalized.All(ch => char.IsAsciiDigit(ch) || ch is '+' or '-' or '(' or ')' or ' ' or '.'),
            "BusinessWebsite" => Uri.TryCreate(normalized, UriKind.Absolute, out var uri) &&
                (uri.Scheme == Uri.UriSchemeHttp || uri.Scheme == Uri.UriSchemeHttps),
            _ => false
        };
    }

    public static bool IsValidEvidence(string? kind, string? title, string? reason) =>
        !string.IsNullOrWhiteSpace(kind) && kind.Trim().Length <= 80 &&
        !string.IsNullOrWhiteSpace(title) && title.Trim().Length <= 200 &&
        !string.IsNullOrWhiteSpace(reason) && reason.Trim().Length <= 500;
}
