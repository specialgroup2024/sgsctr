using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.EntityFrameworkCore;
using Sgsctr.Api.Data;

namespace Sgsctr.Api.PharmacyInventory;

public static class PharmacyStockTransferExtensions
{
    public static WebApplication MapPharmacyStockTransferEndpoints(this WebApplication app)
    {
        var api = app.MapGroup("/api/v1/pharmacy/inventory/stock-transfers").RequireAuthorization();
        var authenticationEnabled = app.Configuration.GetValue<bool>("Authentication:Enabled", true);
        var localWrites = app.Environment.IsDevelopment() && !authenticationEnabled;
        var manager = new AuthorizationPolicyBuilder()
            .RequireAssertion(context => localWrites || context.User.IsInRole("Administrator"))
            .Build();

        api.MapGet("/", async (
            string? sourceLocationId,
            string? destinationLocationId,
            string? status,
            int page,
            int pageSize,
            AppDbContext db,
            CancellationToken ct) =>
        {
            if (page < 1) page = 1;
            if (pageSize < 1 || pageSize > 200) pageSize = 50;

            var query = db.StockTransferRequests.AsNoTracking();

            if (!string.IsNullOrWhiteSpace(sourceLocationId) && Guid.TryParse(sourceLocationId.Trim(), out var srcId))
                query = query.Where(x => x.SourceLocationId == srcId);
            if (!string.IsNullOrWhiteSpace(destinationLocationId) && Guid.TryParse(destinationLocationId.Trim(), out var dstId))
                query = query.Where(x => x.DestinationLocationId == dstId);
            if (!string.IsNullOrWhiteSpace(status) && StockTransferRequestRules.IsValidStatus(status.Trim()))
                query = query.Where(x => x.Status == status.Trim());

            var total = await query.LongCountAsync(ct);
            var items = await query
                .OrderByDescending(x => x.RequestedAtUtc)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .Select(x => new TransferResponse(
                    x.Id, x.SourceLocationId, x.SourceLocation.Code, x.SourceLocation.Name,
                    x.DestinationLocationId, x.DestinationLocation.Code, x.DestinationLocation.Name,
                    x.Status, x.Reason, x.RequestedBySubject, x.ApprovedBySubject,
                    x.RequestedAtUtc, x.ApprovedAtUtc, x.UpdatedBySubject, x.UpdatedAtUtc,
                    x.Lines.Count))
                .ToListAsync(ct);

            return Results.Ok(new { total, page, pageSize, items });
        });

        api.MapGet("/{id:guid}", async (Guid id, AppDbContext db, CancellationToken ct) =>
        {
            var row = await db.StockTransferRequests.AsNoTracking()
                .Where(x => x.Id == id)
                .Select(x => new TransferDetailResponse(
                    x.Id, x.SourceLocationId, x.SourceLocation.Code, x.SourceLocation.Name,
                    x.DestinationLocationId, x.DestinationLocation.Code, x.DestinationLocation.Name,
                    x.Status, x.Reason, x.RequestedBySubject, x.ApprovedBySubject,
                    x.RequestedAtUtc, x.ApprovedAtUtc, x.UpdatedBySubject, x.UpdatedAtUtc,
                    x.Lines.Select(line => new TransferLineResponse(
                        line.Id, line.ProductId, line.Product.DisplayName,
                        line.UnitId, line.Unit.Code, line.Quantity,
                        line.LotNumber, line.ExpiryDate)).ToList()))
                .SingleOrDefaultAsync(ct);
            return row is null ? Results.NotFound() : Results.Ok(row);
        });

        api.MapPost("/", async (
            TransferInput input, ClaimsPrincipal user, AppDbContext db, HttpContext http, CancellationToken ct) =>
        {
            if (input.SourceLocationId == input.DestinationLocationId)
                return Results.ValidationProblem(new Dictionary<string, string[]>
                {
                    ["destinationLocationId"] = ["Destination location must differ from the source location."]
                });
            if (!StockTransferRequestRules.IsValidReason(input.Reason))
                return Results.ValidationProblem(new Dictionary<string, string[]>
                {
                    ["reason"] = ["Reason must be 500 characters or fewer."]
                });
            if (input.Lines is null || input.Lines.Count is < 1 or > 100 ||
                input.Lines.Any(line => !StockTransferRequestRules.IsValidQuantity(line.Quantity) ||
                                        !StockTransferRequestRules.IsValidLotNumber(line.LotNumber)))
                return Results.ValidationProblem(new Dictionary<string, string[]>
                {
                    ["lines"] = ["Provide 1-100 lines with positive quantities and lot numbers of 64 characters or fewer."]
                });

            var sourceLocation = await db.OrganizationLocations.SingleOrDefaultAsync(x =>
                x.Id == input.SourceLocationId && x.IsActive && x.SectorCode == "PHARMACIES", ct);
            if (sourceLocation is null) return Results.ValidationProblem(new Dictionary<string, string[]>
            {
                ["sourceLocationId"] = ["Choose an active source location registered to the Pharmacies sector."]
            });
            var destinationLocation = await db.OrganizationLocations.SingleOrDefaultAsync(x =>
                x.Id == input.DestinationLocationId && x.IsActive && x.SectorCode == "PHARMACIES", ct);
            if (destinationLocation is null) return Results.ValidationProblem(new Dictionary<string, string[]>
            {
                ["destinationLocationId"] = ["Choose an active destination location registered to the Pharmacies sector."]
            });

            var productIds = input.Lines.Select(x => x.ProductId).Distinct().ToArray();
            var unitIds = input.Lines.Select(x => x.UnitId).Distinct().ToArray();
            if (await db.CatalogueProducts.CountAsync(x => productIds.Contains(x.Id), ct) != productIds.Length)
                return Results.ValidationProblem(new Dictionary<string, string[]>
                {
                    ["productId"] = ["Every line must reference an existing catalogue product."]
                });
            if (await db.UnitsOfMeasure.CountAsync(x => unitIds.Contains(x.Id), ct) != unitIds.Length)
                return Results.ValidationProblem(new Dictionary<string, string[]>
                {
                    ["unitId"] = ["Every line must reference an existing unit of measure."]
                });

            var actor = user.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? user.FindFirst("sub")?.Value ?? "local-development";
            var now = DateTimeOffset.UtcNow;

            var request = new StockTransferRequest
            {
                Id = Guid.NewGuid(),
                SourceLocationId = sourceLocation.Id,
                DestinationLocationId = destinationLocation.Id,
                Status = "Draft",
                Reason = string.IsNullOrWhiteSpace(input.Reason) ? null : input.Reason.Trim(),
                RequestedBySubject = actor,
                RequestedAtUtc = now,
                UpdatedBySubject = actor,
                UpdatedAtUtc = now,
                Lines = input.Lines.Select(line => new StockTransferRequestLine
                {
                    Id = Guid.NewGuid(),
                    ProductId = line.ProductId,
                    UnitId = line.UnitId,
                    Quantity = line.Quantity,
                    LotNumber = string.IsNullOrWhiteSpace(line.LotNumber) ? null : line.LotNumber.Trim(),
                    ExpiryDate = line.ExpiryDate
                }).ToList()
            };

            db.StockTransferRequests.Add(request);
            db.CatalogueAuditEvents.Add(Audit(actor, "StockTransferRequestCreated", request.Id, request.Reason, http.TraceIdentifier, now));

            await db.SaveChangesAsync(ct);
            return Results.Created($"/api/v1/pharmacy/inventory/stock-transfers/{request.Id}",
                new
                {
                    id = request.Id,
                    status = request.Status,
                    sourceLocationId = request.SourceLocationId,
                    destinationLocationId = request.DestinationLocationId,
                    lineCount = request.Lines.Count,
                    stockPosted = false,
                    message = "Draft transfer request created. No stock balance or movement was affected."
                });
        }).RequireAuthorization(manager);

        api.MapPost("/{id:guid}/submit", async (
            Guid id, ClaimsPrincipal user, AppDbContext db, HttpContext http, CancellationToken ct) =>
            await TransitionAsync(id, user, db, http, ct,
                requiredStatusCheck: StockTransferRequestRules.CanSubmit,
                nextStatus: "Submitted",
                auditAction: "StockTransferRequestSubmitted",
                enforceSeparationOfDuties: false))
            .RequireAuthorization(manager);

        api.MapPost("/{id:guid}/send-for-approval", async (
            Guid id, ClaimsPrincipal user, AppDbContext db, HttpContext http, CancellationToken ct) =>
            await TransitionAsync(id, user, db, http, ct,
                requiredStatusCheck: StockTransferRequestRules.CanSendForApproval,
                nextStatus: "PendingApproval",
                auditAction: "StockTransferRequestSentForApproval",
                enforceSeparationOfDuties: false))
            .RequireAuthorization(manager);

        api.MapPost("/{id:guid}/approve", async (
            Guid id, ClaimsPrincipal user, AppDbContext db, HttpContext http, CancellationToken ct) =>
        {
            var request = await db.StockTransferRequests
                .Include(x => x.Lines)
                .SingleOrDefaultAsync(x => x.Id == id, ct);
            if (request is null) return Results.NotFound();

            var actor = user.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? user.FindFirst("sub")?.Value ?? "local-development";
            if (!StockTransferRequestRules.CanApprove(request.Status))
                return Results.ValidationProblem(new Dictionary<string, string[]>
                {
                    ["status"] = ["Only PendingApproval requests can be approved."]
                });
            if (request.RequestedBySubject == actor)
                return Results.ValidationProblem(new Dictionary<string, string[]>
                {
                    ["actor"] = ["The requester cannot approve or reject their own transfer request."]
                });

            var now = DateTimeOffset.UtcNow;
            request.Status = "Approved";
            request.ApprovedBySubject = actor;
            request.ApprovedAtUtc = now;
            request.UpdatedBySubject = actor;
            request.UpdatedAtUtc = now;

            // Draft-only movements per the approved boundary: posting to balance-affecting
            // status remains gated pending Q12/Q13 approval.
            var transferReason = string.IsNullOrWhiteSpace(request.Reason)
                ? "Approved stock transfer request"
                : request.Reason.Trim();
            foreach (var line in request.Lines)
            {
                db.StockMovements.AddRange(
                    new StockMovement
                    {
                        Id = Guid.NewGuid(),
                        LocationId = request.SourceLocationId,
                        ProductId = line.ProductId,
                        UnitId = line.UnitId,
                        Quantity = -line.Quantity,
                        MovementType = "TransferOut",
                        LotNumber = line.LotNumber,
                        ExpiryDate = line.ExpiryDate,
                        Reference = $"StockTransferRequest:{request.Id}",
                        Reason = transferReason,
                        Status = "Draft",
                        StockTransferRequestId = request.Id,
                        CreatedBySubject = actor,
                        CreatedAtUtc = now
                    },
                    new StockMovement
                    {
                        Id = Guid.NewGuid(),
                        LocationId = request.DestinationLocationId,
                        ProductId = line.ProductId,
                        UnitId = line.UnitId,
                        Quantity = line.Quantity,
                        MovementType = "TransferIn",
                        LotNumber = line.LotNumber,
                        ExpiryDate = line.ExpiryDate,
                        Reference = $"StockTransferRequest:{request.Id}",
                        Reason = transferReason,
                        Status = "Draft",
                        StockTransferRequestId = request.Id,
                        CreatedBySubject = actor,
                        CreatedAtUtc = now
                    });
            }

            db.CatalogueAuditEvents.Add(Audit(actor, "StockTransferRequestApproved", request.Id, request.Reason, http.TraceIdentifier, now));
            await db.SaveChangesAsync(ct);
            return Results.Ok(new
            {
                id = request.Id,
                status = request.Status,
                approvedBySubject = actor,
                movementsCreated = request.Lines.Count * 2,
                stockPosted = false,
                message = "Transfer request approved. Draft StockMovement entries were created only; no stock balance was affected."
            });
        }).RequireAuthorization(manager);

        api.MapPost("/{id:guid}/reject", async (
            Guid id, RejectInput input, ClaimsPrincipal user, AppDbContext db, HttpContext http, CancellationToken ct) =>
        {
            if (!StockMovementRules.IsValidReason(input.Reason))
                return Results.ValidationProblem(new Dictionary<string, string[]>
                {
                    ["reason"] = ["Reason is required and must be 500 characters or fewer."]
                });

            var request = await db.StockTransferRequests.SingleOrDefaultAsync(x => x.Id == id, ct);
            if (request is null) return Results.NotFound();

            var actor = user.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? user.FindFirst("sub")?.Value ?? "local-development";
            if (!StockTransferRequestRules.CanReject(request.Status))
                return Results.ValidationProblem(new Dictionary<string, string[]>
                {
                    ["status"] = ["Only PendingApproval requests can be rejected."]
                });
            if (request.RequestedBySubject == actor)
                return Results.ValidationProblem(new Dictionary<string, string[]>
                {
                    ["actor"] = ["The requester cannot approve or reject their own transfer request."]
                });

            var now = DateTimeOffset.UtcNow;
            request.Status = "Rejected";
            request.ApprovedBySubject = actor;
            request.ApprovedAtUtc = now;
            request.UpdatedBySubject = actor;
            request.UpdatedAtUtc = now;

            db.CatalogueAuditEvents.Add(Audit(actor, "StockTransferRequestRejected", request.Id, input.Reason, http.TraceIdentifier, now));
            await db.SaveChangesAsync(ct);
            return Results.Ok(new { id = request.Id, status = request.Status, stockPosted = false });
        }).RequireAuthorization(manager);

        api.MapPost("/{id:guid}/cancel", async (
            Guid id, ClaimsPrincipal user, AppDbContext db, HttpContext http, CancellationToken ct) =>
            await TransitionAsync(id, user, db, http, ct,
                requiredStatusCheck: StockTransferRequestRules.CanCancel,
                nextStatus: "Cancelled",
                auditAction: "StockTransferRequestCancelled",
                enforceSeparationOfDuties: false))
            .RequireAuthorization(manager);

        return app;
    }

    private static async Task<IResult> TransitionAsync(
        Guid id, ClaimsPrincipal user, AppDbContext db, HttpContext http, CancellationToken ct,
        Func<string, bool> requiredStatusCheck, string nextStatus, string auditAction, bool enforceSeparationOfDuties)
    {
        var request = await db.StockTransferRequests.SingleOrDefaultAsync(x => x.Id == id, ct);
        if (request is null) return Results.NotFound();

        var actor = user.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? user.FindFirst("sub")?.Value ?? "local-development";
        if (!requiredStatusCheck(request.Status))
            return Results.ValidationProblem(new Dictionary<string, string[]>
            {
                ["status"] = [$"Request status {request.Status} does not allow the requested action."]
            });
        if (enforceSeparationOfDuties && request.RequestedBySubject == actor)
            return Results.ValidationProblem(new Dictionary<string, string[]>
            {
                ["actor"] = ["The requester cannot perform this action on their own transfer request."]
            });

        var now = DateTimeOffset.UtcNow;
        request.Status = nextStatus;
        request.UpdatedBySubject = actor;
        request.UpdatedAtUtc = now;

        db.CatalogueAuditEvents.Add(Audit(actor, auditAction, request.Id, request.Reason, http.TraceIdentifier, now));
        await db.SaveChangesAsync(ct);
        return Results.Ok(new { id = request.Id, status = request.Status, stockPosted = false });
    }

    private static CatalogueAuditEvent Audit(string actor, string action, Guid resourceId, string? reason, string correlationId, DateTimeOffset now) => new()
    {
        Id = Guid.NewGuid(),
        ActorSubject = actor,
        Action = action,
        ResourceType = "StockTransferRequest",
        ResourceId = resourceId,
        OccurredAtUtc = now,
        Outcome = "Succeeded",
        Reason = reason,
        CorrelationId = correlationId
    };

    public sealed record TransferInput(
        Guid SourceLocationId, Guid DestinationLocationId, string? Reason, List<TransferLineInput> Lines);

    public sealed record TransferLineInput(Guid ProductId, Guid UnitId, decimal Quantity, string? LotNumber, DateOnly? ExpiryDate);

    public sealed record RejectInput(string Reason);

    public sealed record TransferResponse(
        Guid Id, Guid SourceLocationId, string SourceLocationCode, string SourceLocationName,
        Guid DestinationLocationId, string DestinationLocationCode, string DestinationLocationName,
        string Status, string? Reason, string RequestedBySubject, string? ApprovedBySubject,
        DateTimeOffset RequestedAtUtc, DateTimeOffset? ApprovedAtUtc, string UpdatedBySubject, DateTimeOffset UpdatedAtUtc,
        int LineCount);

    public sealed record TransferDetailResponse(
        Guid Id, Guid SourceLocationId, string SourceLocationCode, string SourceLocationName,
        Guid DestinationLocationId, string DestinationLocationCode, string DestinationLocationName,
        string Status, string? Reason, string RequestedBySubject, string? ApprovedBySubject,
        DateTimeOffset RequestedAtUtc, DateTimeOffset? ApprovedAtUtc, string UpdatedBySubject, DateTimeOffset UpdatedAtUtc,
        List<TransferLineResponse> Lines);

    public sealed record TransferLineResponse(
        Guid Id, Guid ProductId, string ProductName, Guid UnitId, string UnitCode,
        decimal Quantity, string? LotNumber, DateOnly? ExpiryDate);
}
