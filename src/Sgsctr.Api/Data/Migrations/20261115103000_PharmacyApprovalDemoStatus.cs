using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;
using Sgsctr.Api.Data;

namespace Sgsctr.Api.Data.Migrations;

[DbContext(typeof(AppDbContext))]
[Migration("20261115103000_PharmacyApprovalDemoStatus")]
public sealed class PharmacyApprovalDemoStatus : Migration
{
    protected override void Up(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.Sql("""
            ALTER TABLE "GovernanceApprovals"
                DROP CONSTRAINT "CK_GovernanceApprovals_Status";

            ALTER TABLE "GovernanceApprovals"
                ADD CONSTRAINT "CK_GovernanceApprovals_Status"
                CHECK ("Status" IN ('Pending','Approved','DemoApproved','ApprovedWithConditions','Rejected','Withdrawn','Superseded'));

            UPDATE "GovernanceApprovals"
            SET "Status" = 'DemoApproved',
                "UpdatedAtUtc" = TIMESTAMPTZ '2026-11-15 00:00:00+00',
                "DecisionAtUtc" = TIMESTAMPTZ '2026-11-15 00:00:00+00',
                "DecisionBySubject" = 'DEMO: authorized pharmacist (synthetic reviewer; identity not recorded)',
                "DecisionReference" = '.ai/delivery/pharmacy-inventory-pharmacist-demo-approval.md',
                "DecisionNotes" = 'DEMO DATA ONLY: this synthetic record demonstrates the approved-state UI for a pharmacist review at the owner request. It is not evidence that a real pharmacist reviewed or approved any operating procedure.',
                "Conditions" = 'Synthetic demonstration only; does not satisfy the professional approval gate; no pharmacy operations may rely on this record.'
            WHERE "ApprovalCode" = 'INV-PRO-001' AND "Status" = 'Pending';
            """);
    }

    protected override void Down(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.Sql("""
            UPDATE "GovernanceApprovals"
            SET "Status" = 'Pending',
                "UpdatedAtUtc" = TIMESTAMPTZ '2026-11-14 00:00:00+00',
                "DecisionAtUtc" = NULL,
                "DecisionBySubject" = NULL,
                "DecisionReference" = NULL,
                "DecisionNotes" = NULL,
                "Conditions" = NULL
            WHERE "ApprovalCode" = 'INV-PRO-001' AND "Status" = 'DemoApproved';

            ALTER TABLE "GovernanceApprovals"
                DROP CONSTRAINT "CK_GovernanceApprovals_Status";

            ALTER TABLE "GovernanceApprovals"
                ADD CONSTRAINT "CK_GovernanceApprovals_Status"
                CHECK ("Status" IN ('Pending','Approved','ApprovedWithConditions','Rejected','Withdrawn','Superseded'));
            """);
    }
}
