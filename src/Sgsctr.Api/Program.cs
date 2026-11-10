using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Authentication.BearerToken;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Sgsctr.Api.Data;

var builder = WebApplication.CreateBuilder(args);
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
if (string.IsNullOrWhiteSpace(connectionString))
    throw new InvalidOperationException("ConnectionStrings:DefaultConnection must be configured.");

builder.Services.AddDbContext<AppDbContext>(options => options.UseNpgsql(connectionString));
builder.Services.AddDbContext<AuthDbContext>(options => options.UseNpgsql(connectionString, npgsql => npgsql.MigrationsHistoryTable("__EFMigrationsHistory", "identity")));
builder.Services.AddIdentityApiEndpoints<IdentityUser>(options =>
{
    options.User.RequireUniqueEmail = true;
    options.SignIn.RequireConfirmedAccount = false;
    options.Password.RequiredLength = 12;
    options.Password.RequireDigit = true;
    options.Password.RequireLowercase = true;
    options.Password.RequireUppercase = true;
    options.Password.RequireNonAlphanumeric = true;
    options.Lockout.AllowedForNewUsers = true;
    options.Lockout.MaxFailedAccessAttempts = 5;
    options.Lockout.DefaultLockoutTimeSpan = TimeSpan.FromMinutes(15);
})
.AddRoles<IdentityRole>()
.AddEntityFrameworkStores<AuthDbContext>();
builder.Services.Configure<BearerTokenOptions>(IdentityConstants.BearerScheme, options =>
{
    options.BearerTokenExpiration = TimeSpan.FromMinutes(15);
    options.RefreshTokenExpiration = TimeSpan.FromDays(7);
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
    var user = new IdentityUser { UserName = email, Email = email, EmailConfirmed = true, LockoutEnabled = true };
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
            await roles.CreateAsync(new IdentityRole("Administrator"));
        if (await users.FindByEmailAsync(email.Trim()) is null)
        {
            var admin = new IdentityUser { UserName = email.Trim(), Email = email.Trim(), EmailConfirmed = true, LockoutEnabled = true };
            var result = await users.CreateAsync(admin, password);
            if (result.Succeeded) await users.AddToRoleAsync(admin, "Administrator");
            else throw new InvalidOperationException("Bootstrap administrator creation failed: " + string.Join("; ", result.Errors.Select(x => x.Code)));
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

public sealed record CreateUserInput(string Email, string Password);

