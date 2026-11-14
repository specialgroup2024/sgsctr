namespace Sgsctr.Api.Data;

public sealed class CatalogueProductFamilyAssignment
{
    public Guid Id { get; set; }
    public Guid ProductId { get; set; }
    public string FamilyCode { get; set; } = string.Empty;
    public string ReviewStatus { get; set; } = "PendingProfessionalReview";
    public DateTimeOffset ProposedAtUtc { get; set; }
    public string ProposedBySubject { get; set; } = string.Empty;
    public CatalogueProduct Product { get; set; } = null!;
}
