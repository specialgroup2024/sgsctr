using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;
using Sgsctr.Api.Data;

namespace Sgsctr.Api.Data.Migrations;

[DbContext(typeof(AppDbContext))]
[Migration("20261115150000_PharmacySupplierDrafts")]
public sealed class PharmacySupplierDrafts : Migration
{
    protected override void Up(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.CreateTable(
            name: "PharmacySuppliers",
            columns: table => new
            {
                Id = table.Column<Guid>(type: "uuid", nullable: false),
                Code = table.Column<string>(type: "character varying(32)", maxLength: 32, nullable: false),
                DisplayName = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: false),
                Status = table.Column<string>(type: "character varying(16)", maxLength: 16, nullable: false),
                Version = table.Column<int>(type: "integer", nullable: false),
                CreatedBySubject = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: false),
                CreatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                UpdatedBySubject = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: false),
                UpdatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                ChangeReason = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_PharmacySuppliers", x => x.Id);
                table.CheckConstraint("CK_PharmacySuppliers_DraftOnly", "\"Status\" = 'Draft'");
            });

        migrationBuilder.CreateTable(
            name: "PharmacySupplierEvidence",
            columns: table => new
            {
                Id = table.Column<Guid>(type: "uuid", nullable: false),
                SupplierId = table.Column<Guid>(type: "uuid", nullable: false),
                EvidenceKind = table.Column<string>(type: "character varying(80)", maxLength: 80, nullable: false),
                Title = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: false),
                Issuer = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: true),
                ReferenceNumber = table.Column<string>(type: "character varying(120)", maxLength: 120, nullable: true),
                SourceReference = table.Column<string>(type: "character varying(1000)", maxLength: 1000, nullable: true),
                IssuedOn = table.Column<DateOnly>(type: "date", nullable: true),
                ExpiresOn = table.Column<DateOnly>(type: "date", nullable: true),
                VerificationStatus = table.Column<string>(type: "character varying(16)", maxLength: 16, nullable: false),
                AddedBySubject = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: false),
                AddedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                ChangeReason = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_PharmacySupplierEvidence", x => x.Id);
                table.CheckConstraint("CK_PharmacySupplierEvidence_Unverified", "\"VerificationStatus\" = 'Unverified'");
                table.ForeignKey("FK_PharmacySupplierEvidence_PharmacySuppliers_SupplierId",
                    x => x.SupplierId, "PharmacySuppliers", "Id", onDelete: ReferentialAction.Restrict);
            });

        migrationBuilder.CreateTable(
            name: "PharmacySupplierReviewRequests",
            columns: table => new
            {
                Id = table.Column<Guid>(type: "uuid", nullable: false),
                SupplierId = table.Column<Guid>(type: "uuid", nullable: false),
                Status = table.Column<string>(type: "character varying(16)", maxLength: 16, nullable: false),
                RequestedBySubject = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: false),
                RequestedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                Reason = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: false),
                CorrelationId = table.Column<string>(type: "character varying(128)", maxLength: 128, nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_PharmacySupplierReviewRequests", x => x.Id);
                table.CheckConstraint("CK_PharmacySupplierReviewRequests_PendingOnly", "\"Status\" = 'Pending'");
                table.ForeignKey("FK_PharmacySupplierReviewRequests_PharmacySuppliers_SupplierId",
                    x => x.SupplierId, "PharmacySuppliers", "Id", onDelete: ReferentialAction.Restrict);
            });

        migrationBuilder.CreateIndex("IX_PharmacySuppliers_Code", "PharmacySuppliers", "Code", unique: true);
        migrationBuilder.CreateIndex("IX_PharmacySupplierEvidence_SupplierId", "PharmacySupplierEvidence", "SupplierId");
        migrationBuilder.CreateIndex("IX_PharmacySupplierReviewRequests_SupplierId",
            "PharmacySupplierReviewRequests", "SupplierId", unique: true, filter: "\"Status\" = 'Pending'");
    }

    protected override void Down(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.DropTable("PharmacySupplierEvidence");
        migrationBuilder.DropTable("PharmacySupplierReviewRequests");
        migrationBuilder.DropTable("PharmacySuppliers");
    }
}
