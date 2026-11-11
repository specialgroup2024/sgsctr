using Microsoft.AspNetCore.Identity;
using Sgsctr.Api.Data;

namespace Sgsctr.Api.Data;

/// <summary>
/// Single source of truth for Identity registration and model-shaping options.
/// Runtime and EF design-time services must use this exact registration so the
/// runtime model cannot drift from the checked-in migration snapshot.
/// </summary>
public static class IdentityRegistration
{
    public static IdentityBuilder AddSgsctrIdentity(this IServiceCollection services) =>
        services.AddIdentityApiEndpoints<IdentityUser>(ConfigureOptions)
            .AddRoles<IdentityRole>()
            .AddEntityFrameworkStores<AuthDbContext>();

    private static void ConfigureOptions(IdentityOptions options)
    {
        // Passkeys (Identity schema v3) remain a deliberate future migration.
        options.Stores.SchemaVersion = IdentitySchemaVersions.Version1;
        options.Stores.MaxLengthForKeys = 128;
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
    }
}
