using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;
using Sgsctr.Api.Data;

namespace Sgsctr.Api.Data.Migrations;

[DbContext(typeof(AuthDbContext))]
public sealed partial class NativeIdentity
{
    protected override void BuildTargetModel(ModelBuilder modelBuilder)
    {
        modelBuilder.HasAnnotation("ProductVersion", "10.0.3").HasAnnotation("Relational:MaxIdentifierLength", 63);
        modelBuilder.HasDefaultSchema("identity");
        modelBuilder.Entity<IdentityUser>(b => { b.Property<string>("Id").HasColumnType("text"); b.Property<string>("UserName").HasMaxLength(256).HasColumnType("character varying(256)"); b.Property<string>("NormalizedUserName").HasMaxLength(256).HasColumnType("character varying(256)"); b.Property<string>("Email").HasMaxLength(256).HasColumnType("character varying(256)"); b.Property<string>("NormalizedEmail").HasMaxLength(256).HasColumnType("character varying(256)"); b.Property<bool>("EmailConfirmed").HasColumnType("boolean"); b.Property<string>("PasswordHash").HasColumnType("text"); b.Property<string>("SecurityStamp").HasColumnType("text"); b.Property<string>("ConcurrencyStamp").IsConcurrencyToken().HasColumnType("text"); b.Property<string>("PhoneNumber").HasColumnType("text"); b.Property<bool>("PhoneNumberConfirmed").HasColumnType("boolean"); b.Property<bool>("TwoFactorEnabled").HasColumnType("boolean"); b.Property<DateTimeOffset?>("LockoutEnd").HasColumnType("timestamp with time zone"); b.Property<bool>("LockoutEnabled").HasColumnType("boolean"); b.Property<int>("AccessFailedCount").HasColumnType("integer"); b.HasKey("Id"); b.HasIndex("NormalizedEmail").HasDatabaseName("EmailIndex"); b.HasIndex("NormalizedUserName").IsUnique().HasDatabaseName("UserNameIndex"); b.ToTable("AspNetUsers", "identity"); });
        modelBuilder.Entity<IdentityRole>(b => { b.Property<string>("Id").HasColumnType("text"); b.Property<string>("Name").HasMaxLength(256).HasColumnType("character varying(256)"); b.Property<string>("NormalizedName").HasMaxLength(256).HasColumnType("character varying(256)"); b.Property<string>("ConcurrencyStamp").IsConcurrencyToken().HasColumnType("text"); b.HasKey("Id"); b.HasIndex("NormalizedName").IsUnique().HasDatabaseName("RoleNameIndex"); b.ToTable("AspNetRoles", "identity"); });
        modelBuilder.Entity<IdentityUserClaim<string>>(b => { b.Property<int>("Id").ValueGeneratedOnAdd().HasColumnType("integer"); b.Property<string>("UserId").IsRequired().HasColumnType("text"); b.Property<string>("ClaimType").HasColumnType("text"); b.Property<string>("ClaimValue").HasColumnType("text"); b.HasKey("Id"); b.HasIndex("UserId"); b.ToTable("AspNetUserClaims", "identity"); });
        modelBuilder.Entity<IdentityUserLogin<string>>(b => { b.Property<string>("LoginProvider").HasMaxLength(128).HasColumnType("character varying(128)"); b.Property<string>("ProviderKey").HasMaxLength(128).HasColumnType("character varying(128)"); b.Property<string>("ProviderDisplayName").HasColumnType("text"); b.Property<string>("UserId").IsRequired().HasColumnType("text"); b.HasKey("LoginProvider", "ProviderKey"); b.HasIndex("UserId"); b.ToTable("AspNetUserLogins", "identity"); });
        modelBuilder.Entity<IdentityUserRole<string>>(b => { b.Property<string>("UserId").HasColumnType("text"); b.Property<string>("RoleId").HasColumnType("text"); b.HasKey("UserId", "RoleId"); b.HasIndex("RoleId"); b.ToTable("AspNetUserRoles", "identity"); });
        modelBuilder.Entity<IdentityUserToken<string>>(b => { b.Property<string>("UserId").HasColumnType("text"); b.Property<string>("LoginProvider").HasMaxLength(128).HasColumnType("character varying(128)"); b.Property<string>("Name").HasMaxLength(128).HasColumnType("character varying(128)"); b.Property<string>("Value").HasColumnType("text"); b.HasKey("UserId", "LoginProvider", "Name"); b.ToTable("AspNetUserTokens", "identity"); });
        modelBuilder.Entity<IdentityRoleClaim<string>>(b => { b.Property<int>("Id").ValueGeneratedOnAdd().HasColumnType("integer"); b.Property<string>("RoleId").IsRequired().HasColumnType("text"); b.Property<string>("ClaimType").HasColumnType("text"); b.Property<string>("ClaimValue").HasColumnType("text"); b.HasKey("Id"); b.HasIndex("RoleId"); b.ToTable("AspNetRoleClaims", "identity"); });
        modelBuilder.Entity<IdentityUserClaim<string>>().HasOne<IdentityUser>().WithMany().HasForeignKey("UserId").OnDelete(DeleteBehavior.Cascade).IsRequired();
        modelBuilder.Entity<IdentityUserLogin<string>>().HasOne<IdentityUser>().WithMany().HasForeignKey("UserId").OnDelete(DeleteBehavior.Cascade).IsRequired();
        modelBuilder.Entity<IdentityUserRole<string>>().HasOne<IdentityRole>().WithMany().HasForeignKey("RoleId").OnDelete(DeleteBehavior.Cascade).IsRequired();
        modelBuilder.Entity<IdentityUserRole<string>>().HasOne<IdentityUser>().WithMany().HasForeignKey("UserId").OnDelete(DeleteBehavior.Cascade).IsRequired();
        modelBuilder.Entity<IdentityUserToken<string>>().HasOne<IdentityUser>().WithMany().HasForeignKey("UserId").OnDelete(DeleteBehavior.Cascade).IsRequired();
        modelBuilder.Entity<IdentityRoleClaim<string>>().HasOne<IdentityRole>().WithMany().HasForeignKey("RoleId").OnDelete(DeleteBehavior.Cascade).IsRequired();
    }
}