using Xunit;
using Sgsctr.Api.PharmacyInventory;

namespace Sgsctr.Api.Tests;

public sealed class StockTransferRequestRulesTests
{
    [Theory]
    [InlineData("Draft")]
    [InlineData("Submitted")]
    [InlineData("PendingApproval")]
    [InlineData("Approved")]
    [InlineData("Rejected")]
    [InlineData("Cancelled")]
    public void IsValidStatus_AcceptsDefinedStatuses(string value)
    {
        Assert.True(StockTransferRequestRules.IsValidStatus(value));
    }

    [Theory]
    [InlineData("")]
    [InlineData("   ")]
    [InlineData("Unknown")]
    [InlineData("draft")]
    [InlineData("Posted")]
    public void IsValidStatus_RejectsUnknownStatuses(string value)
    {
        Assert.False(StockTransferRequestRules.IsValidStatus(value));
    }

    [Theory]
    [InlineData(1)]
    [InlineData(100)]
    [InlineData(0.001)]
    public void IsValidQuantity_AcceptsPositiveWithinRange(decimal quantity)
    {
        Assert.True(StockTransferRequestRules.IsValidQuantity(quantity));
    }

    [Fact]
    public void IsValidQuantity_AcceptsLargeDecimal()
    {
        Assert.True(StockTransferRequestRules.IsValidQuantity(9_999_999_999_999m));
    }

    [Theory]
    [InlineData(0)]
    [InlineData(-1)]
    public void IsValidQuantity_RejectsZeroAndNegative(decimal quantity)
    {
        Assert.False(StockTransferRequestRules.IsValidQuantity(quantity));
    }

    [Fact]
    public void IsValidQuantity_RejectsOutOfRange()
    {
        Assert.False(StockTransferRequestRules.IsValidQuantity(10_000_000_000_000m));
    }

    [Theory]
    [InlineData("")]
    [InlineData("Branch replenishment")]
    public void IsValidReason_AcceptsValidOrEmpty(string reason)
    {
        Assert.True(StockTransferRequestRules.IsValidReason(reason));
    }

    [Fact]
    public void IsValidReason_AcceptsNull()
    {
        Assert.True(StockTransferRequestRules.IsValidReason(null));
    }

    [Fact]
    public void IsValidReason_RejectsOverLimit()
    {
        var overLimit = new string('x', 501);
        Assert.False(StockTransferRequestRules.IsValidReason(overLimit));
    }

    [Theory]
    [InlineData("")]
    [InlineData("LOT-001")]
    public void IsValidLotNumber_AcceptsValidOrEmpty(string lotNumber)
    {
        Assert.True(StockTransferRequestRules.IsValidLotNumber(lotNumber));
    }

    [Fact]
    public void IsValidLotNumber_AcceptsNull()
    {
        Assert.True(StockTransferRequestRules.IsValidLotNumber(null));
    }

    [Fact]
    public void IsValidLotNumber_RejectsOverLimit()
    {
        var overLimit = new string('x', 65);
        Assert.False(StockTransferRequestRules.IsValidLotNumber(overLimit));
    }

    [Fact]
    public void AreLocationsDistinct_AcceptsDifferentLocations()
    {
        Assert.True(StockTransferRequestRules.AreLocationsDistinct(
            Guid.Parse("00000000-0000-0000-0000-000000000001"),
            Guid.Parse("00000000-0000-0000-0000-000000000002")));
    }

    [Fact]
    public void AreLocationsDistinct_RejectsSameLocation()
    {
        var sameLocation = Guid.Parse("00000000-0000-0000-0000-000000000001");
        Assert.False(StockTransferRequestRules.AreLocationsDistinct(sameLocation, sameLocation));
    }

    [Fact]
    public void CanSubmit_ReturnsTrueForDraft()
    {
        Assert.True(StockTransferRequestRules.CanSubmit("Draft"));
    }

    [Fact]
    public void CanSubmit_ReturnsFalseForNonDraft()
    {
        Assert.False(StockTransferRequestRules.CanSubmit("Submitted"));
        Assert.False(StockTransferRequestRules.CanSubmit("PendingApproval"));
        Assert.False(StockTransferRequestRules.CanSubmit("Approved"));
        Assert.False(StockTransferRequestRules.CanSubmit("Rejected"));
        Assert.False(StockTransferRequestRules.CanSubmit("Cancelled"));
        Assert.False(StockTransferRequestRules.CanSubmit("Unknown"));
    }

    [Fact]
    public void CanSendForApproval_ReturnsTrueForSubmitted()
    {
        Assert.True(StockTransferRequestRules.CanSendForApproval("Submitted"));
    }

    [Fact]
    public void CanSendForApproval_ReturnsFalseForOtherStatuses()
    {
        Assert.False(StockTransferRequestRules.CanSendForApproval("Draft"));
        Assert.False(StockTransferRequestRules.CanSendForApproval("PendingApproval"));
        Assert.False(StockTransferRequestRules.CanSendForApproval("Approved"));
        Assert.False(StockTransferRequestRules.CanSendForApproval("Rejected"));
        Assert.False(StockTransferRequestRules.CanSendForApproval("Cancelled"));
        Assert.False(StockTransferRequestRules.CanSendForApproval("Unknown"));
    }

    [Fact]
    public void CanApprove_ReturnsTrueForPendingApproval()
    {
        Assert.True(StockTransferRequestRules.CanApprove("PendingApproval"));
    }

    [Fact]
    public void CanApprove_ReturnsFalseForOtherStatuses()
    {
        Assert.False(StockTransferRequestRules.CanApprove("Draft"));
        Assert.False(StockTransferRequestRules.CanApprove("Submitted"));
        Assert.False(StockTransferRequestRules.CanApprove("Approved"));
        Assert.False(StockTransferRequestRules.CanApprove("Rejected"));
        Assert.False(StockTransferRequestRules.CanApprove("Cancelled"));
        Assert.False(StockTransferRequestRules.CanApprove("Unknown"));
    }

    [Fact]
    public void CanReject_ReturnsTrueForPendingApproval()
    {
        Assert.True(StockTransferRequestRules.CanReject("PendingApproval"));
    }

    [Fact]
    public void CanReject_ReturnsFalseForOtherStatuses()
    {
        Assert.False(StockTransferRequestRules.CanReject("Draft"));
        Assert.False(StockTransferRequestRules.CanReject("Submitted"));
        Assert.False(StockTransferRequestRules.CanReject("Approved"));
        Assert.False(StockTransferRequestRules.CanReject("Rejected"));
        Assert.False(StockTransferRequestRules.CanReject("Cancelled"));
        Assert.False(StockTransferRequestRules.CanReject("Unknown"));
    }

    [Theory]
    [InlineData("Draft")]
    [InlineData("Submitted")]
    [InlineData("PendingApproval")]
    public void CanCancel_ReturnsTrueForOpenStatuses(string status)
    {
        Assert.True(StockTransferRequestRules.CanCancel(status));
    }

    [Theory]
    [InlineData("Approved")]
    [InlineData("Rejected")]
    [InlineData("Cancelled")]
    [InlineData("Unknown")]
    public void CanCancel_ReturnsFalseForTerminalStatuses(string status)
    {
        Assert.False(StockTransferRequestRules.CanCancel(status));
    }
}
