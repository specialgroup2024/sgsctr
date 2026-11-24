using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.EntityFrameworkCore;
using Sgsctr.Api.Data;

namespace Sgsctr.Api.PharmacyInventory;

public static class PharmacyReceiptDraftExtensions
{
    public static WebApplication MapPharmacyReceiptDraftEndpoints(this WebApplication app)
    {
        var api = app.MapGroup("/api/v1/pharmacy/inventory/receipt-drafts").RequireAuthorization();
        var authEnabled = app.Configuration.GetValue<bool>("Authentication:Enabled", true);
        var localWrites = app.Environment.IsDevelopment() && !authEnabled;
        var manager = new AuthorizationPolicyBuilder()
            .RequireAssertion(context => localWrites || context.User.IsInRole("Administrator"))
            .Build();

        api.MapGet("/", async (AppDbContext db, CancellationToken ct) =>
            Results.Ok(await db.PharmacyReceiptDrafts.AsNoTracking()
                .OrderByDescending(x => x.CreatedAtUtc)
                .Select(x => new ReceiptResponse(x.Id, x.LocationId, x.Location.Name,
                    x.SupplierReference, x.DeliveryReference, x.Status, x.CreatedAtUtc,
                    x.CreatedBySubject, x.ChangeReason,
                    x.Lines.Select(line => new LineResponse(line.Id, line.ProductId,
                        line.Product.DisplayName, line.UnitId, line.Unit.Code, line.Quantity,
                        line.SupplierItemReference)).ToList()))
                .Take(100).ToListAsync(ct))).RequireAuthorization(manager);

        api.MapGet("/{id:guid}", async (Guid id, AppDbContext db, CancellationToken ct) =>
        {
            var row = await db.PharmacyReceiptDrafts.AsNoTracking()
                .Where(x => x.Id == id)
                .Select(x => new ReceiptResponse(x.Id, x.LocationId, x.Location.Name,
                    x.SupplierReference, x.DeliveryReference, x.Status, x.CreatedAtUtc,
                    x.CreatedBySubject, x.ChangeReason,
                    x.Lines.Select(line => new LineResponse(line.Id, line.ProductId,
                        line.Product.DisplayName, line.UnitId, line.Unit.Code, line.Quantity,
                        line.SupplierItemReference)).ToList()))
                .SingleOrDefaultAsync(ct);
            return row is null ? Results.NotFound() : Results.Ok(row);
        }).RequireAuthorization(manager);

        api.MapPost("/", async (ReceiptInput input, ClaimsPrincipal user, AppDbContext db,
            HttpContext http, CancellationToken ct) =>
        {
            if (string.IsNullOrWhiteSpace(input.SupplierReference) || input.SupplierReference.Trim().Length > 200 ||
                input.DeliveryReference?.Length > 160 || string.IsNullOrWhiteSpace(input.ChangeReason) ||
                input.ChangeReason.Trim().Length > 500 || input.Lines is null || input.Lines.Count is < 1 or > 100 ||
                input.Lines.Any(x => x.Quantity <= 0 || x.Quantity > 1000000000m || x.SupplierItemReference?.Length > 160))
                return Results.ValidationProblem(new Dictionary<string, string[]>
                {
                    ["receipt"] = ["Provide supplier reference, reason, and 1–100 lines with positive quantities within the supported range."]
                });

            var location = await db.OrganizationLocations.SingleOrDefaultAsync(x =>
                x.Id == input.LocationId && x.IsActive && x.SectorCode == "PHARMACIES", ct);
            if (location is null) return Results.ValidationProblem(new Dictionary<string, string[]>
            {
                ["locationId"] = ["Choose an active location registered to the Pharmacies sector."]
            });

            var productIds = input.Lines.Select(x => x.ProductId).Distinct().ToArray();
            var unitIds = input.Lines.Select(x => x.UnitId).Distinct().ToArray();
            if (await db.CatalogueProducts.CountAsync(x => productIds.Contains(x.Id) && x.Status == "Draft", ct) != productIds.Length)
                return Results.ValidationProblem(new Dictionary<string, string[]>
                {
                    ["productId"] = ["Every line must reference an existing generic Draft catalogue product."]
                });
            if (await db.UnitsOfMeasure.CountAsync(x => unitIds.Contains(x.Id), ct) != unitIds.Length)
                return Results.ValidationProblem(new Dictionary<string, string[]>
                {
                    ["unitId"] = ["Every line must reference an existing unit of measure."]
                });

            var actor = user.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? user.FindFirst("sub")?.Value ?? "local-development";
            var now = DateTimeOffset.UtcNow;
            var receipt = new PharmacyReceiptDraft
            {
                Id = Guid.NewGuid(), LocationId = location.Id,
                SupplierReference = input.SupplierReference.Trim(),
                DeliveryReference = string.IsNullOrWhiteSpace(input.DeliveryReference) ? null : input.DeliveryReference.Trim(),
                Status = "Draft", CreatedBySubject = actor, UpdatedBySubject = actor,
                CreatedAtUtc = now, UpdatedAtUtc = now, ChangeReason = input.ChangeReason.Trim(),
                Lines = input.Lines.Select(line => new PharmacyReceiptDraftLine
                {
                    Id = Guid.NewGuid(), ProductId = line.ProductId, UnitId = line.UnitId,
                    Quantity = line.Quantity,
                    SupplierItemReference = string.IsNullOrWhiteSpace(line.SupplierItemReference) ? null : line.SupplierItemReference.Trim()
                }).ToList()
            };
            db.PharmacyReceiptDrafts.Add(receipt);
            db.CatalogueAuditEvents.Add(new CatalogueAuditEvent
            {
                Id = Guid.NewGuid(), ActorSubject = actor, Action = "ReceiptDraftCreated",
                ResourceType = "PharmacyReceiptDraft", ResourceId = receipt.Id,
                OccurredAtUtc = now, Outcome = "Succeeded", Reason = receipt.ChangeReason,
                CorrelationId = http.TraceIdentifier
            });
            await db.SaveChangesAsync(ct);
            return Results.Created($"/api/v1/pharmacy/inventory/receipt-drafts/{receipt.Id}",
                new { id = receipt.Id, status = receipt.Status, locationId = receipt.LocationId, lineCount = receipt.Lines.Count,
                    stockPosted = false, message = "Draft evidence only. No stock balance or movement was created." });
        }).RequireAuthorization(manager);

        return app;
    }

    public sealed record ReceiptInput(Guid LocationId, string SupplierReference, string? DeliveryReference,
        string ChangeReason, List<ReceiptLineInput> Lines);
    public sealed record ReceiptLineInput(Guid ProductId, Guid UnitId, decimal Quantity, string? SupplierItemReference);
    public sealed record ReceiptResponse(Guid Id, Guid LocationId, string LocationName, string SupplierReference,
        string? DeliveryReference, string Status, DateTimeOffset CreatedAtUtc, string CreatedBySubject,
        string ChangeReason, List<LineResponse> Lines);
    public sealed record LineResponse(Guid Id, Guid ProductId, string ProductName, Guid UnitId,
        string UnitCode, decimal Quantity, string? SupplierItemReference);
}
