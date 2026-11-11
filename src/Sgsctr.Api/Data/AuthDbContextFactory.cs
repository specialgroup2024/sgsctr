using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;
using Microsoft.Extensions.DependencyInjection;
using Sgsctr.Api.Data;

namespace Sgsctr.Api.Data;

/// <summary>
/// Ensures EF tooling builds the Identity model with the same schema-shaping options
/// as the running API. Never connect this factory to or mutate a production database.
/// </summary>
public sealed class AuthDbContextFactory : IDesignTimeDbContextFactory<AuthDbContext>
{
    public AuthDbContext CreateDbContext(string[] args)
    {
        var services = new ServiceCollection();
        services.AddIdentityCore<IdentityUser>(options =>
        {
            options.Stores.SchemaVersion = IdentitySchemaVersions.Version1;
            options.Stores.MaxLengthForKeys = 128;
        });
        var applicationServices = services.BuildServiceProvider();

        var connectionString = Environment.GetEnvironmentVariable("SGSCTR_DESIGNTIME_CONNECTION")
            ?? "Host=localhost;Port=5433;Database=sgsctr_design;Username=sgsctr;Password=design_time_only";

        var options = new DbContextOptionsBuilder<AuthDbContext>()
            .UseApplicationServiceProvider(applicationServices)
            .UseNpgsql(connectionString, npgsql =>
                npgsql.MigrationsHistoryTable("__EFMigrationsHistory", "identity"))
            .Options;

        return new AuthDbContext(options);
    }
}
