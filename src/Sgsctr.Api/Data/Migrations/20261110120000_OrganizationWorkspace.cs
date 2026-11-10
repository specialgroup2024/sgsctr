using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;
using Sgsctr.Api.Data;

namespace Sgsctr.Api.Data.Migrations;

[DbContext(typeof(AppDbContext))]
[Migration("20261110120000_OrganizationWorkspace")]
public sealed class OrganizationWorkspace : Migration
{
    protected override void Up(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.CreateTable(
            name: "OrganizationLocations",
            columns: table => new
            {
                Id = table.Column<Guid>(type: "uuid", nullable: false),
                Code = table.Column<string>(type: "character varying(24)", maxLength: 24, nullable: false),
                Name = table.Column<string>(type: "character varying(160)", maxLength: 160, nullable: false),
                SectorCode = table.Column<string>(type: "character varying(32)", maxLength: 32, nullable: false),
                LocationType = table.Column<string>(type: "character varying(32)", maxLength: 32, nullable: false),
                Notes = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: true),
                RecordStatus = table.Column<string>(type: "character varying(32)", maxLength: 32, nullable: false),
                IsActive = table.Column<bool>(type: "boolean", nullable: false),
                CreatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                UpdatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false)
            },
            constraints: table => table.PrimaryKey("PK_OrganizationLocations", x => x.Id));

        migrationBuilder.CreateIndex(
            name: "IX_OrganizationLocations_Code",
            table: "OrganizationLocations",
            column: "Code",
            unique: true);

        // Use explicit SQL instead of InsertData: this hand-authored migration has no
        // generated BuildTargetModel, so EF cannot resolve property mappings for seeding.
        // ON CONFLICT preserves any pre-existing owner-managed location with the same code.
        migrationBuilder.Sql("""
            INSERT INTO "OrganizationLocations"
                ("Id", "Code", "Name", "SectorCode", "LocationType", "Notes", "RecordStatus",
                 "IsActive", "CreatedAtUtc", "UpdatedAtUtc")
            VALUES
                ('10000000-0000-4000-8000-000000000001', 'WH-01', 'Mokattam', 'PHARMACIES', 'MainWarehouse',
                 'Owner-provided location name; legal ownership and licensing not verified.', 'OwnerProvided',
                 TRUE, TIMESTAMPTZ '2026-11-10 00:00:00+00', TIMESTAMPTZ '2026-11-10 00:00:00+00'),
                ('10000000-0000-4000-8000-000000000002', 'PH-02', 'Student Hospital', 'PHARMACIES', 'Branch',
                 'Owner-provided location name; legal ownership and licensing not verified.', 'OwnerProvided',
                 TRUE, TIMESTAMPTZ '2026-11-10 00:00:00+00', TIMESTAMPTZ '2026-11-10 00:00:00+00'),
                ('10000000-0000-4000-8000-000000000003', 'PH-03', 'Qasr El-Aini Hospital', 'PHARMACIES', 'Branch',
                 'Owner-provided location name; legal ownership and licensing not verified.', 'OwnerProvided',
                 TRUE, TIMESTAMPTZ '2026-11-10 00:00:00+00', TIMESTAMPTZ '2026-11-10 00:00:00+00'),
                ('10000000-0000-4000-8000-000000000004', 'PH-04', 'Manial Hospital', 'PHARMACIES', 'Branch',
                 'Owner-provided location name; legal ownership and licensing not verified.', 'OwnerProvided',
                 TRUE, TIMESTAMPTZ '2026-11-10 00:00:00+00', TIMESTAMPTZ '2026-11-10 00:00:00+00')
            ON CONFLICT ("Code") DO NOTHING;
            """);
    }

    protected override void Down(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.DropTable(name: "OrganizationLocations");
    }
}
