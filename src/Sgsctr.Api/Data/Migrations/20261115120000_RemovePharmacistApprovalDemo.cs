using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;
using Sgsctr.Api.Data;

namespace Sgsctr.Api.Data.Migrations;

[DbContext(typeof(AppDbContext))]
[Migration("20261115120000_RemovePharmacistApprovalDemo")]
public sealed class RemovePharmacistApprovalDemo : Migration
{
    protected override void Up(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.Sql("""
            ALTER TABLE "GovernanceApprovals"
                DROP CONSTRAINT "CK_GovernanceApprovals_Status";
            UPDATE "GovernanceApprovals"
            SET "Status" = 'Pending', "UpdatedAtUtc" = CURRENT_TIMESTAMP,
                "DecisionAtUtc" = NULL, "DecisionBySubject" = NULL,
                "DecisionReference" = NULL, "DecisionNotes" = NULL, "Conditions" = NULL
            WHERE "ApprovalCode" = 'INV-PRO-001' AND "Status" = 'DemoApproved';
            ALTER TABLE "GovernanceApprovals"
                ADD CONSTRAINT "CK_GovernanceApprovals_Status"
                CHECK ("Status" IN ('Pending','Approved','ApprovedWithConditions','Rejected','Withdrawn','Superseded'));
            """);
    }

    protected override void Down(MigrationBuilder migrationBuilder)
    {
        // Restore historical schema compatibility without recreating synthetic approval data.
        migrationBuilder.Sql("""
            ALTER TABLE "GovernanceApprovals"
                DROP CONSTRAINT "CK_GovernanceApprovals_Status";
            ALTER TABLE "GovernanceApprovals"
                ADD CONSTRAINT "CK_GovernanceApprovals_Status"
                CHECK ("Status" IN ('Pending','Approved','DemoApproved','ApprovedWithConditions','Rejected','Withdrawn','Superseded'));
            """);
    }
}
