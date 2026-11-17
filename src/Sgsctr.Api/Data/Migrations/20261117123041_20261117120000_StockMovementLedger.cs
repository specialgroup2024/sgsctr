using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Sgsctr.Api.Data.Migrations
{
    /// <inheritdoc />
    public partial class _20261117120000_StockMovementLedger : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "StockMovements",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    LocationId = table.Column<Guid>(type: "uuid", nullable: false),
                    ProductId = table.Column<Guid>(type: "uuid", nullable: false),
                    UnitId = table.Column<Guid>(type: "uuid", nullable: false),
                    Quantity = table.Column<decimal>(type: "numeric", nullable: false),
                    MovementType = table.Column<string>(type: "character varying(16)", maxLength: 16, nullable: false),
                    LotNumber = table.Column<string>(type: "character varying(64)", maxLength: 64, nullable: true),
                    ExpiryDate = table.Column<DateOnly>(type: "date", nullable: true),
                    Reference = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: true),
                    Reason = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: false),
                    Status = table.Column<string>(type: "character varying(16)", maxLength: 16, nullable: false),
                    ReversalOfId = table.Column<Guid>(type: "uuid", nullable: true),
                    CreatedBySubject = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: false),
                    CreatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_StockMovements", x => x.Id);
                    table.CheckConstraint("CK_StockMovements_MovementType", "\"MovementType\" IN ('Receipt','Issue','Adjustment','Count','TransferIn','TransferOut','Return')");
                    table.CheckConstraint("CK_StockMovements_QuantityNonZero", "\"Quantity\" <> 0");
                    table.CheckConstraint("CK_StockMovements_Status", "\"Status\" IN ('Draft','Posted','Reversed')");
                    table.ForeignKey(
                        name: "FK_StockMovements_CatalogueProducts_ProductId",
                        column: x => x.ProductId,
                        principalTable: "CatalogueProducts",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_StockMovements_OrganizationLocations_LocationId",
                        column: x => x.LocationId,
                        principalTable: "OrganizationLocations",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_StockMovements_StockMovements_ReversalOfId",
                        column: x => x.ReversalOfId,
                        principalTable: "StockMovements",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_StockMovements_UnitsOfMeasure_UnitId",
                        column: x => x.UnitId,
                        principalTable: "UnitsOfMeasure",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "IX_StockMovements_CreatedAtUtc",
                table: "StockMovements",
                column: "CreatedAtUtc");

            migrationBuilder.CreateIndex(
                name: "IX_StockMovements_LocationId_ProductId_UnitId_LotNumber_Expiry~",
                table: "StockMovements",
                columns: new[] { "LocationId", "ProductId", "UnitId", "LotNumber", "ExpiryDate", "Status" });

            migrationBuilder.CreateIndex(
                name: "IX_StockMovements_ProductId",
                table: "StockMovements",
                column: "ProductId");

            migrationBuilder.CreateIndex(
                name: "IX_StockMovements_ReversalOfId",
                table: "StockMovements",
                column: "ReversalOfId");

            migrationBuilder.CreateIndex(
                name: "IX_StockMovements_UnitId",
                table: "StockMovements",
                column: "UnitId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "StockMovements");
        }
    }
}
