namespace Sgsctr.Api.Data;

/// <summary>Supplier-declared legal identity and licence metadata; never independently verified.</summary>
public sealed class PharmacySupplierDeclaration
{
    public Guid Id { get; set; }
    public Guid SupplierId { get; set; }
    public string ClaimType { get; set; } = string.Empty;
    public string DeclaredValue { get; set; } = string.Empty;
    public string Provenance { get; set; } = "OwnerProvided";
    public string ReviewStatus { get; set; } = "Unverified";
    public string AddedBySubject { get; set; } = string.Empty;
    public DateTimeOffset AddedAtUtc { get; set; }
    public string ChangeReason { get; set; } = string.Empty;
    public PharmacySupplier Supplier { get; set; } = null!;
}

/// <summary>Department-level business channel only; must not identify a natural person.</summary>
public sealed class PharmacySupplierBusinessContact
{
    public Guid Id { get; set; }
    public Guid SupplierId { get; set; }
    public string ChannelType { get; set; } = string.Empty;
    public string ChannelValue { get; set; } = string.Empty;
    public string DepartmentLabel { get; set; } = string.Empty;
    public bool BusinessUseConfirmed { get; set; }
    public string AddedBySubject { get; set; } = string.Empty;
    public DateTimeOffset AddedAtUtc { get; set; }
    public string ChangeReason { get; set; } = string.Empty;
    public PharmacySupplier Supplier { get; set; } = null!;
}

/// <summary>Intake-only due-diligence case. No checklist, risk score or decision is implied.</summary>
public sealed class PharmacySupplierDueDiligenceCase
{
    public Guid Id { get; set; }
    public Guid SupplierId { get; set; }
    public string Status { get; set; } = "Pending";
    public string RequestedBySubject { get; set; } = string.Empty;
    public DateTimeOffset RequestedAtUtc { get; set; }
    public string RequestReason { get; set; } = string.Empty;
    public string CorrelationId { get; set; } = string.Empty;
    public PharmacySupplier Supplier { get; set; } = null!;
}
