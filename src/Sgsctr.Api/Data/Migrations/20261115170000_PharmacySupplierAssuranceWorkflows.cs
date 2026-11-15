using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;
using Sgsctr.Api.Data;

namespace Sgsctr.Api.Data.Migrations;

[DbContext(typeof(AppDbContext))]
[Migration("20261115170000_PharmacySupplierAssuranceWorkflows")]
public sealed class PharmacySupplierAssuranceWorkflows : Migration
{
    protected override void Up(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.AddUniqueConstraint("AK_PharmacySupplierEvidence_Id_SupplierId",
            "PharmacySupplierEvidence", new[] { "Id", "SupplierId" });

        migrationBuilder.CreateTable(
            name: "PharmacySupplierAssuranceCases",
            columns: table => new
            {
                Id = table.Column<Guid>(type: "uuid", nullable: false),
                SupplierId = table.Column<Guid>(type: "uuid", nullable: false),
                CaseType = table.Column<string>(type: "character varying(40)", maxLength: 40, nullable: false),
                Status = table.Column<string>(type: "character varying(16)", maxLength: 16, nullable: false),
                RequestedBySubject = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: false),
                RequestedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                Reason = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: false),
                ScopeReference = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: true),
                EvidenceId = table.Column<Guid>(type: "uuid", nullable: true),
                BlockerCode = table.Column<string>(type: "character varying(80)", maxLength: 80, nullable: true),
                CorrelationId = table.Column<string>(type: "character varying(128)", maxLength: 128, nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_PharmacySupplierAssuranceCases", x => x.Id);
                table.CheckConstraint("CK_PharmacySupplierAssuranceCases_CaseType",
                    "\"CaseType\" IN ('LegalLicenceVerification','DueDiligenceExecution','ReviewerAuthorityApplication','QualificationReview','PurchasingEligibilityEvaluation','ReceivingEligibilityEvaluation')");
                table.CheckConstraint("CK_PharmacySupplierAssuranceCases_GatedState",
                    "((\"CaseType\" IN ('PurchasingEligibilityEvaluation','ReceivingEligibilityEvaluation') AND \"Status\" = 'Blocked' AND \"BlockerCode\" IS NOT NULL) OR (\"CaseType\" NOT IN ('PurchasingEligibilityEvaluation','ReceivingEligibilityEvaluation') AND \"Status\" = 'Pending' AND \"BlockerCode\" IS NULL))");
                table.ForeignKey("FK_PharmacySupplierAssuranceCases_PharmacySuppliers_SupplierId",
                    x => x.SupplierId, "PharmacySuppliers", "Id", onDelete: ReferentialAction.Restrict);
                table.ForeignKey("FK_PharmacySupplierAssuranceCases_PharmacySupplierEvidence_EvidenceId_SupplierId",
                    x => new { x.EvidenceId, x.SupplierId }, "PharmacySupplierEvidence", new[] { "Id", "SupplierId" }, onDelete: ReferentialAction.Restrict);
            });
        migrationBuilder.CreateIndex("IX_PharmacySupplierAssuranceCases_SupplierId_RequestedAtUtc",
            "PharmacySupplierAssuranceCases", new[] { "SupplierId", "RequestedAtUtc" });
        migrationBuilder.CreateIndex("IX_PharmacySupplierAssuranceCases_EvidenceId",
            "PharmacySupplierAssuranceCases", "EvidenceId");
    }

    protected override void Down(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.DropTable("PharmacySupplierAssuranceCases");
        migrationBuilder.DropUniqueConstraint("AK_PharmacySupplierEvidence_Id_SupplierId", "PharmacySupplierEvidence");
    }
}
