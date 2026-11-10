using Microsoft.EntityFrameworkCore;

namespace Sgsctr.Api.Data;

/// <summary>Persistence for approved foundation reference data; no pharmacy or accounting transactions.</summary>
public sealed class AppDbContext(DbContextOptions<AppDbContext> options) : DbContext(options)
{
    public DbSet<OrganizationLocation> OrganizationLocations => Set<OrganizationLocation>();

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
    }
}
