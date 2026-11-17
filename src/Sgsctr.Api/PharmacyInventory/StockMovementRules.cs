namespace Sgsctr.Api.PharmacyInventory;

/// <summary>
/// Pure domain validation rules for stock movements. No database dependencies.
/// </summary>
public static class StockMovementRules
{
    private static readonly string[] KnownMovementTypes =
    {
        "Receipt", "Issue", "Adjustment", "Count", "TransferIn", "TransferOut", "Return"
    };

    private static readonly string[] KnownStatuses = { "Draft", "Posted", "Reversed" };

    public static bool IsKnownMovementType(string value) =>
        !string.IsNullOrWhiteSpace(value) && KnownMovementTypes.Contains(value.Trim());

    public static bool IsValidStatus(string value) =>
        !string.IsNullOrWhiteSpace(value) && KnownStatuses.Contains(value.Trim());

    public static bool IsValidQuantity(decimal quantity) =>
        quantity != 0m && Math.Abs(quantity) <= 9_999_999_999_999m;

    public static bool IsValidLotNumber(string? lotNumber)
    {
        if (string.IsNullOrWhiteSpace(lotNumber)) return true;
        var trimmed = lotNumber.Trim();
        return trimmed.Length <= 64;
    }

    public static bool IsValidReason(string reason) =>
        !string.IsNullOrWhiteSpace(reason) && reason.Trim().Length <= 500;

    public static bool CanPost(string status) => status == "Draft";

    public static bool CanReverse(string status) => status == "Posted";

    public static bool IsValidReference(string? reference)
    {
        if (string.IsNullOrWhiteSpace(reference)) return true;
        return reference.Trim().Length <= 200;
    }
}