using Xunit;
using Sgsctr.Api.PharmacyInventory;

namespace Sgsctr.Api.Tests;

public sealed class StockMovementRulesTests
{
    [Theory]
    [InlineData("Receipt")]
    [InlineData("Issue")]
    [InlineData("Adjustment")]
    [InlineData("Count")]
    [InlineData("TransferIn")]
    [InlineData("TransferOut")]
    [InlineData("Return")]
    public void IsKnownMovementType_AcceptsDefinedTypes(string value)
    {
        Assert.True(StockMovementRules.IsKnownMovementType(value));
    }

    [Theory]
    [InlineData("")]
    [InlineData("   ")]
    [InlineData("Unknown")]
    [InlineData("receipt")]
    [InlineData("PURCHASE")]
    public void IsKnownMovementType_RejectsUnknownTypes(string value)
    {
        Assert.False(StockMovementRules.IsKnownMovementType(value));
    }

    [Theory]
    [InlineData("Draft")]
    [InlineData("Posted")]
    [InlineData("Reversed")]
    public void IsValidStatus_AcceptsDefinedStatuses(string value)
    {
        Assert.True(StockMovementRules.IsValidStatus(value));
    }

    [Theory]
    [InlineData("")]
    [InlineData("   ")]
    [InlineData("Approved")]
    [InlineData("draft")]
    [InlineData("Cancelled")]
    public void IsValidStatus_RejectsUnknownStatuses(string value)
    {
        Assert.False(StockMovementRules.IsValidStatus(value));
    }

    [Theory]
    [InlineData(1)]
    [InlineData(100)]
    [InlineData(-50)]
    public void IsValidQuantity_AcceptsNonZeroWithinRange(decimal quantity)
    {
        Assert.True(StockMovementRules.IsValidQuantity(quantity));
    }

    [Fact]
    public void IsValidQuantity_AcceptsSmallDecimal()
    {
        Assert.True(StockMovementRules.IsValidQuantity(0.001m));
    }

    [Fact]
    public void IsValidQuantity_AcceptsLargeDecimal()
    {
        Assert.True(StockMovementRules.IsValidQuantity(9_999_999_999_999m));
    }

    [Theory]
    [InlineData(0)]
    public void IsValidQuantity_RejectsZero(decimal quantity)
    {
        Assert.False(StockMovementRules.IsValidQuantity(quantity));
    }

    [Fact]
    public void IsValidQuantity_RejectsOutOfRange()
    {
        Assert.False(StockMovementRules.IsValidQuantity(10_000_000_000_000m));
    }

    [Theory]
    [InlineData("")]
    [InlineData("LOT-001")]
    [InlineData("BATCH-2026-01")]
    public void IsValidLotNumber_AcceptsValidOrEmpty(string lotNumber)
    {
        Assert.True(StockMovementRules.IsValidLotNumber(lotNumber));
    }

    [Fact]
    public void IsValidLotNumber_AcceptsNull()
    {
        Assert.True(StockMovementRules.IsValidLotNumber(null));
    }

    [Fact]
    public void IsValidLotNumber_RejectsOverLimit()
    {
        var overLimit = new string('x', 65);
        Assert.False(StockMovementRules.IsValidLotNumber(overLimit));
    }

    [Theory]
    [InlineData("Reason")]
    [InlineData("Stock receipt from supplier")]
    public void IsValidReason_AcceptsValidReasons(string reason)
    {
        Assert.True(StockMovementRules.IsValidReason(reason));
    }

    [Theory]
    [InlineData("")]
    [InlineData("   ")]
    public void IsValidReason_RejectsEmpty(string reason)
    {
        Assert.False(StockMovementRules.IsValidReason(reason));
    }

    [Fact]
    public void IsValidReason_RejectsOverLimit()
    {
        var overLimit = new string('x', 501);
        Assert.False(StockMovementRules.IsValidReason(overLimit));
    }

    [Theory]
    [InlineData("")]
    [InlineData("REF-001")]
    public void IsValidReference_AcceptsValidOrEmpty(string reference)
    {
        Assert.True(StockMovementRules.IsValidReference(reference));
    }

    [Fact]
    public void IsValidReference_AcceptsNull()
    {
        Assert.True(StockMovementRules.IsValidReference(null));
    }

    [Fact]
    public void IsValidReference_RejectsOverLimit()
    {
        var overLimit = new string('x', 201);
        Assert.False(StockMovementRules.IsValidReference(overLimit));
    }

    [Fact]
    public void CanPost_ReturnsTrueForDraft()
    {
        Assert.True(StockMovementRules.CanPost("Draft"));
    }

    [Fact]
    public void CanPost_ReturnsFalseForNonDraft()
    {
        Assert.False(StockMovementRules.CanPost("Posted"));
        Assert.False(StockMovementRules.CanPost("Reversed"));
        Assert.False(StockMovementRules.CanPost("Unknown"));
    }

    [Fact]
    public void CanReverse_ReturnsTrueForPosted()
    {
        Assert.True(StockMovementRules.CanReverse("Posted"));
    }

    [Fact]
    public void CanReverse_ReturnsFalseForNonPosted()
    {
        Assert.False(StockMovementRules.CanReverse("Draft"));
        Assert.False(StockMovementRules.CanReverse("Reversed"));
        Assert.False(StockMovementRules.CanReverse("Unknown"));
    }
}