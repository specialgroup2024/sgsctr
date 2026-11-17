namespace Sgsctr.Api.PharmacyInventory;

/// <summary>
/// Pure domain validation rules for stock transfer requests. No database dependencies.
/// </summary>
public static class StockTransferRequestRules
{
    private static readonly string[] KnownStatuses =
    {
        "Draft", "Submitted", "PendingApproval", "Approved", "Rejected", "Cancelled"
    };

    public static bool IsValidStatus(string value) =>
        !string.IsNullOrWhiteSpace(value) && KnownStatuses.Contains(value.Trim());

    public static bool IsValidQuantity(decimal quantity) =>
        quantity > 0m && quantity <= 9_999_999_999_999m;

    public static bool IsValidReason(string? reason) =>
        string.IsNullOrWhiteSpace(reason) || reason.Trim().Length <= 500;

    public static bool IsValidLotNumber(string? lotNumber) =>
        string.IsNullOrWhiteSpace(lotNumber) || lotNumber.Trim().Length <= 64;

    public static bool AreLocationsDistinct(Guid sourceLocationId, Guid destinationLocationId) =>
        sourceLocationId != destinationLocationId;

    public static bool CanSubmit(string status) => status == "Draft";

    public static bool CanSendForApproval(string status) => status == "Submitted";

    public static bool CanApprove(string status) => status == "PendingApproval";

    public static bool CanReject(string status) => status == "PendingApproval";

    public static bool CanCancel(string status) => status is "Draft" or "Submitted" or "PendingApproval";
}