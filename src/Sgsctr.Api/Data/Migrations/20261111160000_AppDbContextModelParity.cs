using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;
using Sgsctr.Api.Data;

namespace Sgsctr.Api.Data.Migrations;

[DbContext(typeof(AppDbContext))]
[Migration("20261111160000_AppDbContextModelParity")]
public sealed class AppDbContextModelParity : Migration
{
    protected override void Up(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.CreateIndex(
            name: "IX_RegulatoryDocuments_SourceId",
            table: "RegulatoryDocuments",
            column: "SourceId");
    }

    protected override void Down(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.DropIndex(
            name: "IX_RegulatoryDocuments_SourceId",
            table: "RegulatoryDocuments");
    }
}
