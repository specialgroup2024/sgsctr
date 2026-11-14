using Microsoft.EntityFrameworkCore;
using Sgsctr.Api.Data;

namespace Sgsctr.Api.PharmacyCatalogue;

public static class GovernanceApprovalEndpoints
{
    public static WebApplication MapGovernanceApprovalEndpoints(this WebApplication app)
    {
        app.MapGet("/api/v1/pharmacy/catalogue/approvals", async (AppDbContext db, CancellationToken ct) =>
        {
            var approvals = await db.GovernanceApprovals.AsNoTracking()
                .OrderBy(x => x.Status == "Pending" ? 0 : 1)
                .ThenBy(x => x.ApprovalCode)
                .Select(x => new ApprovalResponse(
                    x.Id, x.ApprovalCode, x.Title, x.RequiredApproverRole, x.Status,
                    x.ScopeDescription, x.EvidenceReference, x.CreatedAtUtc, x.UpdatedAtUtc,
                    x.DecisionAtUtc, x.DecisionBySubject, x.DecisionReference, x.DecisionNotes, x.Conditions))
                .ToListAsync(ct);
            return Results.Ok(approvals);
        }).RequireAuthorization();

        return app;
    }

    public sealed record ApprovalResponse(
        Guid Id,
        string ApprovalCode,
        string Title,
        string RequiredApproverRole,
        string Status,
        string ScopeDescription,
        string EvidenceReference,
        DateTimeOffset CreatedAtUtc,
        DateTimeOffset UpdatedAtUtc,
        DateTimeOffset? DecisionAtUtc,
        string? DecisionBySubject,
        string? DecisionReference,
        string? DecisionNotes,
        string? Conditions);
}
