using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;
using Microsoft.Extensions.DependencyInjection;

namespace Sgsctr.Api.Data;

/// <summary>
/// Builds the Identity model using the exact same Identity registration and
/// model-shaping options as the running API. This factory never connects to or
/// mutates a production database.
/// </summary>
public sealed class AuthDbContextFactory : IDesignTimeDbContextFactory<AuthDbContext>
{
    public AuthDbContext CreateDbContext(string[] args)
    {
        var services = new ServiceCollection();
        services.AddSgsctrIdentity();
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
