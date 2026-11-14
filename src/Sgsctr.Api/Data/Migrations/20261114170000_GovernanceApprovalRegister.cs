using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;
using Sgsctr.Api.Data;

namespace Sgsctr.Api.Data.Migrations;

[DbContext(typeof(AppDbContext))]
[Migration("20261114170000_GovernanceApprovalRegister")]
public sealed class GovernanceApprovalRegister : Migration
{
    protected override void Up(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.CreateTable(
            name: "GovernanceApprovals",
            columns: table => new
            {
                Id = table.Column<Guid>(type: "uuid", nullable: false),
                ApprovalCode = table.Column<string>(type: "character varying(32)", maxLength: 32, nullable: false),
                Title = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: false),
                RequiredApproverRole = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                Status = table.Column<string>(type: "character varying(32)", maxLength: 32, nullable: false),
                ScopeDescription = table.Column<string>(type: "character varying(2000)", maxLength: 2000, nullable: false),
                EvidenceReference = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: false),
                CreatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                UpdatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                DecisionAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                DecisionBySubject = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: true),
                DecisionReference = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: true),
                DecisionNotes = table.Column<string>(type: "character varying(2000)", maxLength: 2000, nullable: true),
                Conditions = table.Column<string>(type: "character varying(2000)", maxLength: 2000, nullable: true)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_GovernanceApprovals", x => x.Id);
                table.CheckConstraint("CK_GovernanceApprovals_Status",
                    "\"Status\" IN ('Pending','Approved','ApprovedWithConditions','Rejected','Withdrawn','Superseded')");
            });

        migrationBuilder.CreateIndex(
            name: "IX_GovernanceApprovals_ApprovalCode",
            table: "GovernanceApprovals",
            column: "ApprovalCode",
            unique: true);
        migrationBuilder.CreateIndex(
            name: "IX_GovernanceApprovals_Status_RequiredApproverRole",
            table: "GovernanceApprovals",
            columns: new[] { "Status", "RequiredApproverRole" });

        var created = new DateTimeOffset(2026, 11, 14, 0, 0, 0, TimeSpan.Zero);
        migrationBuilder.InsertData(
            table: "GovernanceApprovals",
            columns: new[] { "Id", "ApprovalCode", "Title", "RequiredApproverRole", "Status", "ScopeDescription", "EvidenceReference", "CreatedAtUtc", "UpdatedAtUtc", "DecisionAtUtc", "DecisionBySubject", "DecisionReference", "DecisionNotes", "Conditions" },
            values: new object[,]
            {
                { Guid.Parse("10000000-0000-4000-8000-000000000001"), "INV-OWN-001", "Pharmacy Inventory delivery authorization", "Project owner", "Approved", "Authorization to deliver staged Pharmacy Inventory work across database, API, UI, tests and governance. Does not approve professional decisions or production use.", ".ai/delivery/pharmacy-inventory-owner-authorization-and-execution.md", created, created, created, null!, ".ai/delivery/pharmacy-inventory-owner-authorization-and-execution.md", "Owner authorization is recorded in the repository. The authenticated application identity of the approver was not captured in this record.", "Professional sign-offs and production release remain separate gates." },
                { Guid.Parse("10000000-0000-4000-8000-000000000002"), "INV-PRO-001", "Pharmacist / pharmacy-operations approval", "Qualified pharmacist / pharmacy operations", "Pending", "Product-family applicability, lot/expiry/serial controls, FEFO, receiving, quarantine, recall, returns and operational exceptions.", ".ai/delivery/pharmacy-inventory-inv01-approval-pack.md", created, created, null!, null!, null!, null!, null! },
                { Guid.Parse("10000000-0000-4000-8000-000000000003"), "INV-REG-001", "Egyptian regulatory / legal approval", "Qualified Egyptian regulatory / legal reviewer", "Pending", "Site/operator licensing, product-specific EDA/EPTTS obligations, record retention and legal applicability.", ".ai/governance/evidence-register.md", created, created, null!, null!, null!, null!, null! },
                { Guid.Parse("10000000-0000-4000-8000-000000000004"), "INV-QLT-001", "Quality approval", "Designated qualified quality reviewer", "Pending", "Inspection, storage evidence, deviations, rejection/quarantine, recall and disposition controls.", ".ai/delivery/pharmacy-inventory-owner-authorization-and-execution.md", created, created, null!, null!, null!, null!, null! },
                { Guid.Parse("10000000-0000-4000-8000-000000000005"), "INV-ACC-001", "Accountant approval", "Qualified accountant / tax adviser", "Pending", "Moving weighted-average valuation pool, timing, transfers, returns, losses, expiry, adjustments, rounding, tax and period close.", ".ai/delivery/pharmacy-inventory-costing-worked-examples.md", created, created, null!, null!, null!, null!, null! },
                { Guid.Parse("10000000-0000-4000-8000-000000000006"), "INV-OWN-002", "Owner approval of operating policies", "Project owner", "Pending", "Supplier qualification, purchasing limits, separation of duties, adjustment authority, opening-stock cutover and production release.", ".ai/delivery/pharmacy-inventory-owner-authorization-and-execution.md", created, created, null!, null!, null!, null!, null! },
                { Guid.Parse("10000000-0000-4000-8000-000000000007"), "INV-SEC-001", "Security review and residual-risk acceptance", "Designated security reviewer and project owner", "Pending", "Server-side access controls, separation of duties, audit integrity, privacy and production security.", ".ai/governance/approval-register.md", created, created, null!, null!, null!, null!, null! },
                { Guid.Parse("10000000-0000-4000-8000-000000000008"), "INV-REL-001", "Controlled production release", "Authorized release authority plus applicable professional sign-offs", "Pending", "End-to-end acceptance, professional sign-offs, migration rehearsal, recovery, opening-stock reconciliation and explicit release authorization.", ".ai/governance/approval-register.md", created, created, null!, null!, null!, null!, null! }
            });
    }

    protected override void Down(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.DropTable(name: "GovernanceApprovals");
    }
}
