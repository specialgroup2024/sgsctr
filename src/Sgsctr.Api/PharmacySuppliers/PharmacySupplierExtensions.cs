using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.EntityFrameworkCore;
using Sgsctr.Api.Data;

namespace Sgsctr.Api.PharmacySuppliers;

public static class PharmacySupplierExtensions
{
    public static WebApplication MapPharmacySupplierEndpoints(this WebApplication app)
    {
        var api = app.MapGroup("/api/v1/pharmacy/suppliers").RequireAuthorization();
        var authenticationEnabled = app.Configuration.GetValue<bool>("Authentication:Enabled", true);
        var localDevelopmentWrites = app.Environment.IsDevelopment() && !authenticationEnabled;
        api.MapGet("/permissions", (ClaimsPrincipal user) =>
            Results.Ok(new { canManage = localDevelopmentWrites || user.IsInRole("Administrator") }));

        var writePolicy = new AuthorizationPolicyBuilder()
            .RequireAssertion(context => localDevelopmentWrites || context.User.IsInRole("Administrator"))
            .Build();

        api.MapGet("/", async (AppDbContext db, CancellationToken ct) =>
            Results.Ok(await db.PharmacySuppliers.AsNoTracking()
                .OrderBy(x => x.Code)
                .Select(x => new SupplierSummary(x.Id, x.Code, x.DisplayName, x.Status, x.Version,
                    x.CreatedAtUtc, x.Evidence.Count,
                    x.ReviewRequests.Count(r => r.Status == "Pending")))
                .Take(200).ToListAsync(ct)));

        api.MapGet("/{id:guid}", async (Guid id, AppDbContext db, CancellationToken ct) =>
        {
            var supplier = await db.PharmacySuppliers.AsNoTracking()
                .Where(x => x.Id == id)
                .Select(x => new SupplierDetail(x.Id, x.Code, x.DisplayName, x.Status, x.Version,
                    x.CreatedAtUtc, x.UpdatedAtUtc, x.ChangeReason,
                    x.Evidence.OrderByDescending(e => e.AddedAtUtc)
                        .Select(e => new EvidenceResponse(e.Id, e.EvidenceKind, e.Title, e.Issuer,
                            e.ReferenceNumber, e.SourceReference, e.IssuedOn, e.ExpiresOn,
                            e.VerificationStatus, e.AddedAtUtc, e.ChangeReason)).ToList(),
                    x.ReviewRequests.OrderByDescending(r => r.RequestedAtUtc)
                        .Select(r => new ReviewResponse(r.Id, r.Status, r.RequestedAtUtc,
                            r.RequestedBySubject, r.Reason)).ToList()))
                .SingleOrDefaultAsync(ct);
            return supplier is null ? Results.NotFound() : Results.Ok(supplier);
        });

        api.MapPost("/", async (SupplierInput input, ClaimsPrincipal user, AppDbContext db,
            HttpContext http, CancellationToken ct) =>
        {
            if (!SupplierRules.IsValidCode(input.Code) || !SupplierRules.IsValidDisplayName(input.DisplayName) ||
                string.IsNullOrWhiteSpace(input.ChangeReason) || input.ChangeReason.Trim().Length > 500)
                return Results.ValidationProblem(new Dictionary<string, string[]>
                {
                    ["supplier"] = ["Provide a 2–32 character code (letters, digits, hyphen or underscore), display name (max 200), and change reason (max 500)."]
                });

            var code = SupplierRules.NormalizeCode(input.Code);
            if (await db.PharmacySuppliers.AnyAsync(x => x.Code == code, ct))
                return Results.Conflict(new { error = "This supplier code already exists. Supplier-name similarity is not automatically resolved." });

            var actor = Actor(user, localDevelopmentWrites);
            var now = DateTimeOffset.UtcNow;
            var supplier = new PharmacySupplier
            {
                Id = Guid.NewGuid(), Code = code, DisplayName = input.DisplayName.Trim(),
                Status = "Draft", Version = 1, CreatedBySubject = actor, UpdatedBySubject = actor,
                CreatedAtUtc = now, UpdatedAtUtc = now, ChangeReason = input.ChangeReason.Trim()
            };
            db.PharmacySuppliers.Add(supplier);
            AddAudit(db, actor, "SupplierDraftCreated", "PharmacySupplier", supplier.Id,
                supplier.ChangeReason, http.TraceIdentifier, now);
            try { await db.SaveChangesAsync(ct); }
            catch (DbUpdateException) { return Results.Conflict(new { error = "The supplier code already exists." }); }
            return Results.Created($"/api/v1/pharmacy/suppliers/{supplier.Id}",
                new { id = supplier.Id, code = supplier.Code, displayName = supplier.DisplayName,
                    status = supplier.Status, qualified = false });
        }).RequireAuthorization(writePolicy);

        api.MapPost("/{id:guid}/evidence", async (Guid id, EvidenceInput input, ClaimsPrincipal user,
            AppDbContext db, HttpContext http, CancellationToken ct) =>
        {
            if (!SupplierRules.IsValidEvidence(input.EvidenceKind, input.Title, input.ChangeReason) ||
                input.Issuer?.Length > 200 || input.ReferenceNumber?.Length > 120 ||
                input.SourceReference?.Length > 1000 ||
                (input.IssuedOn.HasValue && input.ExpiresOn.HasValue && input.ExpiresOn < input.IssuedOn))
                return Results.ValidationProblem(new Dictionary<string, string[]>
                {
                    ["evidence"] = ["Provide evidence kind, title and reason; optional issuer/reference/source must fit their limits and expiry cannot precede issue date."]
                });

            var supplier = await db.PharmacySuppliers.SingleOrDefaultAsync(x => x.Id == id, ct);
            if (supplier is null) return Results.NotFound();
            var actor = Actor(user, localDevelopmentWrites);
            var now = DateTimeOffset.UtcNow;
            var evidence = new PharmacySupplierEvidence
            {
                Id = Guid.NewGuid(), SupplierId = id, EvidenceKind = input.EvidenceKind.Trim(),
                Title = input.Title.Trim(), Issuer = Clean(input.Issuer), ReferenceNumber = Clean(input.ReferenceNumber),
                SourceReference = Clean(input.SourceReference), IssuedOn = input.IssuedOn, ExpiresOn = input.ExpiresOn,
                VerificationStatus = "Unverified", AddedBySubject = actor, AddedAtUtc = now,
                ChangeReason = input.ChangeReason.Trim()
            };
            db.PharmacySupplierEvidence.Add(evidence);
            AddAudit(db, actor, "SupplierEvidenceAdded", "PharmacySupplierEvidence", evidence.Id,
                evidence.ChangeReason, http.TraceIdentifier, now);
            await db.SaveChangesAsync(ct);
            return Results.Created($"/api/v1/pharmacy/suppliers/{id}",
                new { id = evidence.Id, supplierId = id, verificationStatus = evidence.VerificationStatus });
        }).RequireAuthorization(writePolicy);

        api.MapGet("/review-requests", async (AppDbContext db, CancellationToken ct) =>
            Results.Ok(await db.PharmacySupplierReviewRequests.AsNoTracking()
                .Where(x => x.Status == "Pending").OrderBy(x => x.RequestedAtUtc)
                .Select(x => new ReviewQueueItem(x.Id, x.SupplierId, x.Supplier.Code,
                    x.Supplier.DisplayName, x.RequestedAtUtc, x.RequestedBySubject, x.Reason))
                .Take(200).ToListAsync(ct)));

        api.MapPost("/{id:guid}/review-requests", async (Guid id, ReviewRequestInput input,
            ClaimsPrincipal user, AppDbContext db, HttpContext http, CancellationToken ct) =>
        {
            if (string.IsNullOrWhiteSpace(input.Reason) || input.Reason.Trim().Length > 500)
                return Results.ValidationProblem(new Dictionary<string, string[]> { ["reason"] = ["A review reason of up to 500 characters is required."] });
            var supplier = await db.PharmacySuppliers.SingleOrDefaultAsync(x => x.Id == id, ct);
            if (supplier is null) return Results.NotFound();
            if (await db.PharmacySupplierReviewRequests.AnyAsync(x => x.SupplierId == id && x.Status == "Pending", ct))
                return Results.Conflict(new { error = "A pending review request already exists for this supplier." });

            var actor = Actor(user, localDevelopmentWrites);
            var now = DateTimeOffset.UtcNow;
            var review = new PharmacySupplierReviewRequest
            {
                Id = Guid.NewGuid(), SupplierId = id, Status = "Pending",
                RequestedBySubject = actor, RequestedAtUtc = now, Reason = input.Reason.Trim(),
                CorrelationId = http.TraceIdentifier
            };
            db.PharmacySupplierReviewRequests.Add(review);
            AddAudit(db, actor, "SupplierReviewRequested", "PharmacySupplierReviewRequest",
                review.Id, review.Reason, http.TraceIdentifier, now);
            try { await db.SaveChangesAsync(ct); }
            catch (DbUpdateException) { return Results.Conflict(new { error = "A pending review request already exists for this supplier." }); }
            return Results.Created($"/api/v1/pharmacy/suppliers/review-requests",
                new { id = review.Id, supplierId = id, status = review.Status,
                    message = "Review requested only. Supplier qualification and approval are not recorded." });
        }).RequireAuthorization(writePolicy);

        return app;
    }

    private static string Actor(ClaimsPrincipal user, bool localWrites) => localWrites ? "local-development" :
        user.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? user.FindFirst("sub")?.Value ?? "unknown-subject";
    private static string? Clean(string? value) => string.IsNullOrWhiteSpace(value) ? null : value.Trim();
    private static void AddAudit(AppDbContext db, string actor, string action, string resourceType,
        Guid resourceId, string reason, string correlationId, DateTimeOffset now) =>
        db.CatalogueAuditEvents.Add(new CatalogueAuditEvent
        {
            Id = Guid.NewGuid(), ActorSubject = actor, Action = action, ResourceType = resourceType,
            ResourceId = resourceId, OccurredAtUtc = now, Outcome = "Succeeded",
            Reason = reason, CorrelationId = correlationId
        });

    public sealed record SupplierInput(string Code, string DisplayName, string ChangeReason);
    public sealed record EvidenceInput(string EvidenceKind, string Title, string? Issuer,
        string? ReferenceNumber, string? SourceReference, DateOnly? IssuedOn, DateOnly? ExpiresOn, string ChangeReason);
    public sealed record ReviewRequestInput(string Reason);
    public sealed record SupplierSummary(Guid Id, string Code, string DisplayName, string Status,
        int Version, DateTimeOffset CreatedAtUtc, int EvidenceCount, int PendingReviewCount);
    public sealed record SupplierDetail(Guid Id, string Code, string DisplayName, string Status,
        int Version, DateTimeOffset CreatedAtUtc, DateTimeOffset UpdatedAtUtc, string ChangeReason,
        List<EvidenceResponse> Evidence, List<ReviewResponse> ReviewRequests);
    public sealed record EvidenceResponse(Guid Id, string EvidenceKind, string Title, string? Issuer,
        string? ReferenceNumber, string? SourceReference, DateOnly? IssuedOn, DateOnly? ExpiresOn,
        string VerificationStatus, DateTimeOffset AddedAtUtc, string ChangeReason);
    public sealed record ReviewResponse(Guid Id, string Status, DateTimeOffset RequestedAtUtc,
        string RequestedBySubject, string Reason);
    public sealed record ReviewQueueItem(Guid Id, Guid SupplierId, string SupplierCode,
        string SupplierName, DateTimeOffset RequestedAtUtc, string RequestedBySubject, string Reason);
}
