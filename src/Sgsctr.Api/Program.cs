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
var internalIssuer = builder.Configuration["Authentication:InternalIssuer"];

if (string.IsNullOrWhiteSpace(authority) ||
    string.IsNullOrWhiteSpace(metadataAddress) ||
    string.IsNullOrWhiteSpace(audience) ||
    string.IsNullOrWhiteSpace(internalIssuer))
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
            ValidIssuers = new[] { authority.TrimEnd('/'), internalIssuer.TrimEnd('/') },
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

if (app.Environment.IsDevelopment() &&
    app.Configuration.GetValue<bool>("Database:ApplyMigrations"))
{
    await using var scope = app.Services.CreateAsyncScope();
    var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();
    await db.Database.MigrateAsync();
}

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
    subject = user.FindFirst("sub")?.Value,
    displayName = user.FindFirst("name")?.Value ?? user.FindFirst("preferred_username")?.Value,
    email = user.FindFirst("email")?.Value
})).RequireAuthorization();

app.MapGet("/api/v1/organization/access", (ClaimsPrincipal user, IConfiguration configuration) =>
    Results.Ok(new { canManage = IsOrganizationManager(user, configuration) }))
    .RequireAuthorization();

app.MapGet("/api/v1/organization", async (AppDbContext db, CancellationToken cancellationToken) =>
{
    var locations = await db.OrganizationLocations.AsNoTracking()
        .OrderBy(x => x.Code)
        .Select(x => new OrganizationLocationResponse(
            x.Id, x.Code, x.Name, x.SectorCode, x.LocationType, x.Notes,
            x.RecordStatus, x.IsActive, x.UpdatedAtUtc))
        .ToListAsync(cancellationToken);

    return Results.Ok(new
    {
        organizationName = "Special Group",
        legalIdentityStatus = "VerificationPending",
        sectors = new[]
        {
            new { code = "PHARMACIES", name = "Pharmacies", recordStatus = "OwnerProvided" },
            new { code = "SPECIALIZED_CONTRACTING", name = "Specialized Contracting", recordStatus = "OwnerProvided" }
        },
        locations
    });
}).RequireAuthorization();

app.MapPost("/api/v1/organization/locations", async (
    OrganizationLocationInput input,
    ClaimsPrincipal user,
    IConfiguration configuration,
    AppDbContext db,
    CancellationToken cancellationToken) =>
{
    if (!IsOrganizationManager(user, configuration))
        return Results.Forbid();

    var validation = ValidateLocation(input);
    if (validation is not null) return Results.ValidationProblem(validation);

    var entity = new OrganizationLocation
    {
        Id = Guid.NewGuid(),
        Code = input.Code.Trim().ToUpperInvariant(),
        Name = input.Name.Trim(),
        SectorCode = input.SectorCode,
        LocationType = input.LocationType,
        Notes = input.Notes?.Trim(),
        RecordStatus = "OwnerProvided",
        IsActive = true,
        CreatedAtUtc = DateTimeOffset.UtcNow,
        UpdatedAtUtc = DateTimeOffset.UtcNow
    };
    db.OrganizationLocations.Add(entity);
    try { await db.SaveChangesAsync(cancellationToken); }
    catch (DbUpdateException) { return Results.Conflict(new { error = "A location with this code already exists." }); }
    return Results.Created($"/api/v1/organization/locations/{entity.Id}", ToResponse(entity));
}).RequireAuthorization();

app.MapPut("/api/v1/organization/locations/{id:guid}", async (
    Guid id,
    OrganizationLocationInput input,
    ClaimsPrincipal user,
    IConfiguration configuration,
    AppDbContext db,
    CancellationToken cancellationToken) =>
{
    if (!IsOrganizationManager(user, configuration))
        return Results.Forbid();

    var validation = ValidateLocation(input);
    if (validation is not null) return Results.ValidationProblem(validation);

    var entity = await db.OrganizationLocations.SingleOrDefaultAsync(x => x.Id == id, cancellationToken);
    if (entity is null) return Results.NotFound();
    entity.Code = input.Code.Trim().ToUpperInvariant();
    entity.Name = input.Name.Trim();
    entity.SectorCode = input.SectorCode;
    entity.LocationType = input.LocationType;
    entity.Notes = input.Notes?.Trim();
    entity.UpdatedAtUtc = DateTimeOffset.UtcNow;
    try { await db.SaveChangesAsync(cancellationToken); }
    catch (DbUpdateException) { return Results.Conflict(new { error = "A location with this code already exists." }); }
    return Results.Ok(ToResponse(entity));
}).RequireAuthorization();

app.MapDelete("/api/v1/organization/locations/{id:guid}", async (
    Guid id,
    ClaimsPrincipal user,
    IConfiguration configuration,
    AppDbContext db,
    CancellationToken cancellationToken) =>
{
    if (!IsOrganizationManager(user, configuration))
        return Results.Forbid();
    var entity = await db.OrganizationLocations.SingleOrDefaultAsync(x => x.Id == id, cancellationToken);
    if (entity is null) return Results.NotFound();
    entity.IsActive = false;
    entity.UpdatedAtUtc = DateTimeOffset.UtcNow;
    await db.SaveChangesAsync(cancellationToken);
    return Results.NoContent();
}).RequireAuthorization();

app.Run();

static bool IsOrganizationManager(ClaimsPrincipal user, IConfiguration configuration)
{
    var subject = user.FindFirst("sub")?.Value;
    var allowed = (configuration["Organization:ManagerSubjects"] ?? string.Empty)
        .Split(',', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries);
    return !string.IsNullOrWhiteSpace(subject) && allowed.Contains(subject, StringComparer.Ordinal);
}

static Dictionary<string, string[]>? ValidateLocation(OrganizationLocationInput input)
{
    var errors = new Dictionary<string, string[]>();
    if (string.IsNullOrWhiteSpace(input.Code) || input.Code.Trim().Length > 24)
        errors["code"] = ["Code is required and must be at most 24 characters."];
    if (string.IsNullOrWhiteSpace(input.Name) || input.Name.Trim().Length > 160)
        errors["name"] = ["Name is required and must be at most 160 characters."];
    if (input.SectorCode is not ("PHARMACIES" or "SPECIALIZED_CONTRACTING"))
        errors["sectorCode"] = ["Select a registered sector."];
    if (input.LocationType is not ("MainWarehouse" or "Branch" or "Office" or "ProjectSite"))
        errors["locationType"] = ["Select a supported location type."];
    if (input.Notes?.Length > 500)
        errors["notes"] = ["Notes must be at most 500 characters."];
    return errors.Count == 0 ? null : errors;
}

static OrganizationLocationResponse ToResponse(OrganizationLocation x) =>
    new(x.Id, x.Code, x.Name, x.SectorCode, x.LocationType, x.Notes,
        x.RecordStatus, x.IsActive, x.UpdatedAtUtc);

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

public sealed record OrganizationLocationInput(
    string Code, string Name, string SectorCode, string LocationType, string? Notes);

public sealed record OrganizationLocationResponse(
    Guid Id, string Code, string Name, string SectorCode, string LocationType,
    string? Notes, string RecordStatus, bool IsActive, DateTimeOffset UpdatedAtUtc);
