using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.EntityFrameworkCore;
using Sgsctr.Api.Data;

namespace Sgsctr.Api.PharmacySuppliers;

public static class PharmacySupplierAssuranceExtensions
{
    public static WebApplication MapPharmacySupplierAssuranceEndpoints(this WebApplication app)
    {
        var api = app.MapGroup("/api/v1/pharmacy/suppliers").RequireAuthorization();
        var authDisabledForLocalDevelopment = app.Environment.IsDevelopment() &&
            !app.Configuration.GetValue<bool>("Authentication:Enabled", true);
        var adminPolicy = new AuthorizationPolicyBuilder()
            .RequireAssertion(context => authDisabledForLocalDevelopment ||
                context.User.IsInRole("Administrator"))
            .Build();

        api.MapGet("/{id:guid}/assurance-cases", async Task<IResult> (Guid id, AppDbContext db, CancellationToken ct) =>
        {
            var exists = await db.PharmacySuppliers.AnyAsync(x => x.Id == id, ct);
            if (!exists) return Results.NotFound();
            return Results.Ok(await db.PharmacySupplierAssuranceCases.AsNoTracking()
                .Where(x => x.SupplierId == id)
                .OrderByDescending(x => x.RequestedAtUtc)
                .Select(x => new AssuranceCaseResponse(x.Id, x.CaseType, x.Status,
                    x.RequestedAtUtc, x.Reason, x.ScopeReference, x.EvidenceId,
                    x.BlockerCode, x.RequestedBySubject))
                .Take(200).ToListAsync(ct));
        }).RequireAuthorization(adminPolicy);

        api.MapPost("/{id:guid}/assurance-cases", async Task<IResult> (Guid id, AssuranceCaseInput input,
            ClaimsPrincipal user, AppDbContext db, HttpContext http, CancellationToken ct) =>
        {
            if (!SupplierAssuranceRules.IsValidRequest(input.CaseType, input.Reason, input.ScopeReference))
                return Results.ValidationProblem(new Dictionary<string, string[]>
                {
                    ["assuranceCase"] = ["Select a supported assurance workflow and provide a reason (max 500) and optional scope reference (max 200)."]
                });

            var supplier = await db.PharmacySuppliers.SingleOrDefaultAsync(x => x.Id == id, ct);
            if (supplier is null) return Results.NotFound();

            if (input.EvidenceId.HasValue &&
                !await db.PharmacySupplierEvidence.AnyAsync(x =>
                    x.Id == input.EvidenceId.Value && x.SupplierId == id, ct))
                return Results.ValidationProblem(new Dictionary<string, string[]>
                {
                    ["evidenceId"] = ["Evidence must exist and belong to this supplier."]
                });

            var actor = authDisabledForLocalDevelopment ? "local-development" :
                user.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? user.FindFirst("sub")?.Value;
            if (string.IsNullOrWhiteSpace(actor)) return Results.Forbid();

            var initial = SupplierAssuranceRules.InitialState(input.CaseType);
            var now = DateTimeOffset.UtcNow;
            var item = new PharmacySupplierAssuranceCase
            {
                Id = Guid.NewGuid(),
                SupplierId = id,
                CaseType = input.CaseType,
                Status = initial.Status,
                RequestedBySubject = actor,
                RequestedAtUtc = now,
                Reason = input.Reason.Trim(),
                ScopeReference = string.IsNullOrWhiteSpace(input.ScopeReference) ? null : input.ScopeReference.Trim(),
                EvidenceId = input.EvidenceId,
                BlockerCode = initial.BlockerCode,
                CorrelationId = http.TraceIdentifier
            };
            db.PharmacySupplierAssuranceCases.Add(item);
            db.CatalogueAuditEvents.Add(new CatalogueAuditEvent
            {
                Id = Guid.NewGuid(), ActorSubject = actor, Action = "SupplierAssuranceCaseCreated",
                ResourceType = "PharmacySupplierAssuranceCase", ResourceId = item.Id,
                OccurredAtUtc = now, Outcome = "Succeeded", Reason = item.Reason,
                CorrelationId = http.TraceIdentifier
            });
            await db.SaveChangesAsync(ct);
            return Results.Created($"/api/v1/pharmacy/suppliers/{id}/assurance-cases/{item.Id}",
                new AssuranceCaseResponse(item.Id, item.CaseType, item.Status, item.RequestedAtUtc,
                    item.Reason, item.ScopeReference, item.EvidenceId, item.BlockerCode, item.RequestedBySubject));
        }).RequireAuthorization(adminPolicy);

        return app;
    }

    public sealed record AssuranceCaseInput(string CaseType, string Reason,
        string? ScopeReference, Guid? EvidenceId);
    public sealed record AssuranceCaseResponse(Guid Id, string CaseType, string Status,
        DateTimeOffset RequestedAtUtc, string Reason, string? ScopeReference,
        Guid? EvidenceId, string? BlockerCode, string RequestedBySubject);
}
