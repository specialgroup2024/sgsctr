using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;
using Sgsctr.Api.Data;

namespace Sgsctr.Api.Data.Migrations;

[DbContext(typeof(AppDbContext))]
[Migration("20261115090000_SeedPharmacistApprovalDemo")]
public sealed class SeedPharmacistApprovalDemo : Migration
{
    protected override void Up(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.Sql("""
            ALTER TABLE "GovernanceApprovals"
                DROP CONSTRAINT "CK_GovernanceApprovals_Status";

            ALTER TABLE "GovernanceApprovals"
                ADD CONSTRAINT "CK_GovernanceApprovals_Status"
                CHECK ("Status" IN (
                    'Pending',
                    'Approved',
                    'DemoApproved',
                    'ApprovedWithConditions',
                    'Rejected',
                    'Withdrawn',
                    'Superseded'
                ));

            UPDATE "GovernanceApprovals"
            SET
                "Status" = 'DemoApproved',
                "UpdatedAtUtc" = TIMESTAMPTZ '2026-11-15 00:00:00+00',
                "DecisionAtUtc" = TIMESTAMPTZ '2026-11-15 00:00:00+00',
                "DecisionBySubject" = 'DEMO: authorized pharmacist',
                "DecisionReference" = '.ai/delivery/pharmacy-inventory-pharmacist-demo-approval.md',
                "DecisionNotes" = 'DEMO DATA ONLY: synthetic demonstration of an approved pharmacist / pharmacy-operations state. No real pharmacist identity, qualification, delegation, signed review or professional decision has been verified.',
                "Conditions" = 'Synthetic UI demonstration only. This does not satisfy the professional approval gate and must not authorize receiving, FEFO, quarantine, recall, returns, dispensing, stock movements or any pharmacy operation.'
            WHERE "ApprovalCode" = 'INV-PRO-001';
            """);
    }

    protected override void Down(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.Sql("""
            UPDATE "GovernanceApprovals"
            SET
                "Status" = 'Pending',
                "UpdatedAtUtc" = CURRENT_TIMESTAMP,
                "DecisionAtUtc" = NULL,
                "DecisionBySubject" = NULL,
                "DecisionReference" = NULL,
                "DecisionNotes" = NULL,
                "Conditions" = NULL
            WHERE "ApprovalCode" = 'INV-PRO-001';

            ALTER TABLE "GovernanceApprovals"
                DROP CONSTRAINT "CK_GovernanceApprovals_Status";

            ALTER TABLE "GovernanceApprovals"
                ADD CONSTRAINT "CK_GovernanceApprovals_Status"
                CHECK ("Status" IN (
                    'Pending',
                    'Approved',
                    'ApprovedWithConditions',
                    'Rejected',
                    'Withdrawn',
                    'Superseded'
                ));
            """);
    }
}
