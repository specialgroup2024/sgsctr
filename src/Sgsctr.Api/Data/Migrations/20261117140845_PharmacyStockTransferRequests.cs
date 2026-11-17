using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Sgsctr.Api.Migrations.AppDb
{
    /// <inheritdoc />
    public partial class PharmacyStockTransferRequests : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<Guid>(
                name: "StockTransferRequestId",
                table: "StockMovements",
                type: "uuid",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "StockTransferRequests",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    SourceLocationId = table.Column<Guid>(type: "uuid", nullable: false),
                    DestinationLocationId = table.Column<Guid>(type: "uuid", nullable: false),
                    Status = table.Column<string>(type: "text", nullable: false),
                    Reason = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: true),
                    RequestedBySubject = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: false),
                    ApprovedBySubject = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: true),
                    RequestedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    ApprovedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    UpdatedAtUtc = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    UpdatedBySubject = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_StockTransferRequests", x => x.Id);
                    table.CheckConstraint("CK_StockTransferRequests_Status", "\"Status\" IN ('Draft','Submitted','PendingApproval','Approved','Rejected','Cancelled')");
                    table.ForeignKey(
                        name: "FK_StockTransferRequests_OrganizationLocations_DestinationLoca~",
                        column: x => x.DestinationLocationId,
                        principalTable: "OrganizationLocations",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_StockTransferRequests_OrganizationLocations_SourceLocationId",
                        column: x => x.SourceLocationId,
                        principalTable: "OrganizationLocations",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "StockTransferRequestLines",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    StockTransferRequestId = table.Column<Guid>(type: "uuid", nullable: false),
                    ProductId = table.Column<Guid>(type: "uuid", nullable: false),
                    UnitId = table.Column<Guid>(type: "uuid", nullable: false),
                    Quantity = table.Column<decimal>(type: "numeric", nullable: false),
                    LotNumber = table.Column<string>(type: "character varying(64)", maxLength: 64, nullable: true),
                    ExpiryDate = table.Column<DateOnly>(type: "date", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_StockTransferRequestLines", x => x.Id);
                    table.CheckConstraint("CK_StockTransferRequestLines_QuantityPositive", "\"Quantity\" > 0");
                    table.ForeignKey(
                        name: "FK_StockTransferRequestLines_CatalogueProducts_ProductId",
                        column: x => x.ProductId,
                        principalTable: "CatalogueProducts",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_StockTransferRequestLines_StockTransferRequests_StockTransf~",
                        column: x => x.StockTransferRequestId,
                        principalTable: "StockTransferRequests",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_StockTransferRequestLines_UnitsOfMeasure_UnitId",
                        column: x => x.UnitId,
                        principalTable: "UnitsOfMeasure",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "IX_StockMovements_StockTransferRequestId",
                table: "StockMovements",
                column: "StockTransferRequestId");

            migrationBuilder.CreateIndex(
                name: "IX_StockTransferRequestLines_ProductId",
                table: "StockTransferRequestLines",
                column: "ProductId");

            migrationBuilder.CreateIndex(
                name: "IX_StockTransferRequestLines_StockTransferRequestId_ProductId_~",
                table: "StockTransferRequestLines",
                columns: new[] { "StockTransferRequestId", "ProductId", "UnitId" });

            migrationBuilder.CreateIndex(
                name: "IX_StockTransferRequestLines_UnitId",
                table: "StockTransferRequestLines",
                column: "UnitId");

            migrationBuilder.CreateIndex(
                name: "IX_StockTransferRequests_DestinationLocationId",
                table: "StockTransferRequests",
                column: "DestinationLocationId");

            migrationBuilder.CreateIndex(
                name: "IX_StockTransferRequests_RequestedAtUtc",
                table: "StockTransferRequests",
                column: "RequestedAtUtc");

            migrationBuilder.CreateIndex(
                name: "IX_StockTransferRequests_SourceLocationId_DestinationLocationI~",
                table: "StockTransferRequests",
                columns: new[] { "SourceLocationId", "DestinationLocationId", "Status" });

            migrationBuilder.AddForeignKey(
                name: "FK_StockMovements_StockTransferRequests_StockTransferRequestId",
                table: "StockMovements",
                column: "StockTransferRequestId",
                principalTable: "StockTransferRequests",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_StockMovements_StockTransferRequests_StockTransferRequestId",
                table: "StockMovements");

            migrationBuilder.DropTable(
                name: "StockTransferRequestLines");

            migrationBuilder.DropTable(
                name: "StockTransferRequests");

            migrationBuilder.DropIndex(
                name: "IX_StockMovements_StockTransferRequestId",
                table: "StockMovements");

            migrationBuilder.DropColumn(
                name: "StockTransferRequestId",
                table: "StockMovements");
        }
    }
}
