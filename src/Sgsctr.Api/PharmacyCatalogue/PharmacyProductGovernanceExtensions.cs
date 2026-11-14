using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.EntityFrameworkCore;
using Sgsctr.Api.Data;

namespace Sgsctr.Api.PharmacyCatalogue;

public static class PharmacyProductGovernanceExtensions
{
    public static WebApplication MapPharmacyProductGovernanceEndpoints(this WebApplication app)
    {
        var api = app.MapGroup("/api/v1/pharmacy/catalogue").RequireAuthorization();
        var authenticationEnabled = app.Configuration.GetValue<bool>("Authentication:Enabled", true);
        var localDevelopmentWrites = app.Environment.IsDevelopment() && !authenticationEnabled;
        var writePolicy = new AuthorizationPolicyBuilder()
            .RequireAssertion(context => localDevelopmentWrites || context.User.IsInRole("Administrator"))
            .Build();

        api.MapGet("/products/{id:guid}/governance", async (Guid id, AppDbContext db, CancellationToken ct) =>
        {
            if (!await db.CatalogueProducts.AnyAsync(x => x.Id == id, ct)) return Results.NotFound();
            var family = await db.CatalogueProductFamilyAssignments.AsNoTracking()
                .Where(x => x.ProductId == id)
                .Select(x => new FamilyResponse(x.Id, x.FamilyCode, x.ReviewStatus, x.ProposedAtUtc, x.ProposedBySubject))
                .SingleOrDefaultAsync(ct);
            var identifiers = await db.CatalogueProductIdentifiers.AsNoTracking().Where(x => x.ProductId == id)
                .OrderBy(x => x.CreatedAtUtc)
                .Select(x => new IdentifierResponse(x.Id, x.SchemeCode, x.Value, x.PackagingLevel,
                    x.VerificationStatus, x.SourceUri, x.CreatedAtUtc, x.CreatedBySubject)).ToListAsync(ct);
            var evidence = await db.CatalogueRegulatoryEvidence.AsNoTracking().Where(x => x.ProductId == id)
                .OrderBy(x => x.CreatedAtUtc)
                .Select(x => new EvidenceResponse(x.Id, x.AuthorityCode, x.EvidenceType, x.ReferenceNumber,
                    x.DocumentUri, x.RegulatoryDocumentId, x.PublishedOn, x.EffectiveFrom, x.ExpiresOn,
                    x.VerificationStatus, x.CreatedAtUtc, x.CreatedBySubject)).ToListAsync(ct);
            var requests = await db.CatalogueLifecycleRequests.AsNoTracking().Where(x => x.ProductId == id)
                .OrderByDescending(x => x.RequestedAtUtc)
                .Select(x => new LifecycleResponse(x.Id, x.RequestedAction, x.ReviewStatus, x.Reason,
                    x.RequestedAtUtc, x.RequestedBySubject)).ToListAsync(ct);
            return Results.Ok(new GovernanceResponse(family, identifiers, evidence, requests));
        });

        api.MapPost("/products/{id:guid}/family", async (
            Guid id, FamilyInput input, ClaimsPrincipal user, AppDbContext db, HttpContext http, CancellationToken ct) =>
        {
            var allowed = new[] { "RegularMedicine", "Chemotherapy", "MedicalSupplyDevice", "Cosmetic" };
            if (!allowed.Contains(input.FamilyCode, StringComparer.Ordinal))
                return Results.ValidationProblem(new Dictionary<string, string[]> {
                    ["familyCode"] = ["Choose one of the four provisional pharmacy families."]
                });
            if (!await db.CatalogueProducts.AnyAsync(x => x.Id == id, ct)) return Results.NotFound();
            if (await db.CatalogueProductFamilyAssignments.AnyAsync(x => x.ProductId == id, ct))
                return Results.Conflict(new { error = "A provisional family assignment already exists. A replacement workflow requires professional review." });

            var actor = Actor(user, localDevelopmentWrites);
            var row = new CatalogueProductFamilyAssignment
            {
                Id = Guid.NewGuid(), ProductId = id, FamilyCode = input.FamilyCode,
                ReviewStatus = "PendingProfessionalReview", ProposedAtUtc = DateTimeOffset.UtcNow,
                ProposedBySubject = actor
            };
            db.CatalogueProductFamilyAssignments.Add(row);
            AddAudit(db, actor, "ProductFamilyProposed", "CatalogueProductFamilyAssignment", row.Id,
                input.ChangeReason, http.TraceIdentifier);
            await db.SaveChangesAsync(ct);
            return Results.Created($"/api/v1/pharmacy/catalogue/products/{id}/governance",
                new FamilyResponse(row.Id, row.FamilyCode, row.ReviewStatus, row.ProposedAtUtc, row.ProposedBySubject));
        }).RequireAuthorization(writePolicy);

        api.MapPost("/products/{id:guid}/identifiers", async (
            Guid id, IdentifierInput input, ClaimsPrincipal user, AppDbContext db, HttpContext http, CancellationToken ct) =>
        {
            var schemes = new[] { "GTIN", "UDI-DI", "EDA-Registration", "EDA-Cosmetics-Notification" };
            if (!schemes.Contains(input.SchemeCode, StringComparer.Ordinal) ||
                string.IsNullOrWhiteSpace(input.Value) || input.Value.Trim().Length > 160 ||
                input.PackagingLevel?.Length > 64 || input.ChangeReason?.Length > 500 ||
                !IsHttpsOrNull(input.SourceUri))
                return Results.ValidationProblem(new Dictionary<string, string[]> {
                    ["identifier"] = ["Provide a supported identifier scheme, value (max 160), optional packaging level (max 64), and optional HTTPS source URL."]
                });
            if (!await db.CatalogueProducts.AnyAsync(x => x.Id == id, ct)) return Results.NotFound();
            var actor = Actor(user, localDevelopmentWrites);
            var row = new CatalogueProductIdentifier
            {
                Id = Guid.NewGuid(), ProductId = id, SchemeCode = input.SchemeCode,
                Value = input.Value.Trim(), PackagingLevel = string.IsNullOrWhiteSpace(input.PackagingLevel) ? null : input.PackagingLevel.Trim(),
                VerificationStatus = "PendingVerification", SourceUri = input.SourceUri,
                CreatedAtUtc = DateTimeOffset.UtcNow, CreatedBySubject = actor
            };
            db.CatalogueProductIdentifiers.Add(row);
            AddAudit(db, actor, "ProductIdentifierProposed", "CatalogueProductIdentifier", row.Id,
                input.ChangeReason, http.TraceIdentifier);
            try { await db.SaveChangesAsync(ct); }
            catch (DbUpdateException) { return Results.Conflict(new { error = "This identifier scheme/value is already recorded." }); }
            return Results.Created($"/api/v1/pharmacy/catalogue/products/{id}/governance",
                new IdentifierResponse(row.Id, row.SchemeCode, row.Value, row.PackagingLevel, row.VerificationStatus,
                    row.SourceUri, row.CreatedAtUtc, row.CreatedBySubject));
        }).RequireAuthorization(writePolicy);

        api.MapPost("/products/{id:guid}/evidence", async (
            Guid id, EvidenceInput input, ClaimsPrincipal user, AppDbContext db, HttpContext http, CancellationToken ct) =>
        {
            if (string.IsNullOrWhiteSpace(input.AuthorityCode) || input.AuthorityCode.Trim().Length > 48 ||
                string.IsNullOrWhiteSpace(input.EvidenceType) || input.EvidenceType.Trim().Length > 48 ||
                string.IsNullOrWhiteSpace(input.ReferenceNumber) || input.ReferenceNumber.Trim().Length > 160 ||
                input.ChangeReason?.Length > 500 || !IsHttpsOrNull(input.DocumentUri) ||
                (input.ExpiresOn.HasValue && input.EffectiveFrom.HasValue && input.ExpiresOn < input.EffectiveFrom))
                return Results.ValidationProblem(new Dictionary<string, string[]> {
                    ["evidence"] = ["Authority, evidence type and reference number are required; dates must be consistent and document links must use HTTPS."]
                });
            if (!await db.CatalogueProducts.AnyAsync(x => x.Id == id, ct)) return Results.NotFound();
            if (input.RegulatoryDocumentId.HasValue &&
                !await db.RegulatoryDocuments.AnyAsync(x => x.Id == input.RegulatoryDocumentId.Value, ct))
                return Results.ValidationProblem(new Dictionary<string, string[]> { ["regulatoryDocumentId"] = ["The linked Regulatory Intelligence document does not exist."] });

            var actor = Actor(user, localDevelopmentWrites);
            var row = new CatalogueRegulatoryEvidence
            {
                Id = Guid.NewGuid(), ProductId = id, AuthorityCode = input.AuthorityCode.Trim(),
                EvidenceType = input.EvidenceType.Trim(), ReferenceNumber = input.ReferenceNumber.Trim(),
                DocumentUri = input.DocumentUri, RegulatoryDocumentId = input.RegulatoryDocumentId,
                PublishedOn = input.PublishedOn, EffectiveFrom = input.EffectiveFrom, ExpiresOn = input.ExpiresOn,
                VerificationStatus = "PendingReview", CreatedAtUtc = DateTimeOffset.UtcNow, CreatedBySubject = actor
            };
            db.CatalogueRegulatoryEvidence.Add(row);
            AddAudit(db, actor, "ProductRegulatoryEvidenceProposed", "CatalogueRegulatoryEvidence", row.Id,
                input.ChangeReason, http.TraceIdentifier);
            await db.SaveChangesAsync(ct);
            return Results.Created($"/api/v1/pharmacy/catalogue/products/{id}/governance",
                new EvidenceResponse(row.Id, row.AuthorityCode, row.EvidenceType, row.ReferenceNumber,
                    row.DocumentUri, row.RegulatoryDocumentId, row.PublishedOn, row.EffectiveFrom, row.ExpiresOn,
                    row.VerificationStatus, row.CreatedAtUtc, row.CreatedBySubject));
        }).RequireAuthorization(writePolicy);

        api.MapPost("/products/{id:guid}/lifecycle-requests", async (
            Guid id, LifecycleInput input, ClaimsPrincipal user, AppDbContext db, HttpContext http, CancellationToken ct) =>
        {
            if (input.RequestedAction is not ("Activate" or "Retire") ||
                string.IsNullOrWhiteSpace(input.Reason) || input.Reason.Trim().Length > 500)
                return Results.ValidationProblem(new Dictionary<string, string[]> {
                    ["request"] = ["Choose Activate or Retire and provide a reason of 500 characters or fewer."]
                });
            if (!await db.CatalogueProducts.AnyAsync(x => x.Id == id, ct)) return Results.NotFound();
            var actor = Actor(user, localDevelopmentWrites);
            var row = new CatalogueLifecycleRequest
            {
                Id = Guid.NewGuid(), ProductId = id, RequestedAction = input.RequestedAction,
                ReviewStatus = "PendingProfessionalReview", Reason = input.Reason.Trim(),
                RequestedAtUtc = DateTimeOffset.UtcNow, RequestedBySubject = actor
            };
            db.CatalogueLifecycleRequests.Add(row);
            AddAudit(db, actor, "ProductLifecycleRequested", "CatalogueLifecycleRequest", row.Id,
                input.ChangeReason, http.TraceIdentifier);
            await db.SaveChangesAsync(ct);
            return Results.Accepted($"/api/v1/pharmacy/catalogue/products/{id}/governance",
                new LifecycleResponse(row.Id, row.RequestedAction, row.ReviewStatus, row.Reason,
                    row.RequestedAtUtc, row.RequestedBySubject));
        }).RequireAuthorization(writePolicy);

        return app;
    }

    private static bool IsHttpsOrNull(string? value) =>
        string.IsNullOrWhiteSpace(value) || (Uri.TryCreate(value, UriKind.Absolute, out var uri) && uri.Scheme == Uri.UriSchemeHttps);

    private static string Actor(ClaimsPrincipal user, bool localDevelopmentWrites) =>
        localDevelopmentWrites ? "local-development" :
        user.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? user.FindFirst("sub")?.Value ?? "unknown-subject";

    private static void AddAudit(AppDbContext db, string actor, string action, string resourceType,
        Guid resourceId, string? reason, string correlationId) =>
        db.CatalogueAuditEvents.Add(new CatalogueAuditEvent
        {
            Id = Guid.NewGuid(), ActorSubject = actor, Action = action, ResourceType = resourceType,
            ResourceId = resourceId, OccurredAtUtc = DateTimeOffset.UtcNow, Outcome = "Succeeded",
            Reason = string.IsNullOrWhiteSpace(reason) ? null : reason.Trim(), CorrelationId = correlationId
        });

    public sealed record FamilyInput(string FamilyCode, string? ChangeReason);
    public sealed record IdentifierInput(string SchemeCode, string Value, string? PackagingLevel, string? SourceUri, string? ChangeReason);
    public sealed record EvidenceInput(string AuthorityCode, string EvidenceType, string ReferenceNumber, string? DocumentUri,
        Guid? RegulatoryDocumentId, DateOnly? PublishedOn, DateOnly? EffectiveFrom, DateOnly? ExpiresOn, string? ChangeReason);
    public sealed record LifecycleInput(string RequestedAction, string Reason, string? ChangeReason);
    public sealed record FamilyResponse(Guid Id, string FamilyCode, string ReviewStatus, DateTimeOffset ProposedAtUtc, string ProposedBySubject);
    public sealed record IdentifierResponse(Guid Id, string SchemeCode, string Value, string? PackagingLevel, string VerificationStatus,
        string? SourceUri, DateTimeOffset CreatedAtUtc, string CreatedBySubject);
    public sealed record EvidenceResponse(Guid Id, string AuthorityCode, string EvidenceType, string ReferenceNumber,
        string? DocumentUri, Guid? RegulatoryDocumentId, DateOnly? PublishedOn, DateOnly? EffectiveFrom, DateOnly? ExpiresOn,
        string VerificationStatus, DateTimeOffset CreatedAtUtc, string CreatedBySubject);
    public sealed record LifecycleResponse(Guid Id, string RequestedAction, string ReviewStatus, string Reason,
        DateTimeOffset RequestedAtUtc, string RequestedBySubject);
    public sealed record GovernanceResponse(FamilyResponse? Family, IReadOnlyList<IdentifierResponse> Identifiers,
        IReadOnlyList<EvidenceResponse> Evidence, IReadOnlyList<LifecycleResponse> LifecycleRequests);
}
