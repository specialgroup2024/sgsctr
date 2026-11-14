namespace Sgsctr.Api.Data;

public sealed class CatalogueLifecycleRequest
{
    public Guid Id { get; set; }
    public Guid ProductId { get; set; }
    public string RequestedAction { get; set; } = string.Empty;
    public string ReviewStatus { get; set; } = "PendingProfessionalReview";
    public string Reason { get; set; } = string.Empty;
    public DateTimeOffset RequestedAtUtc { get; set; }
    public string RequestedBySubject { get; set; } = string.Empty;
    public CatalogueProduct Product { get; set; } = null!;
}
