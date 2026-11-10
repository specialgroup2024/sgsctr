using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Metadata;
using Sgsctr.Api.Data;

namespace Sgsctr.Api.Data.Migrations;

[DbContext(typeof(AppDbContext))]
public sealed class AppDbContextModelSnapshot : ModelSnapshot
{
    protected override void BuildModel(ModelBuilder modelBuilder)
    {
        modelBuilder
            .HasAnnotation("ProductVersion", "10.0.3")
            .HasAnnotation("Relational:MaxIdentifierLength", 63);

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
    }
}
