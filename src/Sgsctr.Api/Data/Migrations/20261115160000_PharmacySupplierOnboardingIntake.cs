using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;
using Sgsctr.Api.Data;

namespace Sgsctr.Api.Data.Migrations;

[DbContext(typeof(AppDbContext))]
[Migration("20261115160000_PharmacySupplierOnboardingIntake")]
public sealed class PharmacySupplierOnboardingIntake : Migration
{
    protected override void Up(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.CreateTable(
            name: "PharmacySupplierDeclarations",
            columns: table => new
            {
                Id = table.Column<Guid>(type: "uuid", nullable: false),
                SupplierId = table.Column<Guid>(type: "uuid", nullable: false),
                ClaimType = table.Column<string>(type: "character varying(48)", maxLength: 48, nullable: false),
                DeclaredValue = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: false),
                Provenance = table.Column<string>(type: "character varying(24)", maxLength: 24, nullable: false),
                ReviewStatus = table.Column<string>(type: "character varying(16)", maxLength: 16, nullable: false),
                AddedBySubject = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: false),
                AddedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                ChangeReason = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_PharmacySupplierDeclarations", x => x.Id);
                table.CheckConstraint("CK_PharmacySupplierDeclarations_OwnerProvidedUnverified",
                    "\"Provenance\" = 'OwnerProvided' AND \"ReviewStatus\" = 'Unverified'");
                table.CheckConstraint("CK_PharmacySupplierDeclarations_ClaimType",
                    "\"ClaimType\" IN ('LegalName','TradingName','LegalForm','Jurisdiction','RegistrationAuthority','RegistrationNumber','TaxReference','RegisteredAddress','LicenceCategory','LicenceHolder','LicenceNumber','LicenceIssuingAuthority','LicenceScope','LicenceIssueDate','LicenceExpiryDate')");
                table.ForeignKey("FK_PharmacySupplierDeclarations_PharmacySuppliers_SupplierId",
                    x => x.SupplierId, "PharmacySuppliers", "Id", onDelete: ReferentialAction.Restrict);
            });

        migrationBuilder.CreateTable(
            name: "PharmacySupplierBusinessContacts",
            columns: table => new
            {
                Id = table.Column<Guid>(type: "uuid", nullable: false),
                SupplierId = table.Column<Guid>(type: "uuid", nullable: false),
                ChannelType = table.Column<string>(type: "character varying(32)", maxLength: 32, nullable: false),
                ChannelValue = table.Column<string>(type: "character varying(320)", maxLength: 320, nullable: false),
                DepartmentLabel = table.Column<string>(type: "character varying(80)", maxLength: 80, nullable: false),
                BusinessUseConfirmed = table.Column<bool>(type: "boolean", nullable: false),
                AddedBySubject = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: false),
                AddedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                ChangeReason = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_PharmacySupplierBusinessContacts", x => x.Id);
                table.CheckConstraint("CK_PharmacySupplierBusinessContacts_ChannelType",
                    "\"ChannelType\" IN ('DepartmentEmail','BusinessPhone','BusinessWebsite')");
                table.ForeignKey("FK_PharmacySupplierBusinessContacts_PharmacySuppliers_SupplierId",
                    x => x.SupplierId, "PharmacySuppliers", "Id", onDelete: ReferentialAction.Restrict);
            });

        migrationBuilder.CreateTable(
            name: "PharmacySupplierDueDiligenceCases",
            columns: table => new
            {
                Id = table.Column<Guid>(type: "uuid", nullable: false),
                SupplierId = table.Column<Guid>(type: "uuid", nullable: false),
                Status = table.Column<string>(type: "character varying(16)", maxLength: 16, nullable: false),
                RequestedBySubject = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: false),
                RequestedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                RequestReason = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: false),
                CorrelationId = table.Column<string>(type: "character varying(128)", maxLength: 128, nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_PharmacySupplierDueDiligenceCases", x => x.Id);
                table.CheckConstraint("CK_PharmacySupplierDueDiligenceCases_PendingOnly", "\"Status\" = 'Pending'");
                table.ForeignKey("FK_PharmacySupplierDueDiligenceCases_PharmacySuppliers_SupplierId",
                    x => x.SupplierId, "PharmacySuppliers", "Id", onDelete: ReferentialAction.Restrict);
            });

        migrationBuilder.CreateIndex("IX_PharmacySupplierDeclarations_SupplierId_ClaimType",
            "PharmacySupplierDeclarations", new[] { "SupplierId", "ClaimType" });
        migrationBuilder.CreateIndex("IX_PharmacySupplierBusinessContacts_SupplierId",
            "PharmacySupplierBusinessContacts", "SupplierId");
        migrationBuilder.CreateIndex("IX_PharmacySupplierDueDiligenceCases_SupplierId",
            "PharmacySupplierDueDiligenceCases", "SupplierId", unique: true, filter: "\"Status\" = 'Pending'");
    }

    protected override void Down(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.DropTable("PharmacySupplierDeclarations");
        migrationBuilder.DropTable("PharmacySupplierBusinessContacts");
        migrationBuilder.DropTable("PharmacySupplierDueDiligenceCases");
    }
}
