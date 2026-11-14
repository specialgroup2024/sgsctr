using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;
using Sgsctr.Api.Data;

namespace Sgsctr.Api.Data.Migrations;

[DbContext(typeof(AppDbContext))]
[Migration("20261114150000_PharmacyProductGovernanceDrafts")]
public sealed class PharmacyProductGovernanceDrafts : Migration
{
    protected override void Up(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.CreateTable(
            name: "CatalogueProductFamilyAssignments",
            columns: table => new
            {
                Id = table.Column<Guid>(type: "uuid", nullable: false),
                ProductId = table.Column<Guid>(type: "uuid", nullable: false),
                FamilyCode = table.Column<string>(type: "character varying(32)", maxLength: 32, nullable: false),
                ReviewStatus = table.Column<string>(type: "character varying(40)", maxLength: 40, nullable: false),
                ProposedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                ProposedBySubject = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_CatalogueProductFamilyAssignments", x => x.Id);
                table.CheckConstraint("CK_CatalogueProductFamilyAssignments_FamilyCode",
                    "\"FamilyCode\" IN ('RegularMedicine','Chemotherapy','MedicalSupplyDevice','Cosmetic')");
                table.CheckConstraint("CK_CatalogueProductFamilyAssignments_ReviewStatus",
                    "\"ReviewStatus\" = 'PendingProfessionalReview'");
                table.ForeignKey("FK_CatalogueProductFamilyAssignments_CatalogueProducts_ProductId",
                    x => x.ProductId, "CatalogueProducts", "Id", onDelete: ReferentialAction.Restrict);
            });

        migrationBuilder.CreateTable(
            name: "CatalogueProductIdentifiers",
            columns: table => new
            {
                Id = table.Column<Guid>(type: "uuid", nullable: false),
                ProductId = table.Column<Guid>(type: "uuid", nullable: false),
                SchemeCode = table.Column<string>(type: "character varying(40)", maxLength: 40, nullable: false),
                Value = table.Column<string>(type: "character varying(160)", maxLength: 160, nullable: false),
                PackagingLevel = table.Column<string>(type: "character varying(64)", maxLength: 64, nullable: true),
                VerificationStatus = table.Column<string>(type: "character varying(32)", maxLength: 32, nullable: false),
                SourceUri = table.Column<string>(type: "character varying(2000)", maxLength: 2000, nullable: true),
                CreatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                CreatedBySubject = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_CatalogueProductIdentifiers", x => x.Id);
                table.CheckConstraint("CK_CatalogueProductIdentifiers_SchemeCode",
                    "\"SchemeCode\" IN ('GTIN','UDI-DI','EDA-Registration','EDA-Cosmetics-Notification')");
                table.CheckConstraint("CK_CatalogueProductIdentifiers_VerificationStatus",
                    "\"VerificationStatus\" = 'PendingVerification'");
                table.ForeignKey("FK_CatalogueProductIdentifiers_CatalogueProducts_ProductId",
                    x => x.ProductId, "CatalogueProducts", "Id", onDelete: ReferentialAction.Restrict);
            });

        migrationBuilder.CreateTable(
            name: "CatalogueRegulatoryEvidence",
            columns: table => new
            {
                Id = table.Column<Guid>(type: "uuid", nullable: false),
                ProductId = table.Column<Guid>(type: "uuid", nullable: false),
                AuthorityCode = table.Column<string>(type: "character varying(48)", maxLength: 48, nullable: false),
                EvidenceType = table.Column<string>(type: "character varying(48)", maxLength: 48, nullable: false),
                ReferenceNumber = table.Column<string>(type: "character varying(160)", maxLength: 160, nullable: false),
                DocumentUri = table.Column<string>(type: "character varying(2000)", maxLength: 2000, nullable: true),
                RegulatoryDocumentId = table.Column<Guid>(type: "uuid", nullable: true),
                PublishedOn = table.Column<DateOnly>(type: "date", nullable: true),
                EffectiveFrom = table.Column<DateOnly>(type: "date", nullable: true),
                ExpiresOn = table.Column<DateOnly>(type: "date", nullable: true),
                VerificationStatus = table.Column<string>(type: "character varying(32)", maxLength: 32, nullable: false),
                CreatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                CreatedBySubject = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_CatalogueRegulatoryEvidence", x => x.Id);
                table.CheckConstraint("CK_CatalogueRegulatoryEvidence_VerificationStatus",
                    "\"VerificationStatus\" = 'PendingReview'");
                table.ForeignKey("FK_CatalogueRegulatoryEvidence_CatalogueProducts_ProductId",
                    x => x.ProductId, "CatalogueProducts", "Id", onDelete: ReferentialAction.Restrict);
                table.ForeignKey("FK_CatalogueRegulatoryEvidence_RegulatoryDocuments_RegulatoryDocumentId",
                    x => x.RegulatoryDocumentId, "RegulatoryDocuments", "Id", onDelete: ReferentialAction.Restrict);
            });

        migrationBuilder.CreateTable(
            name: "CatalogueLifecycleRequests",
            columns: table => new
            {
                Id = table.Column<Guid>(type: "uuid", nullable: false),
                ProductId = table.Column<Guid>(type: "uuid", nullable: false),
                RequestedAction = table.Column<string>(type: "character varying(16)", maxLength: 16, nullable: false),
                ReviewStatus = table.Column<string>(type: "character varying(40)", maxLength: 40, nullable: false),
                Reason = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: false),
                RequestedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                RequestedBySubject = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_CatalogueLifecycleRequests", x => x.Id);
                table.CheckConstraint("CK_CatalogueLifecycleRequests_Action",
                    "\"RequestedAction\" IN ('Activate','Retire')");
                table.CheckConstraint("CK_CatalogueLifecycleRequests_ReviewStatus",
                    "\"ReviewStatus\" = 'PendingProfessionalReview'");
                table.ForeignKey("FK_CatalogueLifecycleRequests_CatalogueProducts_ProductId",
                    x => x.ProductId, "CatalogueProducts", "Id", onDelete: ReferentialAction.Restrict);
            });

        migrationBuilder.CreateIndex("IX_CatalogueProductFamilyAssignments_ProductId",
            "CatalogueProductFamilyAssignments", "ProductId", unique: true);
        migrationBuilder.CreateIndex("IX_CatalogueProductIdentifiers_ProductId",
            "CatalogueProductIdentifiers", "ProductId");
        migrationBuilder.CreateIndex("IX_CatalogueProductIdentifiers_SchemeCode_Value",
            "CatalogueProductIdentifiers", new[] { "SchemeCode", "Value" }, unique: true);
        migrationBuilder.CreateIndex("IX_CatalogueRegulatoryEvidence_ProductId",
            "CatalogueRegulatoryEvidence", "ProductId");
        migrationBuilder.CreateIndex("IX_CatalogueRegulatoryEvidence_RegulatoryDocumentId",
            "CatalogueRegulatoryEvidence", "RegulatoryDocumentId");
        migrationBuilder.CreateIndex("IX_CatalogueLifecycleRequests_ProductId_RequestedAtUtc",
            "CatalogueLifecycleRequests", new[] { "ProductId", "RequestedAtUtc" });
    }

    protected override void Down(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.DropTable("CatalogueLifecycleRequests");
        migrationBuilder.DropTable("CatalogueRegulatoryEvidence");
        migrationBuilder.DropTable("CatalogueProductIdentifiers");
        migrationBuilder.DropTable("CatalogueProductFamilyAssignments");
    }
}
