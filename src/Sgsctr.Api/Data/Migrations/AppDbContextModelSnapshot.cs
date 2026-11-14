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
            entity.Property(x => x.Description).HasMaxLength(1000).HasColumnType("character varying(1000)");
            entity.Property(x => x.Status).IsRequired().HasMaxLength(16).HasColumnType("character varying(16)");
            entity.Property(x => x.Version).IsConcurrencyToken().HasColumnType("integer");
            entity.Property(x => x.CreatedAtUtc).HasColumnType("timestamp with time zone");
            entity.Property(x => x.UpdatedAtUtc).HasColumnType("timestamp with time zone");
            entity.Property(x => x.CreatedBySubject).IsRequired().HasMaxLength(256).HasColumnType("character varying(256)");
            entity.Property(x => x.UpdatedBySubject).IsRequired().HasMaxLength(256).HasColumnType("character varying(256)");
            entity.HasKey(x => x.Id);
            entity.HasIndex(x => x.DisplayName);
            entity.ToTable("CatalogueProducts");
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
            entity.ToTable("ProductUnitConversions", t => t.HasCheckConstraint("CK_ProductUnitConversions_PositiveRatio", "\"Numerator\" > 0 AND \"Denominator\" > 0"));
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

    }
}
