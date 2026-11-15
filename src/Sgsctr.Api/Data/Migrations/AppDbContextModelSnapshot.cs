using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Metadata;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;
using Sgsctr.Api.Data;

namespace Sgsctr.Api.Data.Migrations;

[DbContext(typeof(AppDbContext))]
public sealed class AppDbContextModelSnapshot : ModelSnapshot
{
    protected override void BuildModel(ModelBuilder modelBuilder)
    {
        modelBuilder
            .HasAnnotation("ProductVersion", "10.0.4")
            .HasAnnotation("Relational:MaxIdentifierLength", 63);
        NpgsqlModelBuilderExtensions.UseIdentityByDefaultColumns(modelBuilder);

        modelBuilder.Entity<OrganizationLocation>(entity =>
        {
            entity.Property(x => x.Id)
                .ValueGeneratedOnAdd()
                .HasColumnType("uuid");
            entity.Property(x => x.Code)
                .IsRequired()
                .HasMaxLength(24)
                .HasColumnType("character varying(24)");
            entity.Property(x => x.Name)
                .IsRequired()
                .HasMaxLength(160)
                .HasColumnType("character varying(160)");
            entity.Property(x => x.SectorCode)
                .IsRequired()
                .HasMaxLength(32)
                .HasColumnType("character varying(32)");
            entity.Property(x => x.LocationType)
                .IsRequired()
                .HasMaxLength(32)
                .HasColumnType("character varying(32)");
            entity.Property(x => x.Notes)
                .HasMaxLength(500)
                .HasColumnType("character varying(500)");
            entity.Property(x => x.RecordStatus)
                .IsRequired()
                .HasMaxLength(32)
                .HasColumnType("character varying(32)");
            entity.Property(x => x.IsActive)
                .HasColumnType("boolean");
            entity.Property(x => x.CreatedAtUtc)
                .HasColumnType("timestamp with time zone");
            entity.Property(x => x.UpdatedAtUtc)
                .HasColumnType("timestamp with time zone");
            entity.HasKey(x => x.Id);
            entity.HasIndex(x => x.Code).IsUnique();
            entity.ToTable("OrganizationLocations");
        });

        modelBuilder.Entity<RegulatorySource>(entity =>
        {
            entity.Property(x => x.Id).ValueGeneratedOnAdd().HasColumnType("uuid");
            entity.Property(x => x.Code).IsRequired().HasMaxLength(48).HasColumnType("character varying(48)");
            entity.Property(x => x.Name).IsRequired().HasMaxLength(200).HasColumnType("character varying(200)");
            entity.Property(x => x.Url).IsRequired().HasMaxLength(1000).HasColumnType("character varying(1000)");
            entity.Property(x => x.AllowedHost).IsRequired().HasMaxLength(255).HasColumnType("character varying(255)");
            entity.Property(x => x.SourceClass).IsRequired().HasMaxLength(8).HasColumnType("character varying(8)");
            entity.Property(x => x.IsEnabled).HasColumnType("boolean");
            entity.Property(x => x.PollIntervalMinutes).HasColumnType("integer");
            entity.Property(x => x.LastCheckedAtUtc).HasColumnType("timestamp with time zone");
            entity.Property(x => x.LastSuccessAtUtc).HasColumnType("timestamp with time zone");
            entity.Property(x => x.LastError).HasMaxLength(1000).HasColumnType("character varying(1000)");
            entity.Property(x => x.CreatedAtUtc).HasColumnType("timestamp with time zone");
            entity.HasKey(x => x.Id);
            entity.HasIndex(x => x.Code).IsUnique();
            entity.ToTable("RegulatorySources");
        });

        modelBuilder.Entity<RegulatoryDocument>(entity =>
        {
            entity.Property(x => x.Id).ValueGeneratedOnAdd().HasColumnType("uuid");
            entity.Property(x => x.SourceId).HasColumnType("uuid");
            entity.Property(x => x.Title).IsRequired().HasMaxLength(500).HasColumnType("character varying(500)");
            entity.Property(x => x.SourceUrl).IsRequired().HasMaxLength(2000).HasColumnType("character varying(2000)");
            entity.Property(x => x.ContentHash).IsRequired().HasMaxLength(64).HasColumnType("character varying(64)");
            entity.Property(x => x.ContentType).IsRequired().HasMaxLength(120).HasColumnType("character varying(120)");
            entity.Property(x => x.Language).IsRequired().HasMaxLength(8).HasColumnType("character varying(8)");
            entity.Property(x => x.SourceClass).IsRequired().HasMaxLength(8).HasColumnType("character varying(8)");
            entity.Property(x => x.Topic).IsRequired().HasMaxLength(80).HasColumnType("character varying(80)");
            entity.Property(x => x.Modules).IsRequired().HasMaxLength(300).HasColumnType("character varying(300)");
            entity.Property(x => x.VerificationStatus).IsRequired().HasMaxLength(32).HasColumnType("character varying(32)");
            entity.Property(x => x.ReviewStatus).IsRequired().HasMaxLength(32).HasColumnType("character varying(32)");
            entity.Property(x => x.Severity).IsRequired().HasMaxLength(32).HasColumnType("character varying(32)");
            entity.Property(x => x.PublishedAtUtc).HasColumnType("timestamp with time zone");
            entity.Property(x => x.RetrievedAtUtc).HasColumnType("timestamp with time zone");
            entity.Property(x => x.OriginalContent).IsRequired().HasColumnType("bytea");
            entity.HasKey(x => x.Id);
            entity.HasIndex(x => x.SourceUrl).IsUnique();
            entity.HasIndex(x => x.ContentHash).IsUnique();
            entity.HasIndex(x => x.SourceId);
            entity.HasIndex(x => new { x.ReviewStatus, x.RetrievedAtUtc });
            entity.HasOne(x => x.Source).WithMany(x => x.Documents).HasForeignKey(x => x.SourceId).OnDelete(DeleteBehavior.Restrict);
            entity.ToTable("RegulatoryDocuments");
        });

        modelBuilder.Entity<RegulatoryAlert>(entity =>
        {
            entity.Property(x => x.Id).ValueGeneratedOnAdd().HasColumnType("uuid");
            entity.Property(x => x.DocumentId).HasColumnType("uuid");
            entity.Property(x => x.AlertType).IsRequired().HasMaxLength(48).HasColumnType("character varying(48)");
            entity.Property(x => x.Status).IsRequired().HasMaxLength(24).HasColumnType("character varying(24)");
            entity.Property(x => x.CreatedAtUtc).HasColumnType("timestamp with time zone");
            entity.Property(x => x.AcknowledgedAtUtc).HasColumnType("timestamp with time zone");
            entity.Property(x => x.AcknowledgedBy).HasMaxLength(256).HasColumnType("character varying(256)");
            entity.HasKey(x => x.Id);
            entity.HasIndex(x => new { x.Status, x.CreatedAtUtc });
            entity.HasIndex(x => x.DocumentId).IsUnique();
            entity.HasOne(x => x.Document).WithOne(x => x.Alert).HasForeignKey<RegulatoryAlert>(x => x.DocumentId).OnDelete(DeleteBehavior.Cascade);
            entity.ToTable("RegulatoryAlerts");
        });

        modelBuilder.Entity<RegulatoryScanRun>(entity =>
        {
            entity.Property(x => x.Id).ValueGeneratedOnAdd().HasColumnType("uuid");
            entity.Property(x => x.SourceId).HasColumnType("uuid");
            entity.Property(x => x.StartedAtUtc).HasColumnType("timestamp with time zone");
            entity.Property(x => x.CompletedAtUtc).HasColumnType("timestamp with time zone");
            entity.Property(x => x.DiscoveredCount).HasColumnType("integer");
            entity.Property(x => x.NewDocumentCount).HasColumnType("integer");
            entity.Property(x => x.Status).IsRequired().HasMaxLength(24).HasColumnType("character varying(24)");
            entity.Property(x => x.ErrorMessage).HasMaxLength(1000).HasColumnType("character varying(1000)");
            entity.HasKey(x => x.Id);
            entity.HasIndex(x => new { x.SourceId, x.StartedAtUtc });
            entity.HasOne(x => x.Source).WithMany(x => x.ScanRuns).HasForeignKey(x => x.SourceId).OnDelete(DeleteBehavior.Restrict);
            entity.ToTable("RegulatoryScanRuns");
        });

        modelBuilder.Entity<CatalogueProduct>(entity =>
        {
            entity.Property(x => x.Id).ValueGeneratedOnAdd().HasColumnType("uuid");
            entity.Property(x => x.DisplayName).IsRequired().HasMaxLength(200).HasColumnType("character varying(200)");
            entity.Property(x => x.Status).IsRequired().HasMaxLength(16).HasColumnType("character varying(16)");
            entity.Property(x => x.Version).IsConcurrencyToken().HasColumnType("integer");
            entity.Property(x => x.CreatedAtUtc).HasColumnType("timestamp with time zone");
            entity.Property(x => x.UpdatedAtUtc).HasColumnType("timestamp with time zone");
            entity.Property(x => x.CreatedBySubject).IsRequired().HasMaxLength(256).HasColumnType("character varying(256)");
            entity.Property(x => x.UpdatedBySubject).IsRequired().HasMaxLength(256).HasColumnType("character varying(256)");
            entity.HasKey(x => x.Id);
            entity.HasIndex(x => x.DisplayName);
            entity.ToTable("CatalogueProducts", t => t.HasCheckConstraint("CK_CatalogueProducts_DraftOnly", "\"Status\" = 'Draft'"));
        });

        modelBuilder.Entity<UnitOfMeasure>(entity =>
        {
            entity.Property(x => x.Id).ValueGeneratedOnAdd().HasColumnType("uuid");
            entity.Property(x => x.Code).IsRequired().HasMaxLength(24).HasColumnType("character varying(24)");
            entity.Property(x => x.Name).IsRequired().HasMaxLength(100).HasColumnType("character varying(100)");
            entity.Property(x => x.Symbol).HasMaxLength(24).HasColumnType("character varying(24)");
            entity.Property(x => x.CreatedAtUtc).HasColumnType("timestamp with time zone");
            entity.Property(x => x.CreatedBySubject).IsRequired().HasMaxLength(256).HasColumnType("character varying(256)");
            entity.HasKey(x => x.Id);
            entity.HasIndex(x => x.Code).IsUnique();
            entity.ToTable("UnitsOfMeasure");
        });

        modelBuilder.Entity<ProductUnitConversion>(entity =>
        {
            entity.Property(x => x.Id).ValueGeneratedOnAdd().HasColumnType("uuid");
            entity.Property(x => x.ProductId).HasColumnType("uuid");
            entity.Property(x => x.FromUnitId).HasColumnType("uuid");
            entity.Property(x => x.ToUnitId).HasColumnType("uuid");
            entity.Property(x => x.Numerator).HasColumnType("bigint");
            entity.Property(x => x.Denominator).HasColumnType("bigint");
            entity.Property(x => x.Status).IsRequired().HasMaxLength(16).HasColumnType("character varying(16)");
            entity.Property(x => x.CreatedAtUtc).HasColumnType("timestamp with time zone");
            entity.Property(x => x.CreatedBySubject).IsRequired().HasMaxLength(256).HasColumnType("character varying(256)");
            entity.HasKey(x => x.Id);
            entity.HasIndex(x => new { x.ProductId, x.FromUnitId, x.ToUnitId }).IsUnique();
            entity.HasIndex(x => x.FromUnitId);
            entity.HasIndex(x => x.ToUnitId);
            entity.HasOne(x => x.Product).WithMany(x => x.UnitConversions).HasForeignKey(x => x.ProductId).OnDelete(DeleteBehavior.Restrict);
            entity.HasOne(x => x.FromUnit).WithMany().HasForeignKey(x => x.FromUnitId).OnDelete(DeleteBehavior.Restrict);
            entity.HasOne(x => x.ToUnit).WithMany().HasForeignKey(x => x.ToUnitId).OnDelete(DeleteBehavior.Restrict);
            entity.ToTable("ProductUnitConversions", t =>
            {
                t.HasCheckConstraint("CK_ProductUnitConversions_PositiveRatio", "\"Numerator\" > 0 AND \"Denominator\" > 0");
                t.HasCheckConstraint("CK_ProductUnitConversions_DraftOnly", "\"Status\" = 'Draft'");
            });
        });

        modelBuilder.Entity<CatalogueAuditEvent>(entity =>
        {
            entity.Property(x => x.Id).ValueGeneratedOnAdd().HasColumnType("uuid");
            entity.Property(x => x.ActorSubject).IsRequired().HasMaxLength(256).HasColumnType("character varying(256)");
            entity.Property(x => x.Action).IsRequired().HasMaxLength(48).HasColumnType("character varying(48)");
            entity.Property(x => x.ResourceType).IsRequired().HasMaxLength(48).HasColumnType("character varying(48)");
            entity.Property(x => x.ResourceId).HasColumnType("uuid");
            entity.Property(x => x.OccurredAtUtc).HasColumnType("timestamp with time zone");
            entity.Property(x => x.Outcome).IsRequired().HasMaxLength(24).HasColumnType("character varying(24)");
            entity.Property(x => x.Reason).HasMaxLength(500).HasColumnType("character varying(500)");
            entity.Property(x => x.CorrelationId).IsRequired().HasMaxLength(128).HasColumnType("character varying(128)");
            entity.HasKey(x => x.Id);
            entity.HasIndex(x => new { x.ResourceType, x.ResourceId, x.OccurredAtUtc });
            entity.ToTable("CatalogueAuditEvents");
        });

        modelBuilder.Entity<CatalogueProductFamilyAssignment>(entity =>
        {
            entity.Property(x => x.Id).ValueGeneratedOnAdd().HasColumnType("uuid");
            entity.Property(x => x.ProductId).HasColumnType("uuid");
            entity.Property(x => x.FamilyCode).IsRequired().HasMaxLength(32).HasColumnType("character varying(32)");
            entity.Property(x => x.ReviewStatus).IsRequired().HasMaxLength(40).HasColumnType("character varying(40)");
            entity.Property(x => x.ProposedAtUtc).HasColumnType("timestamp with time zone");
            entity.Property(x => x.ProposedBySubject).IsRequired().HasMaxLength(256).HasColumnType("character varying(256)");
            entity.HasKey(x => x.Id);
            entity.HasIndex(x => x.ProductId).IsUnique();
            entity.HasOne(x => x.Product).WithMany().HasForeignKey(x => x.ProductId).OnDelete(DeleteBehavior.Restrict);
            entity.ToTable("CatalogueProductFamilyAssignments", t =>
            {
                t.HasCheckConstraint("CK_CatalogueProductFamilyAssignments_FamilyCode", "\"FamilyCode\" IN ('RegularMedicine','Chemotherapy','MedicalDevice','MedicalSupply','Cosmetic')");
                t.HasCheckConstraint("CK_CatalogueProductFamilyAssignments_ReviewStatus", "\"ReviewStatus\" = 'PendingProfessionalReview'");
            });
        });

        modelBuilder.Entity<CatalogueProductIdentifier>(entity =>
        {
            entity.Property(x => x.Id).ValueGeneratedOnAdd().HasColumnType("uuid");
            entity.Property(x => x.ProductId).HasColumnType("uuid");
            entity.Property(x => x.SchemeCode).IsRequired().HasMaxLength(40).HasColumnType("character varying(40)");
            entity.Property(x => x.Value).IsRequired().HasMaxLength(160).HasColumnType("character varying(160)");
            entity.Property(x => x.PackagingLevel).HasMaxLength(64).HasColumnType("character varying(64)");
            entity.Property(x => x.VerificationStatus).IsRequired().HasMaxLength(32).HasColumnType("character varying(32)");
            entity.Property(x => x.SourceUri).HasMaxLength(2000).HasColumnType("character varying(2000)");
            entity.Property(x => x.CreatedAtUtc).HasColumnType("timestamp with time zone");
            entity.Property(x => x.CreatedBySubject).IsRequired().HasMaxLength(256).HasColumnType("character varying(256)");
            entity.HasKey(x => x.Id);
            entity.HasIndex(x => new { x.SchemeCode, x.Value }).IsUnique();
            entity.HasIndex(x => x.ProductId);
            entity.HasOne(x => x.Product).WithMany().HasForeignKey(x => x.ProductId).OnDelete(DeleteBehavior.Restrict);
            entity.ToTable("CatalogueProductIdentifiers", t =>
            {
                t.HasCheckConstraint("CK_CatalogueProductIdentifiers_SchemeCode", "\"SchemeCode\" IN ('GTIN','UDI-DI','EDA-Registration','EDA-Cosmetics-Notification')");
                t.HasCheckConstraint("CK_CatalogueProductIdentifiers_VerificationStatus", "\"VerificationStatus\" = 'PendingVerification'");
            });
        });

        modelBuilder.Entity<CatalogueRegulatoryEvidence>(entity =>
        {
            entity.Property(x => x.Id).ValueGeneratedOnAdd().HasColumnType("uuid");
            entity.Property(x => x.ProductId).HasColumnType("uuid");
            entity.Property(x => x.AuthorityCode).IsRequired().HasMaxLength(48).HasColumnType("character varying(48)");
            entity.Property(x => x.EvidenceType).IsRequired().HasMaxLength(48).HasColumnType("character varying(48)");
            entity.Property(x => x.ReferenceNumber).IsRequired().HasMaxLength(160).HasColumnType("character varying(160)");
            entity.Property(x => x.DocumentUri).HasMaxLength(2000).HasColumnType("character varying(2000)");
            entity.Property(x => x.RegulatoryDocumentId).HasColumnType("uuid");
            entity.Property(x => x.PublishedOn).HasColumnType("date");
            entity.Property(x => x.EffectiveFrom).HasColumnType("date");
            entity.Property(x => x.ExpiresOn).HasColumnType("date");
            entity.Property(x => x.VerificationStatus).IsRequired().HasMaxLength(32).HasColumnType("character varying(32)");
            entity.Property(x => x.CreatedAtUtc).HasColumnType("timestamp with time zone");
            entity.Property(x => x.CreatedBySubject).IsRequired().HasMaxLength(256).HasColumnType("character varying(256)");
            entity.HasKey(x => x.Id);
            entity.HasIndex(x => x.ProductId);
            entity.HasIndex(x => x.RegulatoryDocumentId);
            entity.HasOne(x => x.Product).WithMany().HasForeignKey(x => x.ProductId).OnDelete(DeleteBehavior.Restrict);
            entity.HasOne(x => x.RegulatoryDocument).WithMany().HasForeignKey(x => x.RegulatoryDocumentId).OnDelete(DeleteBehavior.Restrict);
            entity.ToTable("CatalogueRegulatoryEvidence", t =>
                t.HasCheckConstraint("CK_CatalogueRegulatoryEvidence_VerificationStatus", "\"VerificationStatus\" = 'PendingReview'"));
        });

        modelBuilder.Entity<CatalogueLifecycleRequest>(entity =>
        {
            entity.Property(x => x.Id).ValueGeneratedOnAdd().HasColumnType("uuid");
            entity.Property(x => x.ProductId).HasColumnType("uuid");
            entity.Property(x => x.RequestedAction).IsRequired().HasMaxLength(16).HasColumnType("character varying(16)");
            entity.Property(x => x.ReviewStatus).IsRequired().HasMaxLength(40).HasColumnType("character varying(40)");
            entity.Property(x => x.Reason).IsRequired().HasMaxLength(500).HasColumnType("character varying(500)");
            entity.Property(x => x.RequestedAtUtc).HasColumnType("timestamp with time zone");
            entity.Property(x => x.RequestedBySubject).IsRequired().HasMaxLength(256).HasColumnType("character varying(256)");
            entity.HasKey(x => x.Id);
            entity.HasIndex(x => new { x.ProductId, x.RequestedAtUtc });
            entity.HasOne(x => x.Product).WithMany().HasForeignKey(x => x.ProductId).OnDelete(DeleteBehavior.Restrict);
            entity.ToTable("CatalogueLifecycleRequests", t =>
            {
                t.HasCheckConstraint("CK_CatalogueLifecycleRequests_Action", "\"RequestedAction\" IN ('Activate','Retire')");
                t.HasCheckConstraint("CK_CatalogueLifecycleRequests_ReviewStatus", "\"ReviewStatus\" = 'PendingProfessionalReview'");
            });
        });

        modelBuilder.Entity<GovernanceTestCase>(entity =>
        {
            entity.Property(x => x.Id).ValueGeneratedOnAdd().HasColumnType("uuid");
            entity.Property(x => x.GateCode).IsRequired().HasMaxLength(32).HasColumnType("character varying(32)");
            entity.Property(x => x.TestCode).IsRequired().HasMaxLength(48).HasColumnType("character varying(48)");
            entity.Property(x => x.Title).IsRequired().HasMaxLength(200).HasColumnType("character varying(200)");
            entity.Property(x => x.Objective).IsRequired().HasMaxLength(1000).HasColumnType("character varying(1000)");
            entity.Property(x => x.ExpectedResult).IsRequired().HasMaxLength(2000).HasColumnType("character varying(2000)");
            entity.Property(x => x.TestMode).IsRequired().HasMaxLength(16).HasColumnType("character varying(16)");
            entity.Property(x => x.ExecutionBlocked).HasColumnType("boolean");
            entity.Property(x => x.BlockReason).HasMaxLength(1000).HasColumnType("character varying(1000)");
            entity.Property(x => x.CreatedAtUtc).HasColumnType("timestamp with time zone");
            entity.HasKey(x => x.Id);
            entity.HasIndex(x => x.TestCode).IsUnique();
            entity.HasIndex(x => x.GateCode);
            entity.ToTable("GovernanceTestCases", t =>
                t.HasCheckConstraint("CK_GovernanceTestCases_TestMode", "\"TestMode\" IN ('Automated','Manual')"));
        });

        modelBuilder.Entity<GovernanceTestExecution>(entity =>
        {
            entity.Property(x => x.Id).ValueGeneratedOnAdd().HasColumnType("uuid");
            entity.Property(x => x.TestCaseId).HasColumnType("uuid");
            entity.Property(x => x.Status).IsRequired().HasMaxLength(16).HasColumnType("character varying(16)");
            entity.Property(x => x.Environment).IsRequired().HasMaxLength(32).HasColumnType("character varying(32)");
            entity.Property(x => x.EvidenceReference).HasMaxLength(500).HasColumnType("character varying(500)");
            entity.Property(x => x.Notes).HasMaxLength(2000).HasColumnType("character varying(2000)");
            entity.Property(x => x.ExecutedAtUtc).HasColumnType("timestamp with time zone");
            entity.Property(x => x.ExecutedBySubject).IsRequired().HasMaxLength(256).HasColumnType("character varying(256)");
            entity.HasKey(x => x.Id);
            entity.HasIndex(x => new { x.TestCaseId, x.ExecutedAtUtc });
            entity.HasOne(x => x.TestCase).WithMany().HasForeignKey(x => x.TestCaseId).OnDelete(DeleteBehavior.Restrict);
            entity.ToTable("GovernanceTestExecutions", t =>
                t.HasCheckConstraint("CK_GovernanceTestExecutions_Status", "\"Status\" IN ('Passed','Failed','Blocked')"));
        });

        modelBuilder.Entity<GovernanceApproval>(entity =>
        {
            entity.Property(x => x.Id).ValueGeneratedOnAdd().HasColumnType("uuid");
            entity.Property(x => x.ApprovalCode).IsRequired().HasMaxLength(32).HasColumnType("character varying(32)");
            entity.Property(x => x.Title).IsRequired().HasMaxLength(200).HasColumnType("character varying(200)");
            entity.Property(x => x.RequiredApproverRole).IsRequired().HasMaxLength(100).HasColumnType("character varying(100)");
            entity.Property(x => x.Status).IsRequired().HasMaxLength(32).HasColumnType("character varying(32)");
            entity.Property(x => x.ScopeDescription).IsRequired().HasMaxLength(2000).HasColumnType("character varying(2000)");
            entity.Property(x => x.EvidenceReference).IsRequired().HasMaxLength(500).HasColumnType("character varying(500)");
            entity.Property(x => x.CreatedAtUtc).HasColumnType("timestamp with time zone");
            entity.Property(x => x.UpdatedAtUtc).HasColumnType("timestamp with time zone");
            entity.Property(x => x.DecisionAtUtc).HasColumnType("timestamp with time zone");
            entity.Property(x => x.DecisionBySubject).HasMaxLength(256).HasColumnType("character varying(256)");
            entity.Property(x => x.DecisionReference).HasMaxLength(500).HasColumnType("character varying(500)");
            entity.Property(x => x.DecisionNotes).HasMaxLength(2000).HasColumnType("character varying(2000)");
            entity.Property(x => x.Conditions).HasMaxLength(2000).HasColumnType("character varying(2000)");
            entity.HasKey(x => x.Id);
            entity.HasIndex(x => x.ApprovalCode).IsUnique();
            entity.HasIndex(x => new { x.Status, x.RequiredApproverRole });
            entity.ToTable("GovernanceApprovals", t =>
                t.HasCheckConstraint("CK_GovernanceApprovals_Status", "\"Status\" IN ('Pending','Approved','ApprovedWithConditions','Rejected','Withdrawn','Superseded')"));
        });


        modelBuilder.Entity<PharmacyReceiptDraft>(entity =>
        {
            entity.Property(x => x.Id).ValueGeneratedOnAdd().HasColumnType("uuid");
            entity.Property(x => x.LocationId).HasColumnType("uuid");
            entity.Property(x => x.SupplierReference).IsRequired().HasMaxLength(200).HasColumnType("character varying(200)");
            entity.Property(x => x.DeliveryReference).HasMaxLength(160).HasColumnType("character varying(160)");
            entity.Property(x => x.Status).IsRequired().HasMaxLength(16).HasColumnType("character varying(16)");
            entity.Property(x => x.CreatedBySubject).IsRequired().HasMaxLength(256).HasColumnType("character varying(256)");
            entity.Property(x => x.CreatedAtUtc).HasColumnType("timestamp with time zone");
            entity.Property(x => x.UpdatedBySubject).IsRequired().HasMaxLength(256).HasColumnType("character varying(256)");
            entity.Property(x => x.UpdatedAtUtc).HasColumnType("timestamp with time zone");
            entity.Property(x => x.ChangeReason).IsRequired().HasMaxLength(500).HasColumnType("character varying(500)");
            entity.HasKey(x => x.Id);
            entity.HasIndex(x => new { x.LocationId, x.CreatedAtUtc });
            entity.HasOne(x => x.Location).WithMany().HasForeignKey(x => x.LocationId).OnDelete(DeleteBehavior.Restrict);
            entity.ToTable("PharmacyReceiptDrafts", t =>
                t.HasCheckConstraint("CK_PharmacyReceiptDrafts_DraftOnly", "\"Status\" = 'Draft'"));
        });

        modelBuilder.Entity<PharmacyReceiptDraftLine>(entity =>
        {
            entity.Property(x => x.Id).ValueGeneratedOnAdd().HasColumnType("uuid");
            entity.Property(x => x.ReceiptDraftId).HasColumnType("uuid");
            entity.Property(x => x.ProductId).HasColumnType("uuid");
            entity.Property(x => x.UnitId).HasColumnType("uuid");
            entity.Property(x => x.Quantity).HasPrecision(18, 6).HasColumnType("numeric(18,6)");
            entity.Property(x => x.SupplierItemReference).HasMaxLength(160).HasColumnType("character varying(160)");
            entity.HasKey(x => x.Id);
            entity.HasIndex(x => x.ReceiptDraftId);
            entity.HasIndex(x => x.ProductId);
            entity.HasIndex(x => x.UnitId);
            entity.HasOne(x => x.ReceiptDraft).WithMany(x => x.Lines).HasForeignKey(x => x.ReceiptDraftId).OnDelete(DeleteBehavior.Restrict);
            entity.HasOne(x => x.Product).WithMany().HasForeignKey(x => x.ProductId).OnDelete(DeleteBehavior.Restrict);
            entity.HasOne(x => x.Unit).WithMany().HasForeignKey(x => x.UnitId).OnDelete(DeleteBehavior.Restrict);
            entity.ToTable("PharmacyReceiptDraftLines", t =>
                t.HasCheckConstraint("CK_PharmacyReceiptDraftLines_PositiveQuantity", "\"Quantity\" > 0"));
        });


        modelBuilder.Entity<PharmacySupplier>(entity =>
        {
            entity.Property(x => x.Id).ValueGeneratedOnAdd().HasColumnType("uuid");
            entity.Property(x => x.Code).IsRequired().HasMaxLength(32).HasColumnType("character varying(32)");
            entity.Property(x => x.DisplayName).IsRequired().HasMaxLength(200).HasColumnType("character varying(200)");
            entity.Property(x => x.Status).IsRequired().HasMaxLength(16).HasColumnType("character varying(16)");
            entity.Property(x => x.Version).IsConcurrencyToken().HasColumnType("integer");
            entity.Property(x => x.CreatedBySubject).IsRequired().HasMaxLength(256).HasColumnType("character varying(256)");
            entity.Property(x => x.CreatedAtUtc).HasColumnType("timestamp with time zone");
            entity.Property(x => x.UpdatedBySubject).IsRequired().HasMaxLength(256).HasColumnType("character varying(256)");
            entity.Property(x => x.UpdatedAtUtc).HasColumnType("timestamp with time zone");
            entity.Property(x => x.ChangeReason).IsRequired().HasMaxLength(500).HasColumnType("character varying(500)");
            entity.HasKey(x => x.Id);
            entity.HasIndex(x => x.Code).IsUnique();
            entity.ToTable("PharmacySuppliers", t => t.HasCheckConstraint("CK_PharmacySuppliers_DraftOnly", "\"Status\" = 'Draft'"));
        });

        modelBuilder.Entity<PharmacySupplierDeclaration>(entity =>
        {
            entity.Property(x => x.Id).ValueGeneratedOnAdd().HasColumnType("uuid");
            entity.Property(x => x.SupplierId).HasColumnType("uuid");
            entity.Property(x => x.ClaimType).IsRequired().HasMaxLength(48).HasColumnType("character varying(48)");
            entity.Property(x => x.DeclaredValue).IsRequired().HasMaxLength(500).HasColumnType("character varying(500)");
            entity.Property(x => x.Provenance).IsRequired().HasMaxLength(24).HasColumnType("character varying(24)");
            entity.Property(x => x.ReviewStatus).IsRequired().HasMaxLength(16).HasColumnType("character varying(16)");
            entity.Property(x => x.AddedBySubject).IsRequired().HasMaxLength(256).HasColumnType("character varying(256)");
            entity.Property(x => x.AddedAtUtc).HasColumnType("timestamp with time zone");
            entity.Property(x => x.ChangeReason).IsRequired().HasMaxLength(500).HasColumnType("character varying(500)");
            entity.HasKey(x => x.Id);
            entity.HasIndex(x => new { x.SupplierId, x.ClaimType });
            entity.HasOne(x => x.Supplier).WithMany(x => x.Declarations).HasForeignKey(x => x.SupplierId).OnDelete(DeleteBehavior.Restrict);
            entity.ToTable("PharmacySupplierDeclarations", t =>
            {
                t.HasCheckConstraint("CK_PharmacySupplierDeclarations_OwnerProvidedUnverified", "\"Provenance\" = 'OwnerProvided' AND \"ReviewStatus\" = 'Unverified'");
                t.HasCheckConstraint("CK_PharmacySupplierDeclarations_ClaimType", "\"ClaimType\" IN ('LegalName','TradingName','LegalForm','Jurisdiction','RegistrationAuthority','RegistrationNumber','TaxReference','RegisteredAddress','LicenceCategory','LicenceHolder','LicenceNumber','LicenceIssuingAuthority','LicenceScope','LicenceIssueDate','LicenceExpiryDate')");
            });
        });

        modelBuilder.Entity<PharmacySupplierBusinessContact>(entity =>
        {
            entity.Property(x => x.Id).ValueGeneratedOnAdd().HasColumnType("uuid");
            entity.Property(x => x.SupplierId).HasColumnType("uuid");
            entity.Property(x => x.ChannelType).IsRequired().HasMaxLength(32).HasColumnType("character varying(32)");
            entity.Property(x => x.ChannelValue).IsRequired().HasMaxLength(320).HasColumnType("character varying(320)");
            entity.Property(x => x.DepartmentLabel).IsRequired().HasMaxLength(80).HasColumnType("character varying(80)");
            entity.Property(x => x.BusinessUseConfirmed).IsRequired().HasColumnType("boolean");
            entity.Property(x => x.AddedBySubject).IsRequired().HasMaxLength(256).HasColumnType("character varying(256)");
            entity.Property(x => x.AddedAtUtc).HasColumnType("timestamp with time zone");
            entity.Property(x => x.ChangeReason).IsRequired().HasMaxLength(500).HasColumnType("character varying(500)");
            entity.HasKey(x => x.Id);
            entity.HasIndex(x => x.SupplierId);
            entity.HasOne(x => x.Supplier).WithMany(x => x.BusinessContacts).HasForeignKey(x => x.SupplierId).OnDelete(DeleteBehavior.Restrict);
            entity.ToTable("PharmacySupplierBusinessContacts", t => t.HasCheckConstraint("CK_PharmacySupplierBusinessContacts_ChannelType", "\"ChannelType\" IN ('DepartmentEmail','BusinessPhone','BusinessWebsite')"));
        });

        modelBuilder.Entity<PharmacySupplierDueDiligenceCase>(entity =>
        {
            entity.Property(x => x.Id).ValueGeneratedOnAdd().HasColumnType("uuid");
            entity.Property(x => x.SupplierId).HasColumnType("uuid");
            entity.Property(x => x.Status).IsRequired().HasMaxLength(16).HasColumnType("character varying(16)");
            entity.Property(x => x.RequestedBySubject).IsRequired().HasMaxLength(256).HasColumnType("character varying(256)");
            entity.Property(x => x.RequestedAtUtc).HasColumnType("timestamp with time zone");
            entity.Property(x => x.RequestReason).IsRequired().HasMaxLength(500).HasColumnType("character varying(500)");
            entity.Property(x => x.CorrelationId).IsRequired().HasMaxLength(128).HasColumnType("character varying(128)");
            entity.HasKey(x => x.Id);
            entity.HasIndex(x => x.SupplierId).IsUnique().HasFilter("\"Status\" = 'Pending'");
            entity.HasOne(x => x.Supplier).WithMany(x => x.DueDiligenceCases).HasForeignKey(x => x.SupplierId).OnDelete(DeleteBehavior.Restrict);
            entity.ToTable("PharmacySupplierDueDiligenceCases", t => t.HasCheckConstraint("CK_PharmacySupplierDueDiligenceCases_PendingOnly", "\"Status\" = 'Pending'"));
        });

        modelBuilder.Entity<PharmacySupplierEvidence>(entity =>
        {
            entity.Property(x => x.Id).ValueGeneratedOnAdd().HasColumnType("uuid");
            entity.Property(x => x.SupplierId).HasColumnType("uuid");
            entity.Property(x => x.EvidenceKind).IsRequired().HasMaxLength(80).HasColumnType("character varying(80)");
            entity.Property(x => x.Title).IsRequired().HasMaxLength(200).HasColumnType("character varying(200)");
            entity.Property(x => x.Issuer).HasMaxLength(200).HasColumnType("character varying(200)");
            entity.Property(x => x.ReferenceNumber).HasMaxLength(120).HasColumnType("character varying(120)");
            entity.Property(x => x.SourceReference).HasMaxLength(1000).HasColumnType("character varying(1000)");
            entity.Property(x => x.IssuedOn).HasColumnType("date");
            entity.Property(x => x.ExpiresOn).HasColumnType("date");
            entity.Property(x => x.VerificationStatus).IsRequired().HasMaxLength(16).HasColumnType("character varying(16)");
            entity.Property(x => x.AddedBySubject).IsRequired().HasMaxLength(256).HasColumnType("character varying(256)");
            entity.Property(x => x.AddedAtUtc).HasColumnType("timestamp with time zone");
            entity.Property(x => x.ChangeReason).IsRequired().HasMaxLength(500).HasColumnType("character varying(500)");
            entity.HasKey(x => x.Id);
            entity.HasIndex(x => x.SupplierId);
            entity.HasOne(x => x.Supplier).WithMany(x => x.Evidence).HasForeignKey(x => x.SupplierId).OnDelete(DeleteBehavior.Restrict);
            entity.ToTable("PharmacySupplierEvidence", t => t.HasCheckConstraint("CK_PharmacySupplierEvidence_Unverified", "\"VerificationStatus\" = 'Unverified'"));
        });

        modelBuilder.Entity<PharmacySupplierReviewRequest>(entity =>
        {
            entity.Property(x => x.Id).ValueGeneratedOnAdd().HasColumnType("uuid");
            entity.Property(x => x.SupplierId).HasColumnType("uuid");
            entity.Property(x => x.Status).IsRequired().HasMaxLength(16).HasColumnType("character varying(16)");
            entity.Property(x => x.RequestedBySubject).IsRequired().HasMaxLength(256).HasColumnType("character varying(256)");
            entity.Property(x => x.RequestedAtUtc).HasColumnType("timestamp with time zone");
            entity.Property(x => x.Reason).IsRequired().HasMaxLength(500).HasColumnType("character varying(500)");
            entity.Property(x => x.CorrelationId).IsRequired().HasMaxLength(128).HasColumnType("character varying(128)");
            entity.HasKey(x => x.Id);
            entity.HasIndex(x => x.SupplierId).IsUnique().HasFilter("\"Status\" = 'Pending'");
            entity.HasOne(x => x.Supplier).WithMany(x => x.ReviewRequests).HasForeignKey(x => x.SupplierId).OnDelete(DeleteBehavior.Restrict);
            entity.ToTable("PharmacySupplierReviewRequests", t => t.HasCheckConstraint("CK_PharmacySupplierReviewRequests_PendingOnly", "\"Status\" = 'Pending'"));
        });

    }
}
