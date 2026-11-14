using System.Security.Claims;
using System.Security.Cryptography.X509Certificates;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Authentication.BearerToken;
using Microsoft.AspNetCore.DataProtection;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Sgsctr.Api.Data;
using Sgsctr.Api.RegulatoryIntelligence;
using Sgsctr.Api.PharmacyCatalogue;

var builder = WebApplication.CreateBuilder(args);
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
if (string.IsNullOrWhiteSpace(connectionString))
    throw new InvalidOperationException("ConnectionStrings:DefaultConnection must be configured.");

// Persist the Data Protection key ring outside the container writable layer.
var dataProtectionKeysPath = builder.Configuration["DataProtection:KeysDirectory"]
    ?? "/var/lib/sgsctr/data-protection-keys";
Directory.CreateDirectory(dataProtectionKeysPath);
var dataProtection = builder.Services.AddDataProtection()
    .SetApplicationName("SGSCTR")
    .PersistKeysToFileSystem(new DirectoryInfo(dataProtectionKeysPath));

var dataProtectionCertificatePath = builder.Configuration["DataProtection:CertificatePath"];
if (!string.IsNullOrWhiteSpace(dataProtectionCertificatePath))
{
    if (!File.Exists(dataProtectionCertificatePath))
        throw new InvalidOperationException("The configured Data Protection certificate file does not exist.");
    var certificate = X509CertificateLoader.LoadPkcs12FromFile(
        dataProtectionCertificatePath,
        builder.Configuration["DataProtection:CertificatePassword"]);
    dataProtection.ProtectKeysWithCertificate(certificate);
}
else if (!builder.Environment.IsDevelopment())
{
    throw new InvalidOperationException(
        "Production requires DataProtection:CertificatePath and a certificate password supplied through a secret.");
}

builder.Services.AddDbContext<AppDbContext>(options => options.UseNpgsql(connectionString));
builder.Services.AddSgsctrIdentity();
builder.Services.AddRegulatoryIntelligence();

// IdentityDbContext reads model-shaping IdentityOptions from the application service provider.
// Supplying that provider explicitly keeps runtime model construction aligned with migrations.
builder.Services.AddDbContext<AuthDbContext>((serviceProvider, options) =>
    options.UseNpgsql(connectionString, npgsql => npgsql.MigrationsHistoryTable("__EFMigrationsHistory", "identity"))
        .UseApplicationServiceProvider(serviceProvider));
builder.Services.Configure<BearerTokenOptions>(IdentityConstants.BearerScheme, options =>
{
    options.BearerTokenExpiration = TimeSpan.FromMinutes(15);
    options.RefreshTokenExpiration = TimeSpan.FromDays(7);
});

var authenticationEnabled = builder.Configuration.GetValue<bool>("Authentication:Enabled", true);
if (!authenticationEnabled && !builder.Environment.IsDevelopment())
    throw new InvalidOperationException("Authentication may only be disabled in the Development environment.");

builder.Services.AddAuthorization(options =>
{
    var accessPolicy = new AuthorizationPolicyBuilder()
        .RequireAssertion(context =>
            !authenticationEnabled || context.User.Identity?.IsAuthenticated == true)
        .Build();
    options.DefaultPolicy = accessPolicy;
    options.FallbackPolicy = accessPolicy;
});

var app = builder.Build();

// PostgreSQL is a mandatory runtime dependency, not an optional dashboard integration.
// Do not start serving the application until both application and Identity contexts can connect.
var databaseConnected = false;
for (var attempt = 1; attempt <= 30; attempt++)
{
    try
    {
        await using var startupScope = app.Services.CreateAsyncScope();
        var appDb = startupScope.ServiceProvider.GetRequiredService<AppDbContext>();
        var authDb = startupScope.ServiceProvider.GetRequiredService<AuthDbContext>();
        databaseConnected = await appDb.Database.CanConnectAsync() &&
                            await authDb.Database.CanConnectAsync();
        if (databaseConnected) break;
    }
    catch (Exception exception)
    {
        app.Logger.LogWarning(exception, "PostgreSQL startup connection attempt {Attempt}/30 failed.", attempt);
    }

    if (attempt < 30) await Task.Delay(TimeSpan.FromSeconds(2));
}

if (!databaseConnected)
    throw new InvalidOperationException("PostgreSQL is a required dependency. The API will not start until the database is reachable.");

app.Logger.LogInformation("PostgreSQL connectivity verified for application and Identity contexts.");

if (app.Environment.IsDevelopment() &&
    app.Configuration.GetValue<bool>("Database:ApplyMigrations"))
{
    await using var scope = app.Services.CreateAsyncScope();
    var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();
    await db.Database.MigrateAsync();
    var authDb = scope.ServiceProvider.GetRequiredService<AuthDbContext>();
    await authDb.Database.ExecuteSqlRawAsync("CREATE SCHEMA IF NOT EXISTS identity;");
    await authDb.Database.MigrateAsync();
}

// Public self-registration and unauthenticated password recovery are intentionally disabled.
app.Use(async (context, next) =>
{
    var path = context.Request.Path.Value?.TrimEnd('/');
    if (HttpMethods.IsPost(context.Request.Method) &&
        (string.Equals(path, "/api/v1/auth/register", StringComparison.OrdinalIgnoreCase) ||
         string.Equals(path, "/api/v1/auth/forgotPassword", StringComparison.OrdinalIgnoreCase) ||
         string.Equals(path, "/api/v1/auth/resetPassword", StringComparison.OrdinalIgnoreCase) ||
         string.Equals(path, "/api/v1/auth/resendConfirmationEmail", StringComparison.OrdinalIgnoreCase)))
    {
        context.Response.StatusCode = StatusCodes.Status404NotFound;
        return;
    }
    await next();
});

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

app.MapRegulatoryIntelligenceEndpoints();
app.MapPharmacyCatalogueEndpoints();
app.MapPharmacyProductGovernanceEndpoints();

var authRoutes = app.MapGroup("/api/v1/auth");
authRoutes.MapIdentityApi<IdentityUser>();
authRoutes.MapGet("/me", (ClaimsPrincipal user) => Results.Ok(new
{
    authenticated = user.Identity?.IsAuthenticated ?? false,
    subject = user.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? user.FindFirst("sub")?.Value,
    displayName = user.Identity?.Name ?? user.FindFirst(ClaimTypes.Name)?.Value,
    email = user.FindFirst(ClaimTypes.Email)?.Value
})).RequireAuthorization();

app.MapPost("/api/v1/admin/users", async (CreateUserInput input, UserManager<IdentityUser> users, CancellationToken cancellationToken) =>
{
    if (string.IsNullOrWhiteSpace(input.Email) || string.IsNullOrWhiteSpace(input.Password))
        return Results.ValidationProblem(new Dictionary<string, string[]> { ["email"] = ["Email and password are required."] });
    var email = input.Email.Trim();
    var user = new IdentityUser { UserName = email, Email = email, EmailConfirmed = false, LockoutEnabled = true };
    var created = await users.CreateAsync(user, input.Password);
    if (!created.Succeeded)
        return Results.ValidationProblem(created.Errors.GroupBy(x => x.Code).ToDictionary(x => x.Key, x => x.Select(e => e.Description).ToArray()));
    return Results.Created($"/api/v1/admin/users/{user.Id}", new { id = user.Id, email = user.Email, status = "Active" });
}).RequireAuthorization(policy => policy.RequireRole("Administrator"));

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

// Optional one-time bootstrap administrator. Existing accounts are never reset or promoted automatically.
await using (var scope = app.Services.CreateAsyncScope())
{
    var configuration = scope.ServiceProvider.GetRequiredService<IConfiguration>();
    var email = configuration["BootstrapAdmin:Email"];
    var password = configuration["BootstrapAdmin:Password"];
    if (!string.IsNullOrWhiteSpace(email) && !string.IsNullOrWhiteSpace(password))
    {
        var users = scope.ServiceProvider.GetRequiredService<UserManager<IdentityUser>>();
        var roles = scope.ServiceProvider.GetRequiredService<RoleManager<IdentityRole>>();
        if (!await roles.RoleExistsAsync("Administrator"))
        {
            var roleResult = await roles.CreateAsync(new IdentityRole("Administrator"));
            if (!roleResult.Succeeded)
                throw new InvalidOperationException("Bootstrap administrator role creation failed: " + string.Join("; ", roleResult.Errors.Select(x => x.Code)));
        }

        var admin = await users.FindByEmailAsync(email.Trim());
        if (admin is null)
        {
            admin = new IdentityUser { UserName = email.Trim(), Email = email.Trim(), EmailConfirmed = true, LockoutEnabled = true };
            var createResult = await users.CreateAsync(admin, password);
            if (!createResult.Succeeded)
                throw new InvalidOperationException("Bootstrap administrator creation failed: " + string.Join("; ", createResult.Errors.Select(x => x.Code)));
        }

        // Existing accounts are never password-reset here, but the configured bootstrap
        // account is always ensured to have the Administrator role.
        if (!await users.IsInRoleAsync(admin, "Administrator"))
        {
            var roleAssignment = await users.AddToRoleAsync(admin, "Administrator");
            if (!roleAssignment.Succeeded)
                throw new InvalidOperationException("Bootstrap administrator role assignment failed: " + string.Join("; ", roleAssignment.Errors.Select(x => x.Code)));
        }
    }
}

app.Run();

static bool IsOrganizationManager(ClaimsPrincipal user, IConfiguration configuration)
{
    var subject = user.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? user.FindFirst("sub")?.Value;
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
        var authDb = scope.ServiceProvider.GetRequiredService<AuthDbContext>();

        // PostgreSQL is shared by business data and native Identity. Readiness is true
        // only when both application data access paths can reach the required database.
        var appDatabaseReachable = await db.Database.CanConnectAsync(cancellationToken);
        var identityDatabaseReachable = await authDb.Database.CanConnectAsync(cancellationToken);
        if (appDatabaseReachable && identityDatabaseReachable)
        {
            return Results.Ok(new
            {
                status = "ok",
                database = "connected",
                applicationContext = "connected",
                identityContext = "connected"
            });
        }
    }
    catch (Exception exception)
    {
        logger.LogWarning(exception, "Database readiness check failed.");
    }

    return Results.Json(
        new
        {
            status = "not_ready",
            database = "unreachable",
            applicationContext = "unreachable",
            identityContext = "unreachable"
        },
        statusCode: StatusCodes.Status503ServiceUnavailable);
}

public sealed record OrganizationLocationInput(
    string Code, string Name, string SectorCode, string LocationType, string? Notes);

public sealed record OrganizationLocationResponse(
    Guid Id, string Code, string Name, string SectorCode, string LocationType,
    string? Notes, string RecordStatus, bool IsActive, DateTimeOffset UpdatedAtUtc);

public sealed record CreateUserInput(string Email, string Password);

