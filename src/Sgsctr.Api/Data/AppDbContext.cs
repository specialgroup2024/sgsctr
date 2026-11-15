using Microsoft.EntityFrameworkCore;

namespace Sgsctr.Api.Data;

/// <summary>Persistence for approved foundation reference data; no pharmacy or accounting transactions.</summary>
public sealed class AppDbContext(DbContextOptions<AppDbContext> options) : DbContext(options)
{
    public DbSet<OrganizationLocation> OrganizationLocations => Set<OrganizationLocation>();
    public DbSet<PharmacyReceiptDraft> PharmacyReceiptDrafts => Set<PharmacyReceiptDraft>();
    public DbSet<PharmacyReceiptDraftLine> PharmacyReceiptDraftLines => Set<PharmacyReceiptDraftLine>();
    public DbSet<PharmacySupplier> PharmacySuppliers => Set<PharmacySupplier>();
    public DbSet<PharmacySupplierEvidence> PharmacySupplierEvidence => Set<PharmacySupplierEvidence>();
    public DbSet<PharmacySupplierDeclaration> PharmacySupplierDeclarations => Set<PharmacySupplierDeclaration>();
    public DbSet<PharmacySupplierBusinessContact> PharmacySupplierBusinessContacts => Set<PharmacySupplierBusinessContact>();
    public DbSet<PharmacySupplierDueDiligenceCase> PharmacySupplierDueDiligenceCases => Set<PharmacySupplierDueDiligenceCase>();
    public DbSet<PharmacySupplierReviewRequest> PharmacySupplierReviewRequests => Set<PharmacySupplierReviewRequest>();
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
    public DbSet<GovernanceApproval> GovernanceApprovals => Set<GovernanceApproval>();
    public DbSet<GovernanceTestCase> GovernanceTestCases => Set<GovernanceTestCase>();
    public DbSet<GovernanceTestExecution> GovernanceTestExecutions => Set<GovernanceTestExecution>();

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


        var receipt = modelBuilder.Entity<PharmacyReceiptDraft>();
        receipt.ToTable("PharmacyReceiptDrafts", table =>
            table.HasCheckConstraint("CK_PharmacyReceiptDrafts_DraftOnly", "\"Status\" = 'Draft'"));
        receipt.HasKey(x => x.Id);
        receipt.HasIndex(x => new { x.LocationId, x.CreatedAtUtc });
        receipt.Property(x => x.SupplierReference).HasMaxLength(200).IsRequired();
        receipt.Property(x => x.DeliveryReference).HasMaxLength(160);
        receipt.Property(x => x.Status).HasMaxLength(16).IsRequired();
        receipt.Property(x => x.CreatedBySubject).HasMaxLength(256).IsRequired();
        receipt.Property(x => x.UpdatedBySubject).HasMaxLength(256).IsRequired();
        receipt.Property(x => x.ChangeReason).HasMaxLength(500).IsRequired();
        receipt.HasOne(x => x.Location).WithMany().HasForeignKey(x => x.LocationId).OnDelete(DeleteBehavior.Restrict);

        var receiptLine = modelBuilder.Entity<PharmacyReceiptDraftLine>();
        receiptLine.ToTable("PharmacyReceiptDraftLines", table =>
            table.HasCheckConstraint("CK_PharmacyReceiptDraftLines_PositiveQuantity", "\"Quantity\" > 0"));
        receiptLine.HasKey(x => x.Id);
        receiptLine.HasIndex(x => x.ReceiptDraftId);
        receiptLine.Property(x => x.Quantity).HasPrecision(18, 6).IsRequired();
        receiptLine.Property(x => x.SupplierItemReference).HasMaxLength(160);
        receiptLine.HasOne(x => x.ReceiptDraft).WithMany(x => x.Lines).HasForeignKey(x => x.ReceiptDraftId).OnDelete(DeleteBehavior.Restrict);
        receiptLine.HasOne(x => x.Product).WithMany().HasForeignKey(x => x.ProductId).OnDelete(DeleteBehavior.Restrict);
        receiptLine.HasOne(x => x.Unit).WithMany().HasForeignKey(x => x.UnitId).OnDelete(DeleteBehavior.Restrict);

        var supplier = modelBuilder.Entity<PharmacySupplier>();
        supplier.ToTable("PharmacySuppliers", table =>
            table.HasCheckConstraint("CK_PharmacySuppliers_DraftOnly", "\"Status\" = 'Draft'"));
        supplier.HasKey(x => x.Id);
        supplier.HasIndex(x => x.Code).IsUnique();
        supplier.Property(x => x.Code).HasMaxLength(32).IsRequired();
        supplier.Property(x => x.DisplayName).HasMaxLength(200).IsRequired();
        supplier.Property(x => x.Status).HasMaxLength(16).IsRequired();
        supplier.Property(x => x.Version).IsConcurrencyToken();
        supplier.Property(x => x.CreatedBySubject).HasMaxLength(256).IsRequired();
        supplier.Property(x => x.UpdatedBySubject).HasMaxLength(256).IsRequired();
        supplier.Property(x => x.ChangeReason).HasMaxLength(500).IsRequired();

        var supplierDeclaration = modelBuilder.Entity<PharmacySupplierDeclaration>();
        supplierDeclaration.ToTable("PharmacySupplierDeclarations", table =>
        {
            table.HasCheckConstraint("CK_PharmacySupplierDeclarations_OwnerProvidedUnverified",
                "\"Provenance\" = 'OwnerProvided' AND \"ReviewStatus\" = 'Unverified'");
            table.HasCheckConstraint("CK_PharmacySupplierDeclarations_ClaimType",
                "\"ClaimType\" IN ('LegalName','TradingName','LegalForm','Jurisdiction','RegistrationAuthority','RegistrationNumber','TaxReference','RegisteredAddress','LicenceCategory','LicenceHolder','LicenceNumber','LicenceIssuingAuthority','LicenceScope','LicenceIssueDate','LicenceExpiryDate')");
        });
        supplierDeclaration.HasKey(x => x.Id);
        supplierDeclaration.HasIndex(x => new { x.SupplierId, x.ClaimType });
        supplierDeclaration.Property(x => x.ClaimType).HasMaxLength(48).IsRequired();
        supplierDeclaration.Property(x => x.DeclaredValue).HasMaxLength(500).IsRequired();
        supplierDeclaration.Property(x => x.Provenance).HasMaxLength(24).IsRequired();
        supplierDeclaration.Property(x => x.ReviewStatus).HasMaxLength(16).IsRequired();
        supplierDeclaration.Property(x => x.AddedBySubject).HasMaxLength(256).IsRequired();
        supplierDeclaration.Property(x => x.ChangeReason).HasMaxLength(500).IsRequired();
        supplierDeclaration.HasOne(x => x.Supplier).WithMany(x => x.Declarations)
            .HasForeignKey(x => x.SupplierId).OnDelete(DeleteBehavior.Restrict);

        var supplierContact = modelBuilder.Entity<PharmacySupplierBusinessContact>();
        supplierContact.ToTable("PharmacySupplierBusinessContacts", table =>
        {
            table.HasCheckConstraint("CK_PharmacySupplierBusinessContacts_ChannelType",
                "\"ChannelType\" IN ('DepartmentEmail','BusinessPhone','BusinessWebsite')");
        });
        supplierContact.HasKey(x => x.Id);
        supplierContact.HasIndex(x => x.SupplierId);
        supplierContact.Property(x => x.ChannelType).HasMaxLength(32).IsRequired();
        supplierContact.Property(x => x.ChannelValue).HasMaxLength(320).IsRequired();
        supplierContact.Property(x => x.DepartmentLabel).HasMaxLength(80).IsRequired();
        supplierContact.Property(x => x.AddedBySubject).HasMaxLength(256).IsRequired();
        supplierContact.Property(x => x.ChangeReason).HasMaxLength(500).IsRequired();
        supplierContact.HasOne(x => x.Supplier).WithMany(x => x.BusinessContacts)
            .HasForeignKey(x => x.SupplierId).OnDelete(DeleteBehavior.Restrict);

        var dueDiligence = modelBuilder.Entity<PharmacySupplierDueDiligenceCase>();
        dueDiligence.ToTable("PharmacySupplierDueDiligenceCases", table =>
            table.HasCheckConstraint("CK_PharmacySupplierDueDiligenceCases_PendingOnly", "\"Status\" = 'Pending'"));
        dueDiligence.HasKey(x => x.Id);
        dueDiligence.HasIndex(x => x.SupplierId).IsUnique().HasFilter("\"Status\" = 'Pending'");
        dueDiligence.Property(x => x.Status).HasMaxLength(16).IsRequired();
        dueDiligence.Property(x => x.RequestedBySubject).HasMaxLength(256).IsRequired();
        dueDiligence.Property(x => x.RequestReason).HasMaxLength(500).IsRequired();
        dueDiligence.Property(x => x.CorrelationId).HasMaxLength(128).IsRequired();
        dueDiligence.HasOne(x => x.Supplier).WithMany(x => x.DueDiligenceCases)
            .HasForeignKey(x => x.SupplierId).OnDelete(DeleteBehavior.Restrict);

        var supplierEvidence = modelBuilder.Entity<PharmacySupplierEvidence>();
        supplierEvidence.ToTable("PharmacySupplierEvidence", table =>
            table.HasCheckConstraint("CK_PharmacySupplierEvidence_Unverified", "\"VerificationStatus\" = 'Unverified'"));
        supplierEvidence.HasKey(x => x.Id);
        supplierEvidence.HasIndex(x => x.SupplierId);
        supplierEvidence.Property(x => x.EvidenceKind).HasMaxLength(80).IsRequired();
        supplierEvidence.Property(x => x.Title).HasMaxLength(200).IsRequired();
        supplierEvidence.Property(x => x.Issuer).HasMaxLength(200);
        supplierEvidence.Property(x => x.ReferenceNumber).HasMaxLength(120);
        supplierEvidence.Property(x => x.SourceReference).HasMaxLength(1000);
        supplierEvidence.Property(x => x.VerificationStatus).HasMaxLength(16).IsRequired();
        supplierEvidence.Property(x => x.AddedBySubject).HasMaxLength(256).IsRequired();
        supplierEvidence.Property(x => x.ChangeReason).HasMaxLength(500).IsRequired();
        supplierEvidence.HasOne(x => x.Supplier).WithMany(x => x.Evidence)
            .HasForeignKey(x => x.SupplierId).OnDelete(DeleteBehavior.Restrict);

        var supplierReview = modelBuilder.Entity<PharmacySupplierReviewRequest>();
        supplierReview.ToTable("PharmacySupplierReviewRequests", table =>
            table.HasCheckConstraint("CK_PharmacySupplierReviewRequests_PendingOnly", "\"Status\" = 'Pending'"));
        supplierReview.HasKey(x => x.Id);
        supplierReview.HasIndex(x => x.SupplierId).IsUnique().HasFilter("\"Status\" = 'Pending'");
        supplierReview.Property(x => x.Status).HasMaxLength(16).IsRequired();
        supplierReview.Property(x => x.RequestedBySubject).HasMaxLength(256).IsRequired();
        supplierReview.Property(x => x.Reason).HasMaxLength(500).IsRequired();
        supplierReview.Property(x => x.CorrelationId).HasMaxLength(128).IsRequired();
        supplierReview.HasOne(x => x.Supplier).WithMany(x => x.ReviewRequests)
            .HasForeignKey(x => x.SupplierId).OnDelete(DeleteBehavior.Restrict);

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

        var approval = modelBuilder.Entity<GovernanceApproval>();
        approval.ToTable("GovernanceApprovals", table =>
            table.HasCheckConstraint("CK_GovernanceApprovals_Status",
                "\"Status\" IN ('Pending','Approved','ApprovedWithConditions','Rejected','Withdrawn','Superseded')"));
        approval.HasKey(x => x.Id);
        approval.HasIndex(x => x.ApprovalCode).IsUnique();
        approval.HasIndex(x => new { x.Status, x.RequiredApproverRole });
        approval.Property(x => x.ApprovalCode).HasMaxLength(32).IsRequired();
        approval.Property(x => x.Title).HasMaxLength(200).IsRequired();
        approval.Property(x => x.RequiredApproverRole).HasMaxLength(100).IsRequired();
        approval.Property(x => x.Status).HasMaxLength(32).IsRequired();
        approval.Property(x => x.ScopeDescription).HasMaxLength(2000).IsRequired();
        approval.Property(x => x.EvidenceReference).HasMaxLength(500).IsRequired();
        approval.Property(x => x.DecisionBySubject).HasMaxLength(256);
        approval.Property(x => x.DecisionReference).HasMaxLength(500);
        approval.Property(x => x.DecisionNotes).HasMaxLength(2000);
        approval.Property(x => x.Conditions).HasMaxLength(2000);

        var testCase = modelBuilder.Entity<GovernanceTestCase>();
        testCase.ToTable("GovernanceTestCases", table =>
            table.HasCheckConstraint("CK_GovernanceTestCases_TestMode", "\"TestMode\" IN ('Automated','Manual')"));
        testCase.HasKey(x => x.Id);
        testCase.HasIndex(x => x.TestCode).IsUnique();
        testCase.HasIndex(x => x.GateCode);
        testCase.Property(x => x.GateCode).HasMaxLength(32).IsRequired();
        testCase.Property(x => x.TestCode).HasMaxLength(48).IsRequired();
        testCase.Property(x => x.Title).HasMaxLength(200).IsRequired();
        testCase.Property(x => x.Objective).HasMaxLength(1000).IsRequired();
        testCase.Property(x => x.ExpectedResult).HasMaxLength(2000).IsRequired();
        testCase.Property(x => x.TestMode).HasMaxLength(16).IsRequired();
        testCase.Property(x => x.BlockReason).HasMaxLength(1000);

        var testExecution = modelBuilder.Entity<GovernanceTestExecution>();
        testExecution.ToTable("GovernanceTestExecutions", table =>
            table.HasCheckConstraint("CK_GovernanceTestExecutions_Status", "\"Status\" IN ('Passed','Failed','Blocked')"));
        testExecution.HasKey(x => x.Id);
        testExecution.HasIndex(x => new { x.TestCaseId, x.ExecutedAtUtc });
        testExecution.Property(x => x.Status).HasMaxLength(16).IsRequired();
        testExecution.Property(x => x.Environment).HasMaxLength(32).IsRequired();
        testExecution.Property(x => x.EvidenceReference).HasMaxLength(500);
        testExecution.Property(x => x.Notes).HasMaxLength(2000);
        testExecution.Property(x => x.ExecutedBySubject).HasMaxLength(256).IsRequired();
        testExecution.HasOne(x => x.TestCase).WithMany().HasForeignKey(x => x.TestCaseId).OnDelete(DeleteBehavior.Restrict);

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
