using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;
using Sgsctr.Api.Data;

namespace Sgsctr.Api.Data.Migrations;

[DbContext(typeof(AppDbContext))]
[Migration("20261111140000_EdaRegulatoryIntelligence")]
public sealed class EdaRegulatoryIntelligence : Migration
{
    protected override void Up(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.CreateTable(
            name: "RegulatorySources",
            columns: table => new
            {
                Id = table.Column<Guid>(type: "uuid", nullable: false),
                Code = table.Column<string>(type: "character varying(48)", maxLength: 48, nullable: false),
                Name = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: false),
                Url = table.Column<string>(type: "character varying(1000)", maxLength: 1000, nullable: false),
                AllowedHost = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: false),
                SourceClass = table.Column<string>(type: "character varying(8)", maxLength: 8, nullable: false),
                IsEnabled = table.Column<bool>(type: "boolean", nullable: false),
                PollIntervalMinutes = table.Column<int>(type: "integer", nullable: false),
                LastCheckedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                LastSuccessAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                LastError = table.Column<string>(type: "character varying(1000)", maxLength: 1000, nullable: true),
                CreatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false)
            },
            constraints: table => table.PrimaryKey("PK_RegulatorySources", x => x.Id));

        migrationBuilder.CreateTable(
            name: "RegulatoryDocuments",
            columns: table => new
            {
                Id = table.Column<Guid>(type: "uuid", nullable: false),
                SourceId = table.Column<Guid>(type: "uuid", nullable: false),
                Title = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: false),
                SourceUrl = table.Column<string>(type: "character varying(2000)", maxLength: 2000, nullable: false),
                ContentHash = table.Column<string>(type: "character varying(64)", maxLength: 64, nullable: false),
                ContentType = table.Column<string>(type: "character varying(120)", maxLength: 120, nullable: false),
                Language = table.Column<string>(type: "character varying(8)", maxLength: 8, nullable: false),
                SourceClass = table.Column<string>(type: "character varying(8)", maxLength: 8, nullable: false),
                Topic = table.Column<string>(type: "character varying(80)", maxLength: 80, nullable: false),
                Modules = table.Column<string>(type: "character varying(300)", maxLength: 300, nullable: false),
                VerificationStatus = table.Column<string>(type: "character varying(32)", maxLength: 32, nullable: false),
                ReviewStatus = table.Column<string>(type: "character varying(32)", maxLength: 32, nullable: false),
                Severity = table.Column<string>(type: "character varying(32)", maxLength: 32, nullable: false),
                PublishedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                RetrievedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                OriginalContent = table.Column<byte[]>(type: "bytea", nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_RegulatoryDocuments", x => x.Id);
                table.ForeignKey("FK_RegulatoryDocuments_RegulatorySources_SourceId", x => x.SourceId, "RegulatorySources", "Id", onDelete: ReferentialAction.Restrict);
            });

        migrationBuilder.CreateTable(
            name: "RegulatoryScanRuns",
            columns: table => new
            {
                Id = table.Column<Guid>(type: "uuid", nullable: false),
                SourceId = table.Column<Guid>(type: "uuid", nullable: false),
                StartedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                CompletedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                DiscoveredCount = table.Column<int>(type: "integer", nullable: false),
                NewDocumentCount = table.Column<int>(type: "integer", nullable: false),
                Status = table.Column<string>(type: "character varying(24)", maxLength: 24, nullable: false),
                ErrorMessage = table.Column<string>(type: "character varying(1000)", maxLength: 1000, nullable: true)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_RegulatoryScanRuns", x => x.Id);
                table.ForeignKey("FK_RegulatoryScanRuns_RegulatorySources_SourceId", x => x.SourceId, "RegulatorySources", "Id", onDelete: ReferentialAction.Restrict);
            });

        migrationBuilder.CreateTable(
            name: "RegulatoryAlerts",
            columns: table => new
            {
                Id = table.Column<Guid>(type: "uuid", nullable: false),
                DocumentId = table.Column<Guid>(type: "uuid", nullable: false),
                AlertType = table.Column<string>(type: "character varying(48)", maxLength: 48, nullable: false),
                Status = table.Column<string>(type: "character varying(24)", maxLength: 24, nullable: false),
                CreatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                AcknowledgedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                AcknowledgedBy = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: true)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_RegulatoryAlerts", x => x.Id);
                table.ForeignKey("FK_RegulatoryAlerts_RegulatoryDocuments_DocumentId", x => x.DocumentId, "RegulatoryDocuments", "Id", onDelete: ReferentialAction.Cascade);
            });

        migrationBuilder.CreateIndex("IX_RegulatorySources_Code", "RegulatorySources", "Code", unique: true);
        migrationBuilder.CreateIndex("IX_RegulatoryDocuments_SourceUrl", "RegulatoryDocuments", "SourceUrl", unique: true);
        migrationBuilder.CreateIndex("IX_RegulatoryDocuments_ContentHash", "RegulatoryDocuments", "ContentHash", unique: true);
        migrationBuilder.CreateIndex("IX_RegulatoryDocuments_ReviewStatus_RetrievedAtUtc", "RegulatoryDocuments", new[] { "ReviewStatus", "RetrievedAtUtc" });
        migrationBuilder.CreateIndex("IX_RegulatoryDocuments_SourceId", "RegulatoryDocuments", "SourceId");
        migrationBuilder.CreateIndex("IX_RegulatoryScanRuns_SourceId_StartedAtUtc", "RegulatoryScanRuns", new[] { "SourceId", "StartedAtUtc" });
        migrationBuilder.CreateIndex("IX_RegulatoryAlerts_Status_CreatedAtUtc", "RegulatoryAlerts", new[] { "Status", "CreatedAtUtc" });
        migrationBuilder.CreateIndex("IX_RegulatoryAlerts_DocumentId", "RegulatoryAlerts", "DocumentId", unique: true);
    }

    protected override void Down(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.DropTable("RegulatoryAlerts");
        migrationBuilder.DropTable("RegulatoryScanRuns");
        migrationBuilder.DropTable("RegulatoryDocuments");
        migrationBuilder.DropTable("RegulatorySources");
    }
}
