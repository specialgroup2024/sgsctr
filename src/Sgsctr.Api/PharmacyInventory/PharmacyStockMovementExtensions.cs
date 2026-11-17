using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.EntityFrameworkCore;
using Sgsctr.Api.Data;

namespace Sgsctr.Api.PharmacyInventory;

public static class PharmacyStockMovementExtensions
{
    public static WebApplication MapPharmacyStockMovementEndpoints(this WebApplication app)
    {
        var api = app.MapGroup("/api/v1/pharmacy/inventory/stock-movements").RequireAuthorization();
        var authenticationEnabled = app.Configuration.GetValue<bool>("Authentication:Enabled", true);
        var localWrites = app.Environment.IsDevelopment() && !authenticationEnabled;
        var manager = new AuthorizationPolicyBuilder()
            .RequireAssertion(context => localWrites || context.User.IsInRole("Administrator"))
            .Build();

        api.MapGet("/", async (
            string? locationId,
            string? productId,
            string? status,
            DateTimeOffset? from,
            DateTimeOffset? to,
            int page,
            int pageSize,
            AppDbContext db,
            CancellationToken ct) =>
        {
            if (page < 1) page = 1;
            if (pageSize < 1 || pageSize > 200) pageSize = 50;

            var query = db.StockMovements.AsNoTracking();

            if (!string.IsNullOrWhiteSpace(locationId) && Guid.TryParse(locationId.Trim(), out var locId))
                query = query.Where(x => x.LocationId == locId);
            if (!string.IsNullOrWhiteSpace(productId) && Guid.TryParse(productId.Trim(), out var prodId))
                query = query.Where(x => x.ProductId == prodId);
            if (!string.IsNullOrWhiteSpace(status) && StockMovementRules.IsValidStatus(status.Trim()))
                query = query.Where(x => x.Status == status.Trim());
            if (from is not null) query = query.Where(x => x.CreatedAtUtc >= from.Value);
            if (to is not null) query = query.Where(x => x.CreatedAtUtc <= to.Value);

            var total = await query.LongCountAsync(ct);
            var items = await query
                .OrderByDescending(x => x.CreatedAtUtc)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .Select(x => new MovementResponse(
                    x.Id, x.LocationId, x.Location.Code, x.Location.Name,
                    x.ProductId, x.Product.DisplayName,
                    x.UnitId, x.Unit.Code,
                    x.Quantity, x.MovementType, x.LotNumber, x.ExpiryDate,
                    x.Reference, x.Reason, x.Status, x.ReversalOfId,
                    x.CreatedBySubject, x.CreatedAtUtc))
                .ToListAsync(ct);

            return Results.Ok(new { total, page, pageSize, items });
        });

        api.MapGet("/{id:guid}", async (Guid id, AppDbContext db, CancellationToken ct) =>
        {
            var movement = await db.StockMovements.AsNoTracking()
                .Where(x => x.Id == id)
                .Select(x => new MovementResponse(
                    x.Id, x.LocationId, x.Location.Code, x.Location.Name,
                    x.ProductId, x.Product.DisplayName,
                    x.UnitId, x.Unit.Code,
                    x.Quantity, x.MovementType, x.LotNumber, x.ExpiryDate,
                    x.Reference, x.Reason, x.Status, x.ReversalOfId,
                    x.CreatedBySubject, x.CreatedAtUtc))
                .SingleOrDefaultAsync(ct);
            return movement is null ? Results.NotFound() : Results.Ok(movement);
        });

        api.MapPost("/", async (
            MovementInput input, ClaimsPrincipal user, AppDbContext db, HttpContext http, CancellationToken ct) =>
        {
            if (!StockMovementRules.IsKnownMovementType(input.MovementType))
                return Results.ValidationProblem(new Dictionary<string, string[]>
                {
                    ["movementType"] = ["Movement type must be Receipt, Issue, Adjustment, Count, TransferIn, TransferOut, or Return."]
                });
            if (!StockMovementRules.IsValidQuantity(input.Quantity))
                return Results.ValidationProblem(new Dictionary<string, string[]>
                {
                    ["quantity"] = ["Quantity must be non-zero and within the supported range."]
                });
            if (!StockMovementRules.IsValidLotNumber(input.LotNumber))
                return Results.ValidationProblem(new Dictionary<string, string[]>
                {
                    ["lotNumber"] = ["Lot number must be 64 characters or fewer."]
                });
            if (!StockMovementRules.IsValidReason(input.ChangeReason))
                return Results.ValidationProblem(new Dictionary<string, string[]>
                {
                    ["reason"] = ["Reason is required and must be 500 characters or fewer."]
                });
            if (!StockMovementRules.IsValidReference(input.Reference))
                return Results.ValidationProblem(new Dictionary<string, string[]>
                {
                    ["reference"] = ["Reference must be 200 characters or fewer."]
                });

            var location = await db.OrganizationLocations.SingleOrDefaultAsync(x =>
                x.Id == input.LocationId && x.IsActive && x.SectorCode == "PHARMACIES", ct);
            if (location is null) return Results.ValidationProblem(new Dictionary<string, string[]>
            {
                ["locationId"] = ["Choose an active location registered to the Pharmacies sector."]
            });

            if (await db.CatalogueProducts.CountAsync(x => x.Id == input.ProductId, ct) != 1)
                return Results.ValidationProblem(new Dictionary<string, string[]>
                {
                    ["productId"] = ["Product must reference an existing catalogue product."]
                });
            if (await db.UnitsOfMeasure.CountAsync(x => x.Id == input.UnitId, ct) != 1)
                return Results.ValidationProblem(new Dictionary<string, string[]>
                {
                    ["unitId"] = ["Unit must reference an existing unit of measure."]
                });

            var actor = user.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? user.FindFirst("sub")?.Value ?? "local-development";
            var now = DateTimeOffset.UtcNow;

            var movement = new StockMovement
            {
                Id = Guid.NewGuid(),
                LocationId = location.Id,
                ProductId = input.ProductId,
                UnitId = input.UnitId,
                Quantity = input.Quantity,
                MovementType = input.MovementType.Trim(),
                LotNumber = string.IsNullOrWhiteSpace(input.LotNumber) ? null : input.LotNumber.Trim(),
                ExpiryDate = input.ExpiryDate,
                Reference = string.IsNullOrWhiteSpace(input.Reference) ? null : input.Reference.Trim(),
                Reason = input.ChangeReason.Trim(),
                Status = "Draft",
                ReversalOfId = input.ReversalOfId,
                CreatedBySubject = actor,
                CreatedAtUtc = now
            };

            db.StockMovements.Add(movement);
            db.CatalogueAuditEvents.Add(new CatalogueAuditEvent
            {
                Id = Guid.NewGuid(),
                ActorSubject = actor,
                Action = "StockMovementCreated",
                ResourceType = "StockMovement",
                ResourceId = movement.Id,
                OccurredAtUtc = now,
                Outcome = "Succeeded",
                Reason = movement.Reason,
                CorrelationId = http.TraceIdentifier
            });

            await db.SaveChangesAsync(ct);
            return Results.Created($"/api/v1/pharmacy/inventory/stock-movements/{movement.Id}",
                new
                {
                    id = movement.Id,
                    status = movement.Status,
                    locationId = movement.LocationId,
                    productId = movement.ProductId,
                    quantity = movement.Quantity,
                    stockPosted = false,
                    message = "Draft movement created. No stock balance was affected."
                });
        }).RequireAuthorization(manager);

        api.MapPost("/{id:guid}/reverse", async (
            Guid id, ReverseInput input, ClaimsPrincipal user, AppDbContext db, HttpContext http, CancellationToken ct) =>
        {
            if (!StockMovementRules.IsValidReason(input.ChangeReason))
                return Results.ValidationProblem(new Dictionary<string, string[]>
                {
                    ["reason"] = ["Reason is required and must be 500 characters or fewer."]
                });

            var original = await db.StockMovements.SingleOrDefaultAsync(x => x.Id == id, ct);
            if (original is null) return Results.NotFound();
            if (!StockMovementRules.CanReverse(original.Status))
                return Results.ValidationProblem(new Dictionary<string, string[]>
                {
                    ["status"] = ["Only Posted movements can be reversed."]
                });

            var actor = user.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? user.FindFirst("sub")?.Value ?? "local-development";
            var now = DateTimeOffset.UtcNow;

            var reversal = new StockMovement
            {
                Id = Guid.NewGuid(),
                LocationId = original.LocationId,
                ProductId = original.ProductId,
                UnitId = original.UnitId,
                Quantity = -original.Quantity,
                MovementType = original.MovementType,
                LotNumber = original.LotNumber,
                ExpiryDate = original.ExpiryDate,
                Reference = original.Reference,
                Reason = input.ChangeReason.Trim(),
                Status = "Draft",
                ReversalOfId = original.Id,
                CreatedBySubject = actor,
                CreatedAtUtc = now
            };

            db.StockMovements.Add(reversal);
            db.CatalogueAuditEvents.Add(new CatalogueAuditEvent
            {
                Id = Guid.NewGuid(),
                ActorSubject = actor,
                Action = "StockMovementReversed",
                ResourceType = "StockMovement",
                ResourceId = reversal.Id,
                OccurredAtUtc = now,
                Outcome = "Succeeded",
                Reason = reversal.Reason,
                CorrelationId = http.TraceIdentifier
            });

            await db.SaveChangesAsync(ct);
            return Results.Created($"/api/v1/pharmacy/inventory/stock-movements/{reversal.Id}",
                new
                {
                    id = reversal.Id,
                    status = reversal.Status,
                    reversesId = original.Id,
                    stockPosted = false,
                    message = "Draft reversal created. No stock balance was affected."
                });
        }).RequireAuthorization(manager);

        api.MapGet("/balances", async (
            string? locationId,
            string? productId,
            string? lotNumber,
            DateOnly? expiryDate,
            AppDbContext db,
            CancellationToken ct) =>
        {
            var query = db.StockMovements.AsNoTracking()
                .Where(x => x.Status == "Posted");

            if (!string.IsNullOrWhiteSpace(locationId) && Guid.TryParse(locationId.Trim(), out var locId))
                query = query.Where(x => x.LocationId == locId);
            if (!string.IsNullOrWhiteSpace(productId) && Guid.TryParse(productId.Trim(), out var prodId))
                query = query.Where(x => x.ProductId == prodId);
            if (!string.IsNullOrWhiteSpace(lotNumber)) query = query.Where(x => x.LotNumber == lotNumber.Trim());
            if (expiryDate is not null) query = query.Where(x => x.ExpiryDate == expiryDate.Value);

            var balances = await query
                .GroupBy(x => new { x.LocationId, x.ProductId, x.UnitId, x.LotNumber, x.ExpiryDate })
                .Select(g => new BalanceResponse(
                    g.Key.LocationId,
                    g.Key.ProductId,
                    g.Key.UnitId,
                    g.Key.LotNumber,
                    g.Key.ExpiryDate,
                    g.Sum(x => x.Quantity)))
                .OrderBy(x => x.LocationId)
                .ThenBy(x => x.ProductId)
                .Take(500)
                .ToListAsync(ct);

            return Results.Ok(balances);
        });

        return app;
    }

    public sealed record MovementInput(
        Guid LocationId, Guid ProductId, Guid UnitId, decimal Quantity,
        string MovementType, string? LotNumber, DateOnly? ExpiryDate,
        string? Reference, string ChangeReason, Guid? ReversalOfId);

    public sealed record ReverseInput(string ChangeReason);

    public sealed record MovementResponse(
        Guid Id, Guid LocationId, string LocationCode, string LocationName,
        Guid ProductId, string ProductName,
        Guid UnitId, string UnitCode,
        decimal Quantity, string MovementType, string? LotNumber, DateOnly? ExpiryDate,
        string? Reference, string Reason, string Status, Guid? ReversalOfId,
        string CreatedBySubject, DateTimeOffset CreatedAtUtc);

    public sealed record BalanceResponse(
        Guid LocationId, Guid ProductId, Guid UnitId,
        string? LotNumber, DateOnly? ExpiryDate, decimal Quantity);
}