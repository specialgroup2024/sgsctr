using Microsoft.EntityFrameworkCore;
using Sgsctr.Api.Data;

namespace Sgsctr.Api.RegulatoryIntelligence;

public sealed class RegulatoryMonitorWorker(
    IServiceScopeFactory scopeFactory,
    ILogger<RegulatoryMonitorWorker> logger) : BackgroundService
{
    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        await RunCycleAsync(stoppingToken);
        using var timer = new PeriodicTimer(TimeSpan.FromMinutes(15));
        while (await timer.WaitForNextTickAsync(stoppingToken))
            await RunCycleAsync(stoppingToken);
    }

    private async Task RunCycleAsync(CancellationToken cancellationToken)
    {
        try
        {
            await using var scope = scopeFactory.CreateAsyncScope();
            var monitor = scope.ServiceProvider.GetRequiredService<IRegulatoryIngestionService>();
            var result = await monitor.RunAsync(false, cancellationToken);
            if (result.SourcesChecked > 0)
                logger.LogInformation("EDA regulatory scan completed: {Sources} sources, {Discovered} links, {NewDocuments} new documents, {Failures} failures.",
                    result.SourcesChecked, result.Discovered, result.NewDocuments, result.FailedSources);
        }
        catch (OperationCanceledException) when (cancellationToken.IsCancellationRequested) { }
        catch (Exception exception)
        {
            logger.LogError(exception, "Scheduled EDA regulatory monitoring cycle failed.");
        }
    }
}
