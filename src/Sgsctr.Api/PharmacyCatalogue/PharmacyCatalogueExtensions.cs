using System.Security.Claims;
using Microsoft.EntityFrameworkCore;
using Sgsctr.Api.Data;

namespace Sgsctr.Api.PharmacyCatalogue;

public static class PharmacyCatalogueExtensions
{
    public static WebApplication MapPharmacyCatalogueEndpoints(this WebApplication app)
    {
        var api = app.MapGroup("/api/v1/pharmacy/catalogue").RequireAuthorization();

        api.MapGet("/permissions", (ClaimsPrincipal user) =>
            Results.Ok(new { canManage = user.IsInRole("Administrator") }));

        api.MapGet("/products/{id:guid}", async (Guid id, AppDbContext db, CancellationToken ct) =>
        {
            var product = await db.CatalogueProducts.AsNoTracking().SingleOrDefaultAsync(x => x.Id == id, ct);
            return product is null ? Results.NotFound() : Results.Ok(ToResponse(product));
        });

        api.MapGet("/units/{id:guid}", async (Guid id, AppDbContext db, CancellationToken ct) =>
        {
            var unit = await db.UnitsOfMeasure.AsNoTracking().SingleOrDefaultAsync(x => x.Id == id, ct);
            return unit is null ? Results.NotFound() : Results.Ok(new UnitResponse(unit.Id, unit.Code, unit.Name, unit.Symbol));
        });

        api.MapGet("/products", async (string? q, AppDbContext db, CancellationToken ct) =>
        {
            var query = db.CatalogueProducts.AsNoTracking();
            if (!string.IsNullOrWhiteSpace(q))
            {
                var term = q.Trim();
                if (term.Length > 100) return Results.BadRequest(new { error = "Search text must be 100 characters or fewer." });
                query = query.Where(x => EF.Functions.ILike(x.DisplayName, $"%{term}%"));
            }

            var products = await query.OrderBy(x => x.DisplayName).Take(100)
                .Select(x => new ProductResponse(x.Id, x.DisplayName, x.Description, x.Status, x.Version, x.CreatedAtUtc, x.UpdatedAtUtc))
                .ToListAsync(ct);
            return Results.Ok(products);
        });

        api.MapPost("/products", async (
            ProductInput input, ClaimsPrincipal user, AppDbContext db, HttpContext http, CancellationToken ct) =>
        {
            var error = ValidateProduct(input);
            if (error is not null) return Results.ValidationProblem(error);
            var actor = Actor(user);
            var now = DateTimeOffset.UtcNow;
            var product = new CatalogueProduct
            {
                Id = Guid.NewGuid(),
                DisplayName = input.DisplayName.Trim(),
                Description = string.IsNullOrWhiteSpace(input.Description) ? null : input.Description.Trim(),
                Status = "Draft",
                Version = 1,
                CreatedAtUtc = now,
                UpdatedAtUtc = now,
                CreatedBySubject = actor,
                UpdatedBySubject = actor
            };
            db.CatalogueProducts.Add(product);
            AddAudit(db, actor, "ProductCreated", "CatalogueProduct", product.Id, input.ChangeReason, http.TraceIdentifier, now);
            await db.SaveChangesAsync(ct);
            return Results.Created($"/api/v1/pharmacy/catalogue/products/{product.Id}", ToResponse(product));
        }).RequireAuthorization(policy => policy.RequireRole("Administrator"));

        api.MapPut("/products/{id:guid}", async (
            Guid id, ProductUpdateInput input, ClaimsPrincipal user, AppDbContext db, HttpContext http, CancellationToken ct) =>
        {
            var error = ValidateProduct(new ProductInput(input.DisplayName, input.Description, input.ChangeReason));
            if (error is not null) return Results.ValidationProblem(error);
            var product = await db.CatalogueProducts.SingleOrDefaultAsync(x => x.Id == id, ct);
            if (product is null) return Results.NotFound();
            if (product.Status != "Draft") return Results.Conflict(new { error = "Only draft catalogue records can be edited." });
            if (input.Version != product.Version) return Results.Conflict(new { error = "The catalogue record changed. Reload it before editing." });

            var actor = Actor(user);
            var now = DateTimeOffset.UtcNow;
            product.DisplayName = input.DisplayName.Trim();
            product.Description = string.IsNullOrWhiteSpace(input.Description) ? null : input.Description.Trim();
            product.UpdatedAtUtc = now;
            product.UpdatedBySubject = actor;
            product.Version++;
            AddAudit(db, actor, "ProductUpdated", "CatalogueProduct", product.Id, input.ChangeReason, http.TraceIdentifier, now);
            try { await db.SaveChangesAsync(ct); }
            catch (DbUpdateConcurrencyException) { return Results.Conflict(new { error = "The catalogue record changed. Reload it before editing." }); }
            return Results.Ok(ToResponse(product));
        }).RequireAuthorization(policy => policy.RequireRole("Administrator"));

        api.MapGet("/units", async (AppDbContext db, CancellationToken ct) =>
            Results.Ok(await db.UnitsOfMeasure.AsNoTracking().OrderBy(x => x.Code)
                .Select(x => new UnitResponse(x.Id, x.Code, x.Name, x.Symbol)).ToListAsync(ct)));

        api.MapPost("/units", async (
            UnitInput input, ClaimsPrincipal user, AppDbContext db, HttpContext http, CancellationToken ct) =>
        {
            if (string.IsNullOrWhiteSpace(input.Code) || input.Code.Trim().Length > 24 ||
                string.IsNullOrWhiteSpace(input.Name) || input.Name.Trim().Length > 100 ||
                input.Symbol?.Length > 24)
                return Results.ValidationProblem(new Dictionary<string, string[]> { ["unit"] = ["Provide a unit code (max 24), name (max 100), and optional symbol (max 24)."] });

            var actor = Actor(user);
            var now = DateTimeOffset.UtcNow;
            var unit = new UnitOfMeasure
            {
                Id = Guid.NewGuid(),
                Code = CatalogueRules.NormalizeUnitCode(input.Code),
                Name = input.Name.Trim(),
                Symbol = string.IsNullOrWhiteSpace(input.Symbol) ? null : input.Symbol.Trim(),
                CreatedAtUtc = now,
                CreatedBySubject = actor
            };
            db.UnitsOfMeasure.Add(unit);
            AddAudit(db, actor, "UnitCreated", "UnitOfMeasure", unit.Id, input.ChangeReason, http.TraceIdentifier, now);
            try { await db.SaveChangesAsync(ct); }
            catch (DbUpdateException) { return Results.Conflict(new { error = "A unit with this code already exists." }); }
            return Results.Created($"/api/v1/pharmacy/catalogue/units/{unit.Id}", new UnitResponse(unit.Id, unit.Code, unit.Name, unit.Symbol));
        }).RequireAuthorization(policy => policy.RequireRole("Administrator"));

        api.MapGet("/products/{id:guid}/conversions", async (Guid id, AppDbContext db, CancellationToken ct) =>
        {
            if (!await db.CatalogueProducts.AnyAsync(x => x.Id == id, ct)) return Results.NotFound();
            var rows = await db.ProductUnitConversions.AsNoTracking().Where(x => x.ProductId == id)
                .OrderBy(x => x.CreatedAtUtc)
                .Select(x => new ConversionResponse(x.Id, x.ProductId, x.FromUnitId, x.FromUnit.Name,
                    x.ToUnitId, x.ToUnit.Name, x.Numerator, x.Denominator, x.Status))
                .ToListAsync(ct);
            return Results.Ok(rows);
        });

        api.MapPost("/products/{id:guid}/conversions", async (
            Guid id, ConversionInput input, ClaimsPrincipal user, AppDbContext db, HttpContext http, CancellationToken ct) =>
        {
            if (!CatalogueRules.TryNormalizeRatio(input.Numerator, input.Denominator, out var numerator, out var denominator))
                return Results.ValidationProblem(new Dictionary<string, string[]> { ["ratio"] = ["Numerator and denominator must both be positive whole numbers."] });
            if (input.FromUnitId == input.ToUnitId)
                return Results.ValidationProblem(new Dictionary<string, string[]> { ["units"] = ["Choose two different units."] });

            var product = await db.CatalogueProducts.SingleOrDefaultAsync(x => x.Id == id, ct);
            if (product is null) return Results.NotFound();
            if (product.Status != "Draft") return Results.Conflict(new { error = "Only draft catalogue records can receive draft conversions." });
            var unitsExist = await db.UnitsOfMeasure.CountAsync(x => x.Id == input.FromUnitId || x.Id == input.ToUnitId, ct);
            if (unitsExist != 2) return Results.ValidationProblem(new Dictionary<string, string[]> { ["units"] = ["Both selected units must exist."] });

            var actor = Actor(user);
            var now = DateTimeOffset.UtcNow;
            var conversion = new ProductUnitConversion
            {
                Id = Guid.NewGuid(), ProductId = id, FromUnitId = input.FromUnitId, ToUnitId = input.ToUnitId,
                Numerator = numerator, Denominator = denominator, Status = "Draft",
                CreatedAtUtc = now, CreatedBySubject = actor
            };
            db.ProductUnitConversions.Add(conversion);
            AddAudit(db, actor, "ProductUnitConversionCreated", "ProductUnitConversion", conversion.Id,
                input.ChangeReason, http.TraceIdentifier, now);
            try { await db.SaveChangesAsync(ct); }
            catch (DbUpdateException) { return Results.Conflict(new { error = "This product already has a conversion for the selected unit pair." }); }
            return Results.Ok(new ConversionResponse(conversion.Id, id, input.FromUnitId, "", input.ToUnitId, "", numerator, denominator, "Draft"));
        }).RequireAuthorization(policy => policy.RequireRole("Administrator"));

        return app;
    }

    private static Dictionary<string, string[]>? ValidateProduct(ProductInput input)
    {
        var errors = new Dictionary<string, string[]>();
        if (string.IsNullOrWhiteSpace(input.DisplayName) || input.DisplayName.Trim().Length > 200)
            errors["displayName"] = ["A display name is required and must be at most 200 characters."];
        if (input.Description?.Length > 1000)
            errors["description"] = ["Description must be 1,000 characters or fewer."];
        if (input.ChangeReason?.Length > 500)
            errors["changeReason"] = ["Change reason must be 500 characters or fewer."];
        return errors.Count == 0 ? null : errors;
    }

    private static string Actor(ClaimsPrincipal user) =>
        user.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? user.FindFirst("sub")?.Value ?? "unknown-subject";

    private static void AddAudit(AppDbContext db, string actor, string action, string resourceType,
        Guid resourceId, string? reason, string correlationId, DateTimeOffset now) =>
        db.CatalogueAuditEvents.Add(new CatalogueAuditEvent
        {
            Id = Guid.NewGuid(), ActorSubject = actor, Action = action, ResourceType = resourceType,
            ResourceId = resourceId, OccurredAtUtc = now, Outcome = "Succeeded",
            Reason = string.IsNullOrWhiteSpace(reason) ? null : reason.Trim(), CorrelationId = correlationId
        });

    private static ProductResponse ToResponse(CatalogueProduct x) =>
        new(x.Id, x.DisplayName, x.Description, x.Status, x.Version, x.CreatedAtUtc, x.UpdatedAtUtc);

    public sealed record ProductInput(string DisplayName, string? Description, string? ChangeReason);
    public sealed record ProductUpdateInput(string DisplayName, string? Description, int Version, string? ChangeReason);
    public sealed record UnitInput(string Code, string Name, string? Symbol, string? ChangeReason);
    public sealed record ConversionInput(Guid FromUnitId, Guid ToUnitId, long Numerator, long Denominator, string? ChangeReason);
    public sealed record ProductResponse(Guid Id, string DisplayName, string? Description, string Status, int Version, DateTimeOffset CreatedAtUtc, DateTimeOffset UpdatedAtUtc);
    public sealed record UnitResponse(Guid Id, string Code, string Name, string? Symbol);
    public sealed record ConversionResponse(Guid Id, Guid ProductId, Guid FromUnitId, string FromUnitName, Guid ToUnitId, string ToUnitName, long Numerator, long Denominator, string Status);
}
