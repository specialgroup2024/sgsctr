using Microsoft.EntityFrameworkCore;
using Sgsctr.Api.Data;

var builder = WebApplication.CreateBuilder(args);
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
if (!string.IsNullOrWhiteSpace(connectionString))
{
    builder.Services.AddDbContext<AppDbContext>(options => options.UseNpgsql(connectionString));
}

var app = builder.Build();
app.MapGet("/", () => Results.Ok(new { service = "SGSCTR API", status = "running", apiVersion = "v1" }));
app.MapGet("/health/live", () => Results.Ok(new { status = "ok", check = "live" }));
app.MapGet("/health/ready", async (IServiceProvider services, ILogger<Program> logger, CancellationToken cancellationToken) =>
{
    if (string.IsNullOrWhiteSpace(connectionString))
        return Results.Json(new { status = "not_ready", database = "connection_not_configured" }, statusCode: 503);

    try
    {
        await using var scope = services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();
        return await db.Database.CanConnectAsync(cancellationToken)
            ? Results.Ok(new { status = "ok", database = "reachable" })
            : Results.Json(new { status = "not_ready", database = "unreachable" }, statusCode: 503);
    }
    catch (Exception exception)
    {
        logger.LogWarning(exception, "Database readiness check failed.");
        return Results.Json(new { status = "not_ready", database = "unreachable" }, statusCode: 503);
    }
});
app.MapGet("/api/v1/system/info", () => Results.Ok(new
{
    application = "SGSCTR",
    apiVersion = "v1",
    environment = app.Environment.EnvironmentName,
    businessModulesEnabled = false
}));
app.Run();
