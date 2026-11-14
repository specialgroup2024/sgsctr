using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;
using Sgsctr.Api.Data;

namespace Sgsctr.Api.Data.Migrations;

[DbContext(typeof(AppDbContext))]
[Migration("20261114130000_PharmacyCatalogueReferenceData")]
public sealed class PharmacyCatalogueReferenceData : Migration
{
    protected override void Up(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.CreateTable(
            name: "CatalogueProducts",
            columns: table => new
            {
                Id = table.Column<Guid>(type: "uuid", nullable: false),
                DisplayName = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: false),
                Description = table.Column<string>(type: "character varying(1000)", maxLength: 1000, nullable: true),
                Status = table.Column<string>(type: "character varying(16)", maxLength: 16, nullable: false),
                Version = table.Column<int>(type: "integer", nullable: false),
                CreatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                UpdatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                CreatedBySubject = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: false),
                UpdatedBySubject = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: false)
            },
            constraints: table => table.PrimaryKey("PK_CatalogueProducts", x => x.Id));

        migrationBuilder.CreateTable(
            name: "UnitsOfMeasure",
            columns: table => new
            {
                Id = table.Column<Guid>(type: "uuid", nullable: false),
                Code = table.Column<string>(type: "character varying(24)", maxLength: 24, nullable: false),
                Name = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                Symbol = table.Column<string>(type: "character varying(24)", maxLength: 24, nullable: true),
                CreatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                CreatedBySubject = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: false)
            },
            constraints: table => table.PrimaryKey("PK_UnitsOfMeasure", x => x.Id));

        migrationBuilder.CreateTable(
            name: "CatalogueAuditEvents",
            columns: table => new
            {
                Id = table.Column<Guid>(type: "uuid", nullable: false),
                ActorSubject = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: false),
                Action = table.Column<string>(type: "character varying(48)", maxLength: 48, nullable: false),
                ResourceType = table.Column<string>(type: "character varying(48)", maxLength: 48, nullable: false),
                ResourceId = table.Column<Guid>(type: "uuid", nullable: false),
                OccurredAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                Outcome = table.Column<string>(type: "character varying(24)", maxLength: 24, nullable: false),
                Reason = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: true),
                CorrelationId = table.Column<string>(type: "character varying(128)", maxLength: 128, nullable: false)
            },
            constraints: table => table.PrimaryKey("PK_CatalogueAuditEvents", x => x.Id));

        migrationBuilder.CreateTable(
            name: "ProductUnitConversions",
            columns: table => new
            {
                Id = table.Column<Guid>(type: "uuid", nullable: false),
                ProductId = table.Column<Guid>(type: "uuid", nullable: false),
                FromUnitId = table.Column<Guid>(type: "uuid", nullable: false),
                ToUnitId = table.Column<Guid>(type: "uuid", nullable: false),
                Numerator = table.Column<long>(type: "bigint", nullable: false),
                Denominator = table.Column<long>(type: "bigint", nullable: false),
                Status = table.Column<string>(type: "character varying(16)", maxLength: 16, nullable: false),
                CreatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                CreatedBySubject = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_ProductUnitConversions", x => x.Id);
                table.CheckConstraint("CK_ProductUnitConversions_PositiveRatio", "\"Numerator\" > 0 AND \"Denominator\" > 0");
                table.ForeignKey("FK_ProductUnitConversions_CatalogueProducts_ProductId", x => x.ProductId, "CatalogueProducts", "Id", onDelete: ReferentialAction.Restrict);
                table.ForeignKey("FK_ProductUnitConversions_UnitsOfMeasure_FromUnitId", x => x.FromUnitId, "UnitsOfMeasure", "Id", onDelete: ReferentialAction.Restrict);
                table.ForeignKey("FK_ProductUnitConversions_UnitsOfMeasure_ToUnitId", x => x.ToUnitId, "UnitsOfMeasure", "Id", onDelete: ReferentialAction.Restrict);
            });

        migrationBuilder.CreateIndex("IX_CatalogueProducts_DisplayName", "CatalogueProducts", "DisplayName");
        migrationBuilder.CreateIndex("IX_UnitsOfMeasure_Code", "UnitsOfMeasure", "Code", unique: true);
        migrationBuilder.CreateIndex("IX_ProductUnitConversions_ProductId_FromUnitId_ToUnitId", "ProductUnitConversions",
            new[] { "ProductId", "FromUnitId", "ToUnitId" }, unique: true);
        migrationBuilder.CreateIndex("IX_ProductUnitConversions_FromUnitId", "ProductUnitConversions", "FromUnitId");
        migrationBuilder.CreateIndex("IX_ProductUnitConversions_ToUnitId", "ProductUnitConversions", "ToUnitId");
        migrationBuilder.CreateIndex("IX_CatalogueAuditEvents_ResourceType_ResourceId_OccurredAtUtc", "CatalogueAuditEvents",
            new[] { "ResourceType", "ResourceId", "OccurredAtUtc" });
    }

    protected override void Down(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.DropTable("ProductUnitConversions");
        migrationBuilder.DropTable("CatalogueAuditEvents");
        migrationBuilder.DropTable("UnitsOfMeasure");
        migrationBuilder.DropTable("CatalogueProducts");
    }
}
