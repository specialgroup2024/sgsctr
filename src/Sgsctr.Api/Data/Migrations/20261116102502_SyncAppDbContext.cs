using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Sgsctr.Api.Migrations.AppDb
{
    /// <inheritdoc />
    public partial class SyncAppDbContext : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateIndex(
                name: "IX_PharmacySupplierAssuranceCases_EvidenceId_SupplierId",
                table: "PharmacySupplierAssuranceCases",
                columns: new[] { "EvidenceId", "SupplierId" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_PharmacySupplierAssuranceCases_EvidenceId_SupplierId",
                table: "PharmacySupplierAssuranceCases");
        }
    }
}
