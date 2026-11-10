using System.Security.Claims;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Sgsctr.Api.Data;

var builder = WebApplication.CreateBuilder(args);
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");

if (!string.IsNullOrWhiteSpace(connectionString))
{
    builder.Services.AddDbContext<AppDbContext>(options => options.UseNpgsql(connectionString));
}

var authority = builder.Configuration["Authentication:Authority"];
var metadataAddress = builder.Configuration["Authentication:MetadataAddress"];
var audience = builder.Configuration["Authentication:Audience"];

if (string.IsNullOrWhiteSpace(authority) ||
    string.IsNullOrWhiteSpace(metadataAddress) ||
    string.IsNullOrWhiteSpace(audience))
{
    throw new InvalidOperationException(
        "Authentication:Authority, Authentication:MetadataAddress and Authentication:Audience must be configured.");
}

var requireHttpsMetadata = builder.Configuration.GetValue(
    "Authentication:RequireHttpsMetadata",
    !builder.Environment.IsDevelopment());

builder.Services
    .AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.Authority = authority;
        options.MetadataAddress = metadataAddress;
        options.Audience = audience;
        options.RequireHttpsMetadata = requireHttpsMetadata;
        options.MapInboundClaims = false;
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidIssuer = authority.TrimEnd('/'),
            ValidateAudience = true,
            ValidAudience = audience,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ClockSkew = TimeSpan.FromMinutes(1)
        };
    });

builder.Services.AddAuthorization(options =>
{
    options.FallbackPolicy = new AuthorizationPolicyBuilder()
        .RequireAuthenticatedUser()
        .Build();
});

var app = builder.Build();

app.UseAuthentication();
app.UseAuthorization();

app.MapGet("/", () => Results.Ok(new
{
    service = "SGSCTR API",
    status = "running",
    apiVersion = "v1"
})).AllowAnonymous();

app.MapGet("/health/live", () => Results.Ok(new
{
    status = "ok",
    check = "live"
})).AllowAnonymous();

app.MapGet("/health/ready", CheckReadiness).AllowAnonymous();

app.MapGet("/api/v1/system/info", () => Results.Ok(new
{
    application = "SGSCTR",
    apiVersion = "v1",
    environment = app.Environment.EnvironmentName,
    businessModulesEnabled = false
})).AllowAnonymous();

app.MapGet("/api/v1/auth/me", (ClaimsPrincipal user) => Results.Ok(new
{
    authenticated = user.Identity?.IsAuthenticated ?? false,
    subject = user.FindFirst("sub")?.Value
})).RequireAuthorization();

app.Run();

static async Task<IResult> CheckReadiness(
    IServiceProvider services,
    IConfiguration configuration,
    ILogger<Program> logger,
    CancellationToken cancellationToken)
{
    if (string.IsNullOrWhiteSpace(configuration.GetConnectionString("DefaultConnection")))
    {
        return Results.Json(
            new { status = "not_ready", database = "connection_not_configured" },
            statusCode: StatusCodes.Status503ServiceUnavailable);
    }

    try
    {
        await using var scope = services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();
        if (await db.Database.CanConnectAsync(cancellationToken))
        {
            return Results.Ok(new { status = "ok", database = "reachable" });
        }
    }
    catch (Exception exception)
    {
        logger.LogWarning(exception, "Database readiness check failed.");
    }

    return Results.Json(
        new { status = "not_ready", database = "unreachable" },
        statusCode: StatusCodes.Status503ServiceUnavailable);
}
