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
    }
}
