using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;
using Sgsctr.Api.Data;

namespace Sgsctr.Api.Data.Migrations;

[DbContext(typeof(AuthDbContext))]
[Migration("20261111090209_IdentityModelAlignment")]
public sealed class IdentityModelAlignment : Migration
{
    // PostgreSQL identity-by-default strategy was already created by NativeIdentity.
    // This migration records the provider metadata correction only; it does not alter tables or account data.
    protected override void Up(MigrationBuilder migrationBuilder) { }
    protected override void Down(MigrationBuilder migrationBuilder) { }
}
