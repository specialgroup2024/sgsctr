using Microsoft.EntityFrameworkCore;

namespace Sgsctr.Api.Data;

/// <summary>Persistence for approved foundation reference data; no pharmacy or accounting transactions.</summary>
public sealed class AppDbContext(DbContextOptions<AppDbContext> options) : DbContext(options)
{
    public DbSet<OrganizationLocation> OrganizationLocations => Set<OrganizationLocation>();
    public DbSet<RegulatorySource> RegulatorySources => Set<RegulatorySource>();
    public DbSet<RegulatoryDocument> RegulatoryDocuments => Set<RegulatoryDocument>();
    public DbSet<RegulatoryAlert> RegulatoryAlerts => Set<RegulatoryAlert>();
    public DbSet<RegulatoryScanRun> RegulatoryScanRuns => Set<RegulatoryScanRun>();
    public DbSet<CatalogueProduct> CatalogueProducts => Set<CatalogueProduct>();
    public DbSet<UnitOfMeasure> UnitsOfMeasure => Set<UnitOfMeasure>();
    public DbSet<ProductUnitConversion> ProductUnitConversions => Set<ProductUnitConversion>();
    public DbSet<CatalogueAuditEvent> CatalogueAuditEvents => Set<CatalogueAuditEvent>();
    public DbSet<CatalogueProductFamilyAssignment> CatalogueProductFamilyAssignments => Set<CatalogueProductFamilyAssignment>();
    public DbSet<CatalogueProductIdentifier> CatalogueProductIdentifiers => Set<CatalogueProductIdentifier>();
    public DbSet<CatalogueRegulatoryEvidence> CatalogueRegulatoryEvidence => Set<CatalogueRegulatoryEvidence>();
    public DbSet<CatalogueLifecycleRequest> CatalogueLifecycleRequests => Set<CatalogueLifecycleRequest>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        var location = modelBuilder.Entity<OrganizationLocation>();
        location.ToTable("OrganizationLocations");
        location.HasKey(x => x.Id);
        location.HasIndex(x => x.Code).IsUnique();
        location.Property(x => x.Code).HasMaxLength(24).IsRequired();
        location.Property(x => x.Name).HasMaxLength(160).IsRequired();
        location.Property(x => x.SectorCode).HasMaxLength(32).IsRequired();
        location.Property(x => x.LocationType).HasMaxLength(32).IsRequired();
        location.Property(x => x.Notes).HasMaxLength(500);
        location.Property(x => x.RecordStatus).HasMaxLength(32).IsRequired();

        var source = modelBuilder.Entity<RegulatorySource>();
        source.ToTable("RegulatorySources");
        source.HasKey(x => x.Id);
        source.HasIndex(x => x.Code).IsUnique();
        source.Property(x => x.Code).HasMaxLength(48).IsRequired();
        source.Property(x => x.Name).HasMaxLength(200).IsRequired();
        source.Property(x => x.Url).HasMaxLength(1000).IsRequired();
        source.Property(x => x.AllowedHost).HasMaxLength(255).IsRequired();
        source.Property(x => x.SourceClass).HasMaxLength(8).IsRequired();
        source.Property(x => x.LastError).HasMaxLength(1000);

        var document = modelBuilder.Entity<RegulatoryDocument>();
        document.ToTable("RegulatoryDocuments");
        document.HasKey(x => x.Id);
        document.HasIndex(x => x.SourceUrl).IsUnique();
        document.HasIndex(x => x.ContentHash).IsUnique();
        document.HasIndex(x => x.SourceId);
        document.HasIndex(x => new { x.ReviewStatus, x.RetrievedAtUtc });
        document.Property(x => x.Title).HasMaxLength(500).IsRequired();
        document.Property(x => x.SourceUrl).HasMaxLength(2000).IsRequired();
        document.Property(x => x.ContentHash).HasMaxLength(64).IsRequired();
        document.Property(x => x.ContentType).HasMaxLength(120).IsRequired();
        document.Property(x => x.Language).HasMaxLength(8).IsRequired();
        document.Property(x => x.SourceClass).HasMaxLength(8).IsRequired();
        document.Property(x => x.Topic).HasMaxLength(80).IsRequired();
        document.Property(x => x.Modules).HasMaxLength(300).IsRequired();
        document.Property(x => x.VerificationStatus).HasMaxLength(32).IsRequired();
        document.Property(x => x.ReviewStatus).HasMaxLength(32).IsRequired();
        document.Property(x => x.Severity).HasMaxLength(32).IsRequired();
        document.Property(x => x.OriginalContent).HasColumnType("bytea").IsRequired();
        document.HasOne(x => x.Source).WithMany(x => x.Documents).HasForeignKey(x => x.SourceId).OnDelete(DeleteBehavior.Restrict);

        var alert = modelBuilder.Entity<RegulatoryAlert>();
        alert.ToTable("RegulatoryAlerts");
        alert.HasKey(x => x.Id);
        alert.HasIndex(x => new { x.Status, x.CreatedAtUtc });
        alert.HasIndex(x => x.DocumentId).IsUnique();
        alert.Property(x => x.AlertType).HasMaxLength(48).IsRequired();
        alert.Property(x => x.Status).HasMaxLength(24).IsRequired();
        alert.Property(x => x.AcknowledgedBy).HasMaxLength(256);
        alert.HasOne(x => x.Document).WithOne(x => x.Alert).HasForeignKey<RegulatoryAlert>(x => x.DocumentId).OnDelete(DeleteBehavior.Cascade);

        var scan = modelBuilder.Entity<RegulatoryScanRun>();
        scan.ToTable("RegulatoryScanRuns");
        scan.HasKey(x => x.Id);
        scan.HasIndex(x => new { x.SourceId, x.StartedAtUtc });
        scan.Property(x => x.Status).HasMaxLength(24).IsRequired();
        scan.Property(x => x.ErrorMessage).HasMaxLength(1000);
        scan.HasOne(x => x.Source).WithMany(x => x.ScanRuns).HasForeignKey(x => x.SourceId).OnDelete(DeleteBehavior.Restrict);
        var product = modelBuilder.Entity<CatalogueProduct>();
        product.ToTable("CatalogueProducts", table => table.HasCheckConstraint("CK_CatalogueProducts_DraftOnly", "\"Status\" = 'Draft'"));
        product.HasKey(x => x.Id);
        product.HasIndex(x => x.DisplayName);
        product.Property(x => x.DisplayName).HasMaxLength(200).IsRequired();
        product.Property(x => x.Status).HasMaxLength(16).IsRequired();
        product.Property(x => x.Version).IsConcurrencyToken();
        product.Property(x => x.CreatedBySubject).HasMaxLength(256).IsRequired();
        product.Property(x => x.UpdatedBySubject).HasMaxLength(256).IsRequired();

        var unit = modelBuilder.Entity<UnitOfMeasure>();
        unit.ToTable("UnitsOfMeasure");
        unit.HasKey(x => x.Id);
        unit.HasIndex(x => x.Code).IsUnique();
        unit.Property(x => x.Code).HasMaxLength(24).IsRequired();
        unit.Property(x => x.Name).HasMaxLength(100).IsRequired();
        unit.Property(x => x.Symbol).HasMaxLength(24);
        unit.Property(x => x.CreatedBySubject).HasMaxLength(256).IsRequired();

        var conversion = modelBuilder.Entity<ProductUnitConversion>();
        conversion.ToTable("ProductUnitConversions", table =>
        {
            table.HasCheckConstraint("CK_ProductUnitConversions_PositiveRatio", "\"Numerator\" > 0 AND \"Denominator\" > 0");
            table.HasCheckConstraint("CK_ProductUnitConversions_DraftOnly", "\"Status\" = 'Draft'");
        });
        conversion.HasKey(x => x.Id);
        conversion.HasIndex(x => new { x.ProductId, x.FromUnitId, x.ToUnitId }).IsUnique();
        conversion.Property(x => x.Numerator).IsRequired();
        conversion.Property(x => x.Denominator).IsRequired();
        conversion.Property(x => x.Status).HasMaxLength(16).IsRequired();
        conversion.Property(x => x.CreatedBySubject).HasMaxLength(256).IsRequired();
        conversion.HasOne(x => x.Product).WithMany(x => x.UnitConversions).HasForeignKey(x => x.ProductId).OnDelete(DeleteBehavior.Restrict);
        conversion.HasOne(x => x.FromUnit).WithMany().HasForeignKey(x => x.FromUnitId).OnDelete(DeleteBehavior.Restrict);
        conversion.HasOne(x => x.ToUnit).WithMany().HasForeignKey(x => x.ToUnitId).OnDelete(DeleteBehavior.Restrict);

        var familyAssignment = modelBuilder.Entity<CatalogueProductFamilyAssignment>();
        familyAssignment.ToTable("CatalogueProductFamilyAssignments", table =>
        {
            table.HasCheckConstraint("CK_CatalogueProductFamilyAssignments_FamilyCode",
                "\"FamilyCode\" IN ('RegularMedicine','Chemotherapy','MedicalDevice','MedicalSupply','Cosmetic')");
            table.HasCheckConstraint("CK_CatalogueProductFamilyAssignments_ReviewStatus",
                "\"ReviewStatus\" = 'PendingProfessionalReview'");
        });
        familyAssignment.HasKey(x => x.Id);
        familyAssignment.HasIndex(x => x.ProductId).IsUnique();
        familyAssignment.Property(x => x.FamilyCode).HasMaxLength(32).IsRequired();
        familyAssignment.Property(x => x.ReviewStatus).HasMaxLength(40).IsRequired();
        familyAssignment.Property(x => x.ProposedBySubject).HasMaxLength(256).IsRequired();
        familyAssignment.HasOne(x => x.Product).WithMany().HasForeignKey(x => x.ProductId).OnDelete(DeleteBehavior.Restrict);

        var identifier = modelBuilder.Entity<CatalogueProductIdentifier>();
        identifier.ToTable("CatalogueProductIdentifiers", table =>
        {
            table.HasCheckConstraint("CK_CatalogueProductIdentifiers_SchemeCode",
                "\"SchemeCode\" IN ('GTIN','UDI-DI','EDA-Registration','EDA-Cosmetics-Notification')");
            table.HasCheckConstraint("CK_CatalogueProductIdentifiers_VerificationStatus",
                "\"VerificationStatus\" = 'PendingVerification'");
        });
        identifier.HasKey(x => x.Id);
        identifier.HasIndex(x => new { x.SchemeCode, x.Value }).IsUnique();
        identifier.HasIndex(x => x.ProductId);
        identifier.Property(x => x.SchemeCode).HasMaxLength(40).IsRequired();
        identifier.Property(x => x.Value).HasMaxLength(160).IsRequired();
        identifier.Property(x => x.PackagingLevel).HasMaxLength(64);
        identifier.Property(x => x.VerificationStatus).HasMaxLength(32).IsRequired();
        identifier.Property(x => x.SourceUri).HasMaxLength(2000);
        identifier.Property(x => x.CreatedBySubject).HasMaxLength(256).IsRequired();
        identifier.HasOne(x => x.Product).WithMany().HasForeignKey(x => x.ProductId).OnDelete(DeleteBehavior.Restrict);

        var evidence = modelBuilder.Entity<CatalogueRegulatoryEvidence>();
        evidence.ToTable("CatalogueRegulatoryEvidence", table =>
            table.HasCheckConstraint("CK_CatalogueRegulatoryEvidence_VerificationStatus",
                "\"VerificationStatus\" = 'PendingReview'"));
        evidence.HasKey(x => x.Id);
        evidence.HasIndex(x => x.ProductId);
        evidence.Property(x => x.AuthorityCode).HasMaxLength(48).IsRequired();
        evidence.Property(x => x.EvidenceType).HasMaxLength(48).IsRequired();
        evidence.Property(x => x.ReferenceNumber).HasMaxLength(160).IsRequired();
        evidence.Property(x => x.DocumentUri).HasMaxLength(2000);
        evidence.Property(x => x.VerificationStatus).HasMaxLength(32).IsRequired();
        evidence.Property(x => x.CreatedBySubject).HasMaxLength(256).IsRequired();
        evidence.HasOne(x => x.Product).WithMany().HasForeignKey(x => x.ProductId).OnDelete(DeleteBehavior.Restrict);
        evidence.HasOne(x => x.RegulatoryDocument).WithMany().HasForeignKey(x => x.RegulatoryDocumentId).OnDelete(DeleteBehavior.Restrict);

        var lifecycle = modelBuilder.Entity<CatalogueLifecycleRequest>();
        lifecycle.ToTable("CatalogueLifecycleRequests", table =>
        {
            table.HasCheckConstraint("CK_CatalogueLifecycleRequests_Action",
                "\"RequestedAction\" IN ('Activate','Retire')");
            table.HasCheckConstraint("CK_CatalogueLifecycleRequests_ReviewStatus",
                "\"ReviewStatus\" = 'PendingProfessionalReview'");
        });
        lifecycle.HasKey(x => x.Id);
        lifecycle.HasIndex(x => new { x.ProductId, x.RequestedAtUtc });
        lifecycle.Property(x => x.RequestedAction).HasMaxLength(16).IsRequired();
        lifecycle.Property(x => x.ReviewStatus).HasMaxLength(40).IsRequired();
        lifecycle.Property(x => x.Reason).HasMaxLength(500).IsRequired();
        lifecycle.Property(x => x.RequestedBySubject).HasMaxLength(256).IsRequired();
        lifecycle.HasOne(x => x.Product).WithMany().HasForeignKey(x => x.ProductId).OnDelete(DeleteBehavior.Restrict);

        var audit = modelBuilder.Entity<CatalogueAuditEvent>();
        audit.ToTable("CatalogueAuditEvents");
        audit.HasKey(x => x.Id);
        audit.HasIndex(x => new { x.ResourceType, x.ResourceId, x.OccurredAtUtc });
        audit.Property(x => x.ActorSubject).HasMaxLength(256).IsRequired();
        audit.Property(x => x.Action).HasMaxLength(48).IsRequired();
        audit.Property(x => x.ResourceType).HasMaxLength(48).IsRequired();
        audit.Property(x => x.Outcome).HasMaxLength(24).IsRequired();
        audit.Property(x => x.Reason).HasMaxLength(500);
        audit.Property(x => x.CorrelationId).HasMaxLength(128).IsRequired();

    }
}
