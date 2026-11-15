using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.EntityFrameworkCore;
using Sgsctr.Api.Data;

namespace Sgsctr.Api.PharmacyCatalogue;

public static class GovernanceTestReadinessEndpoints
{
    public static WebApplication MapGovernanceTestReadinessEndpoints(this WebApplication app)
    {
        var api = app.MapGroup("/api/v1/pharmacy/catalogue/test-readiness").RequireAuthorization();

        api.MapGet("/", async (ClaimsPrincipal user, AppDbContext db, IHostEnvironment environment, CancellationToken ct) =>
        {
            var tests = await db.GovernanceTestCases.AsNoTracking()
                .OrderBy(x => x.GateCode).ThenBy(x => x.TestCode).ToListAsync(ct);
            var ids = tests.Select(x => x.Id).ToArray();
            var executions = await db.GovernanceTestExecutions.AsNoTracking()
                .Where(x => ids.Contains(x.TestCaseId))
                .OrderByDescending(x => x.ExecutedAtUtc)
                .ToListAsync(ct);
            var latest = executions.GroupBy(x => x.TestCaseId).ToDictionary(x => x.Key, x => x.First());

            return Results.Ok(new
            {
                canRecordResults = environment.IsDevelopment() && user.IsInRole("Administrator"),
                testCases = tests.Select(test => new
                {
                    test.Id, test.GateCode, test.TestCode, test.Title, test.Objective,
                    test.ExpectedResult, test.TestMode, test.ExecutionBlocked, test.BlockReason,
                    latestExecution = latest.TryGetValue(test.Id, out var result)
                        ? new TestExecutionResponse(result.Status, result.Environment, result.EvidenceReference,
                            result.Notes, result.ExecutedAtUtc, result.ExecutedBySubject)
                        : null
                })
            });
        });

        var administratorOnly = new AuthorizationPolicyBuilder().RequireRole("Administrator").Build();
        api.MapPost("/executions", async (
            TestExecutionInput input, ClaimsPrincipal user, AppDbContext db,
            IHostEnvironment environment, CancellationToken ct) =>
        {
            if (!environment.IsDevelopment()) return Results.NotFound();
            var test = await db.GovernanceTestCases.SingleOrDefaultAsync(x => x.Id == input.TestCaseId, ct);
            if (test is null) return Results.NotFound();

            var validation = GovernanceTestReadinessRules.Validate(
                test.ExecutionBlocked, input.Status, input.EvidenceReference, input.Notes);
            if (validation is not null) return Results.ValidationProblem(validation);

            var subject = user.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? user.FindFirst("sub")?.Value;
            if (string.IsNullOrWhiteSpace(subject)) return Results.Unauthorized();

            var execution = new GovernanceTestExecution
            {
                Id = Guid.NewGuid(),
                TestCaseId = test.Id,
                Status = input.Status,
                Environment = environment.EnvironmentName,
                EvidenceReference = string.IsNullOrWhiteSpace(input.EvidenceReference) ? null : input.EvidenceReference.Trim(),
                Notes = string.IsNullOrWhiteSpace(input.Notes) ? null : input.Notes.Trim(),
                ExecutedAtUtc = DateTimeOffset.UtcNow,
                ExecutedBySubject = subject
            };
            db.GovernanceTestExecutions.Add(execution);
            await db.SaveChangesAsync(ct);
            return Results.Created($"/api/v1/pharmacy/catalogue/test-readiness/{test.Id}",
                new TestExecutionResponse(execution.Status, execution.Environment, execution.EvidenceReference,
                    execution.Notes, execution.ExecutedAtUtc, execution.ExecutedBySubject));
        }).RequireAuthorization(administratorOnly);

        return app;
    }

    public sealed record TestExecutionInput(Guid TestCaseId, string Status, string? EvidenceReference, string? Notes);
    public sealed record TestExecutionResponse(
        string Status, string Environment, string? EvidenceReference, string? Notes,
        DateTimeOffset ExecutedAtUtc, string ExecutedBySubject);
}
