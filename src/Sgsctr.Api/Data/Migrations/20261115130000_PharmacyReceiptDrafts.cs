using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;
using Sgsctr.Api.Data;

namespace Sgsctr.Api.Data.Migrations;

[DbContext(typeof(AppDbContext))]
[Migration("20261115130000_PharmacyReceiptDrafts")]
public sealed class PharmacyReceiptDrafts : Migration
{
    protected override void Up(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.CreateTable(
            name: "PharmacyReceiptDrafts",
            columns: table => new
            {
                Id = table.Column<Guid>(type: "uuid", nullable: false),
                LocationId = table.Column<Guid>(type: "uuid", nullable: false),
                SupplierReference = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: false),
                DeliveryReference = table.Column<string>(type: "character varying(160)", maxLength: 160, nullable: true),
                Status = table.Column<string>(type: "character varying(16)", maxLength: 16, nullable: false),
                CreatedBySubject = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: false),
                CreatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                UpdatedBySubject = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: false),
                UpdatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                ChangeReason = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_PharmacyReceiptDrafts", x => x.Id);
                table.CheckConstraint("CK_PharmacyReceiptDrafts_DraftOnly", "\"Status\" = 'Draft'");
                table.ForeignKey("FK_PharmacyReceiptDrafts_OrganizationLocations_LocationId",
                    x => x.LocationId, "OrganizationLocations", "Id", onDelete: ReferentialAction.Restrict);
            });

        migrationBuilder.CreateTable(
            name: "PharmacyReceiptDraftLines",
            columns: table => new
            {
                Id = table.Column<Guid>(type: "uuid", nullable: false),
                ReceiptDraftId = table.Column<Guid>(type: "uuid", nullable: false),
                ProductId = table.Column<Guid>(type: "uuid", nullable: false),
                UnitId = table.Column<Guid>(type: "uuid", nullable: false),
                Quantity = table.Column<decimal>(type: "numeric(18,6)", precision: 18, scale: 6, nullable: false),
                SupplierItemReference = table.Column<string>(type: "character varying(160)", maxLength: 160, nullable: true)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_PharmacyReceiptDraftLines", x => x.Id);
                table.CheckConstraint("CK_PharmacyReceiptDraftLines_PositiveQuantity", "\"Quantity\" > 0");
                table.ForeignKey("FK_PharmacyReceiptDraftLines_PharmacyReceiptDrafts_ReceiptDraftId",
                    x => x.ReceiptDraftId, "PharmacyReceiptDrafts", "Id", onDelete: ReferentialAction.Restrict);
                table.ForeignKey("FK_PharmacyReceiptDraftLines_CatalogueProducts_ProductId",
                    x => x.ProductId, "CatalogueProducts", "Id", onDelete: ReferentialAction.Restrict);
                table.ForeignKey("FK_PharmacyReceiptDraftLines_UnitsOfMeasure_UnitId",
                    x => x.UnitId, "UnitsOfMeasure", "Id", onDelete: ReferentialAction.Restrict);
            });

        migrationBuilder.CreateIndex("IX_PharmacyReceiptDrafts_LocationId_CreatedAtUtc",
            "PharmacyReceiptDrafts", new[] { "LocationId", "CreatedAtUtc" });
        migrationBuilder.CreateIndex("IX_PharmacyReceiptDraftLines_ReceiptDraftId",
            "PharmacyReceiptDraftLines", "ReceiptDraftId");
        migrationBuilder.CreateIndex("IX_PharmacyReceiptDraftLines_ProductId",
            "PharmacyReceiptDraftLines", "ProductId");
        migrationBuilder.CreateIndex("IX_PharmacyReceiptDraftLines_UnitId",
            "PharmacyReceiptDraftLines", "UnitId");
    }

    protected override void Down(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.DropTable("PharmacyReceiptDraftLines");
        migrationBuilder.DropTable("PharmacyReceiptDrafts");
    }
}
