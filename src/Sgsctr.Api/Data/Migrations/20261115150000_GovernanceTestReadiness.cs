using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;
using Sgsctr.Api.Data;

namespace Sgsctr.Api.Data.Migrations;

[DbContext(typeof(AppDbContext))]
[Migration("20261115150000_GovernanceTestReadiness")]
public sealed class GovernanceTestReadiness : Migration
{
    protected override void Up(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.CreateTable(
            name: "GovernanceTestCases",
            columns: table => new
            {
                Id = table.Column<Guid>(type: "uuid", nullable: false),
                GateCode = table.Column<string>(type: "character varying(32)", maxLength: 32, nullable: false),
                TestCode = table.Column<string>(type: "character varying(48)", maxLength: 48, nullable: false),
                Title = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: false),
                Objective = table.Column<string>(type: "character varying(1000)", maxLength: 1000, nullable: false),
                ExpectedResult = table.Column<string>(type: "character varying(2000)", maxLength: 2000, nullable: false),
                TestMode = table.Column<string>(type: "character varying(16)", maxLength: 16, nullable: false),
                ExecutionBlocked = table.Column<bool>(type: "boolean", nullable: false),
                BlockReason = table.Column<string>(type: "character varying(1000)", maxLength: 1000, nullable: true),
                CreatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_GovernanceTestCases", x => x.Id);
                table.CheckConstraint("CK_GovernanceTestCases_TestMode", "\"TestMode\" IN ('Automated','Manual')");
            });

        migrationBuilder.CreateTable(
            name: "GovernanceTestExecutions",
            columns: table => new
            {
                Id = table.Column<Guid>(type: "uuid", nullable: false),
                TestCaseId = table.Column<Guid>(type: "uuid", nullable: false),
                Status = table.Column<string>(type: "character varying(16)", maxLength: 16, nullable: false),
                Environment = table.Column<string>(type: "character varying(32)", maxLength: 32, nullable: false),
                EvidenceReference = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: true),
                Notes = table.Column<string>(type: "character varying(2000)", maxLength: 2000, nullable: true),
                ExecutedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                ExecutedBySubject = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_GovernanceTestExecutions", x => x.Id);
                table.CheckConstraint("CK_GovernanceTestExecutions_Status", "\"Status\" IN ('Passed','Failed','Blocked')");
                table.ForeignKey(
                    name: "FK_GovernanceTestExecutions_GovernanceTestCases_TestCaseId",
                    column: x => x.TestCaseId,
                    principalTable: "GovernanceTestCases",
                    principalColumn: "Id",
                    onDelete: ReferentialAction.Restrict);
            });

        migrationBuilder.CreateIndex(name: "IX_GovernanceTestCases_TestCode", table: "GovernanceTestCases", column: "TestCode", unique: true);
        migrationBuilder.CreateIndex(name: "IX_GovernanceTestCases_GateCode", table: "GovernanceTestCases", column: "GateCode");
        migrationBuilder.CreateIndex(name: "IX_GovernanceTestExecutions_TestCaseId_ExecutedAtUtc", table: "GovernanceTestExecutions", columns: new[] { "TestCaseId", "ExecutedAtUtc" });

        migrationBuilder.Sql("""
            INSERT INTO "GovernanceTestCases" (
                "Id","GateCode","TestCode","Title","Objective","ExpectedResult",
                "TestMode","ExecutionBlocked","BlockReason","CreatedAtUtc"
            ) VALUES
            ('20000000-0000-4000-8000-000000000001'::uuid,'PLATFORM-FOUNDATION','PLT-API-001','API liveness responds','Verify the ASP.NET Core API process responds independently of database readiness.','GET /health/live returns HTTP 200 and status=ok.','Automated',false,NULL,CURRENT_TIMESTAMP),
            ('20000000-0000-4000-8000-000000000002'::uuid,'PLATFORM-FOUNDATION','PLT-DB-001','PostgreSQL readiness checks both contexts','Verify PostgreSQL is reachable through AppDbContext and AuthDbContext.','GET /health/ready returns HTTP 200 and database, applicationContext and identityContext all equal connected.','Automated',false,NULL,CURRENT_TIMESTAMP),
            ('20000000-0000-4000-8000-000000000003'::uuid,'PLATFORM-FOUNDATION','PLT-WEB-001','Dashboard reports API and database independently','Verify the web BFF can reach API liveness and readiness and reports each result separately.','GET /api/system-status reports api=online, database=connected and HTTP status values; API offline must not be misreported as a database diagnosis.','Manual',false,NULL,CURRENT_TIMESTAMP),
            ('20000000-0000-4000-8000-000000000004'::uuid,'PLATFORM-FOUNDATION','PLT-MIG-001','Additive migration and startup verification','Apply pending EF migrations in the existing development database without deleting volumes or resetting data.','API starts healthy; migration history advances; existing reference data remains; INV-PRO-001 remains Pending.','Manual',false,NULL,CURRENT_TIMESTAMP),
            ('20000000-0000-4000-8000-000000000005'::uuid,'INV-PRO-001','PRO-BOUNDARY-001','Demo examples remain separate from real approval','Verify owner-supplied demo pharmacist examples never become professional approval evidence or change the authoritative register.','The approval API returns INV-PRO-001 as Pending; demo-only values are absent from GovernanceApprovals and cannot be interpreted as verified reviewer credentials.','Automated',false,NULL,CURRENT_TIMESTAMP),
            ('20000000-0000-4000-8000-000000000006'::uuid,'INV-PRO-001','PRO-REVIEW-001','Qualified pharmacist review evidence','Verify a real pharmacist''s identity, current registration/licence, delegated authority, explicit decision, scope, conditions and original evidence before recording professional approval.','Only independently verified reviewer evidence and the reviewer''s own decision can satisfy the gate; otherwise it remains Pending.','Manual',true,'Requires a genuine authorized pharmacist and verified original professional/authorization evidence.',CURRENT_TIMESTAMP),
            ('20000000-0000-4000-8000-000000000007'::uuid,'INV-PRO-001','PRO-OPS-001','Pharmacy operating workflow acceptance','Review product classification, receiving, batch/expiry, FEFO, quarantine, recall, returns and branch transfer lifecycle and exceptions.','Each workflow has an approved SOP, role/custody controls and test scenarios before operational implementation.','Manual',true,'The regulated pharmacy workflows are not implemented and their pharmacist/quality operating rules remain unapproved.',CURRENT_TIMESTAMP),
            ('20000000-0000-4000-8000-000000000008'::uuid,'INV-REG-001','REG-SCOPE-001','Egyptian regulatory and legal applicability','Verify current primary Egyptian instruments, EDA guidance, establishment/site licensing, product classes, importer/distributor role and effective dates.','A qualified Egyptian regulatory/legal reviewer records instrument identifiers, versions, applicability, limits and evidence for each in-scope operation/site/product family, including whether EDREX:GL.CALI/CIP.002 v05/2026 or EDREX:GL.CALI.10 v03/2026 applies to each site, the actual licence holder/site/activity, responsible pharmacist documentation, validity, permitted distribution area, GSDP status and any accessory-store treatment.','Manual',true,'Requires a qualified Egyptian regulatory/legal reviewer and verified Special Group licence, site and product records.',CURRENT_TIMESTAMP),
            ('20000000-0000-4000-8000-000000000009'::uuid,'INV-REG-001','REG-PROV-001','Regulatory evidence provenance and coverage','Verify each relied-on regulatory document has an authoritative source, version, publication/effective dates, retrieval date, language and review status.','The evidence register links original documents to affected requirements; uncovered sources and failed scans remain visible; no automatic business-rule changes occur.','Manual',true,'Requires qualified review of original current instruments and confirmation of Special Group applicability.',CURRENT_TIMESTAMP),
            ('20000000-0000-4000-8000-000000000010'::uuid,'INV-QLT-001','QLT-OPS-001','Quality controls and storage acceptance','Define and review receipt inspection, storage monitoring, calibration, temperature excursions, deviations, quarantine and disposition controls.','Qualified quality reviewer approves measurable acceptance criteria, SOP references, responsibilities and evidence requirements for each applicable site/product class.','Manual',true,'Quality procedures and product/site-specific acceptance criteria have not been approved.',CURRENT_TIMESTAMP),
            ('20000000-0000-4000-8000-000000000011'::uuid,'INV-QLT-001','QLT-RECALL-001','Recall, complaint and nonconformance scenarios','Walk through a mock non-production recall, affected-lot identification, quarantine, escalation, evidence retention and closure.','The complete traceability and disposition process is testable and signed off by the quality/pharmacy authorities; no real stock is changed during the test.','Manual',true,'Recall and quality disposition workflows are not implemented or professionally approved.',CURRENT_TIMESTAMP),
            ('20000000-0000-4000-8000-000000000012'::uuid,'INV-ACC-001','ACC-WAVG-001','Moving weighted-average worked examples','Prepare accountant-approved examples for purchase receipts, supplier returns, purchase price variance and cost-pool timing/precision.','System calculations reconcile exactly to approved examples, explicit currency, precision and rounding policy before any valuation code is enabled.','Manual',true,'Moving weighted-average policy and worked examples remain unapproved; no valuation engine exists.',CURRENT_TIMESTAMP),
            ('20000000-0000-4000-8000-000000000013'::uuid,'INV-ACC-001','ACC-TRANSFER-001','Transfer, return, adjustment and tax costing','Review direct branch-to-branch and warehouse transfers, returns, expiry/loss adjustments, rounding, tax and period-close treatment.','Qualified accountant approves each treatment and worked example; internal location movements are not modelled as sales or intercompany transactions without evidence.','Manual',true,'Transfer valuation, returns, adjustments, tax and posting policy require accountant and owner decisions.',CURRENT_TIMESTAMP),
            ('20000000-0000-4000-8000-000000000014'::uuid,'INV-OWN-002','OWN-POLICY-001','Owner operating-policy decisions','Collect and approve supplier qualification, purchasing limits, receiving authority, role separation, stock adjustment authority and branch-transfer controls.','Each policy has an owner, effective scope, approval evidence, version and review date; unresolved policies remain explicitly open.','Manual',true,'The owner operating-policy register is not yet approved; no defaults are inferred.',CURRENT_TIMESTAMP),
            ('20000000-0000-4000-8000-000000000015'::uuid,'INV-OWN-002','OWN-CUTOVER-001','Opening-stock and operational cutover','Define source records, opening-stock evidence, site ownership/custody, reconciliation, exception handling and cutover authorization.','Opening balances reconcile by product, unit, lot, expiry and location with a signed accountable-owner record before any import or posting.','Manual',true,'Opening-stock source data, reconciliation rules and cutover authorization are outstanding.',CURRENT_TIMESTAMP),
            ('20000000-0000-4000-8000-000000000016'::uuid,'INV-SEC-001','SEC-AUTH-001','Authentication, authorization and separation-of-duties tests','Run positive and negative tests for sign-in, invalid/expired token, refresh, logout, account status, role permissions and cross-sector/location denial.','Only authenticated users with explicitly approved permissions can perform scoped actions; all unauthorized cases are denied and auditable.','Manual',true,'Execution remains on hold under the owner''s earlier instruction; the business role/permission matrix and security review are pending.',CURRENT_TIMESTAMP),
            ('20000000-0000-4000-8000-000000000017'::uuid,'INV-SEC-001','SEC-RECOVERY-001','Data Protection, backup and restore assurance','Verify key-ring persistence/encryption, backup retention, secret ownership and restore into an isolated database/container.','A documented restore test meets owner-approved recovery objectives without overwriting the only working database.','Manual',true,'Data Protection volume verification remains on hold; backup/recovery objectives and security acceptance are pending.',CURRENT_TIMESTAMP),
            ('20000000-0000-4000-8000-000000000018'::uuid,'INV-REL-001','REL-REGRESSION-001','Controlled test-candidate regression','Run the complete approved acceptance suite across platform, pharmacy reference data, regulatory evidence, security and all applicable business workflows.','All in-scope tests pass on a versioned candidate; failed tests, unresolved risks and unapproved features are visible and cannot be waived by CI.','Manual',true,'Blocked until implementation is complete and all required professional, owner and security gates are resolved.',CURRENT_TIMESTAMP),
            ('20000000-0000-4000-8000-000000000019'::uuid,'INV-REL-001','REL-RELEASE-001','Release, migration and recovery authorization','Review candidate version, migration plan, backup/restore rehearsal, rollback, support ownership, monitoring and final approvals.','Authorized release owner explicitly approves a controlled release after all applicable gates and reconciliation evidence are complete.','Manual',true,'No production/release authorization exists; the required professional, security and owner approvals remain pending.',CURRENT_TIMESTAMP);
            """);
    }

    protected override void Down(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.DropTable(name: "GovernanceTestExecutions");
        migrationBuilder.DropTable(name: "GovernanceTestCases");
    }
}
