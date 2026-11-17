using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Sgsctr.Api.Migrations.AppDb
{
    /// <inheritdoc />
    public partial class PharmacyStockTransferLocationCheck : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddCheckConstraint(
                name: "CK_StockTransferRequests_DifferentLocations",
                table: "StockTransferRequests",
                sql: "\"SourceLocationId\" <> \"DestinationLocationId\"");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropCheckConstraint(
                name: "CK_StockTransferRequests_DifferentLocations",
                table: "StockTransferRequests");
        }
    }
}
