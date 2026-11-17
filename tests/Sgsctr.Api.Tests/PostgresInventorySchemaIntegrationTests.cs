using Microsoft.EntityFrameworkCore;
using Sgsctr.Api.Data;
using Testcontainers.PostgreSql;
using Xunit;

namespace Sgsctr.Api.Tests;

/// <summary>
/// PostgreSQL integration tests for the INV-03 stock movement ledger and INV-04 stock
/// transfer request schema. Each run starts a disposable PostgreSQL 18 container and
/// applies all migrations; the owner's configured database is never touched. Docker
/// must be available: when it is not, these tests fail with an explicit message
/// rather than silently passing.
/// </summary>
public sealed class PostgresInventorySchemaFixture : IAsyncLifetime
{
    private readonly PostgreSqlContainer _container = new PostgreSqlBuilder()
        .WithImage("postgres:18-alpine")
        .Build();

    public string ConnectionString { get; private set; } = string.Empty;

    public AppDbContext CreateContext() =>
        new(new DbContextOptionsBuilder<AppDbContext>()
            .UseNpgsql(ConnectionString)
            .Options);

    public async Task InitializeAsync()
    {
        try
        {
            await _container.StartAsync();
        }
        catch (Exception ex)
        {
            throw new InvalidOperationException(
                "PostgreSQL integration tests require an available Docker engine. " +
                "The disposable Testcontainers container could not be started.", ex);
        }

        ConnectionString = _container.GetConnectionString();
        await using var db = CreateContext();
        await db.Database.MigrateAsync();
    }

    public Task DisposeAsync() => _container.DisposeAsync().AsTask();
}

[CollectionDefinition("PostgresInventorySchema")]
public sealed class PostgresInventorySchemaCollection : ICollectionFixture<PostgresInventorySchemaFixture>;

[Collection("PostgresInventorySchema")]
public sealed class PostgresInventorySchemaIntegrationTests
{
    private readonly PostgresInventorySchemaFixture _fixture;

    public PostgresInventorySchemaIntegrationTests(PostgresInventorySchemaFixture fixture)
    {
        _fixture = fixture;
    }

    [Fact]
    public async Task Migrations_CreateCoreInventoryTables()
    {
        await using var db = _fixture.CreateContext();
        foreach (var table in new[] { "StockMovements", "StockTransferRequests", "StockTransferRequestLines" })
        {
            var count = await TableCount(db, table);
            Assert.Equal(1, count);
        }
    }

    [Fact]
    public async Task Migrations_CreateExpectedCheckConstraints()
    {
        await using var db = _fixture.CreateContext();
        foreach (var constraint in new[]
                 {
                     "CK_StockMovements_QuantityNonZero",
                     "CK_StockMovements_Status",
                     "CK_StockMovements_MovementType",
                     "CK_StockTransferRequests_Status",
                     "CK_StockTransferRequests_DifferentLocations",
                     "CK_StockTransferRequestLines_QuantityPositive"
                 })
        {
            var count = await db.Database.SqlQuery<long>($"""
                SELECT COUNT(*)::bigint AS "Value"
                FROM pg_constraint
                WHERE conname = {constraint} AND contype = 'c'
                """).SingleAsync();
            Assert.Equal(1, count);
        }
    }

    [Fact]
    public async Task StockTransferRequests_DatabaseRejectsSameSourceAndDestination()
    {
        await using var db = _fixture.CreateContext();
        var location = await SeedLocationAsync(db);
        db.StockTransferRequests.Add(TransferRequest(location.Id, location.Id));
        await Assert.ThrowsAsync<DbUpdateException>(() => db.SaveChangesAsync());
    }

    [Fact]
    public async Task StockTransferRequests_DatabaseRejectsUnknownStatus()
    {
        await using var db = _fixture.CreateContext();
        var (source, destination) = await SeedTwoLocationsAsync(db);
        var request = TransferRequest(source.Id, destination.Id);
        request.Status = "Posted";
        db.StockTransferRequests.Add(request);
        await Assert.ThrowsAsync<DbUpdateException>(() => db.SaveChangesAsync());
    }

    [Fact]
    public async Task StockTransferRequestLines_DatabaseRejectsNonPositiveQuantity()
    {
        await using var db = _fixture.CreateContext();
        var (source, destination) = await SeedTwoLocationsAsync(db);
        var (product, unit) = await SeedProductAndUnitAsync(db);
        var request = TransferRequest(source.Id, destination.Id);
        request.Lines.Add(new StockTransferRequestLine
        {
            Id = Guid.NewGuid(), ProductId = product.Id, UnitId = unit.Id, Quantity = 0m
        });
        db.StockTransferRequests.Add(request);
        await Assert.ThrowsAsync<DbUpdateException>(() => db.SaveChangesAsync());
    }

    [Fact]
    public async Task StockMovements_DatabaseRejectsZeroQuantity()
    {
        await using var db = _fixture.CreateContext();
        var location = await SeedLocationAsync(db);
        var (product, unit) = await SeedProductAndUnitAsync(db);
        db.StockMovements.Add(Movement(location.Id, product.Id, unit.Id, quantity: 0m));
        await Assert.ThrowsAsync<DbUpdateException>(() => db.SaveChangesAsync());
    }

    [Fact]
    public async Task StockMovements_DatabaseRejectsUnknownMovementType()
    {
        await using var db = _fixture.CreateContext();
        var location = await SeedLocationAsync(db);
        var (product, unit) = await SeedProductAndUnitAsync(db);
        var movement = Movement(location.Id, product.Id, unit.Id, quantity: 5m);
        movement.MovementType = "Purchase";
        db.StockMovements.Add(movement);
        await Assert.ThrowsAsync<DbUpdateException>(() => db.SaveChangesAsync());
    }

    [Fact]
    public async Task StockMovements_ReferencedLocationDeleteIsRestrictedByDatabase()
    {
        await using var writer = _fixture.CreateContext();
        var location = await SeedLocationAsync(writer);
        var (product, unit) = await SeedProductAndUnitAsync(writer);
        writer.StockMovements.Add(Movement(location.Id, product.Id, unit.Id, quantity: 3m));
        await writer.SaveChangesAsync();

        // A context that does not track the movement lets the delete reach the
        // database, where the restrict foreign key must reject it.
        await using var deleter = _fixture.CreateContext();
        var trackedLocation = await deleter.OrganizationLocations.SingleAsync(x => x.Id == location.Id);
        deleter.OrganizationLocations.Remove(trackedLocation);
        await Assert.ThrowsAsync<DbUpdateException>(() => deleter.SaveChangesAsync());
    }

    [Fact]
    public async Task StockTransferRequestLines_DeleteWithRequestByCascade()
    {
        await using var writer = _fixture.CreateContext();
        var (source, destination) = await SeedTwoLocationsAsync(writer);
        var (product, unit) = await SeedProductAndUnitAsync(writer);
        var request = TransferRequest(source.Id, destination.Id);
        request.Lines.Add(new StockTransferRequestLine
        {
            Id = Guid.NewGuid(), ProductId = product.Id, UnitId = unit.Id, Quantity = 4m
        });
        writer.StockTransferRequests.Add(request);
        await writer.SaveChangesAsync();

        // A context that does not track the lines relies on the database cascade.
        await using var deleter = _fixture.CreateContext();
        var trackedRequest = await deleter.StockTransferRequests.SingleAsync(x => x.Id == request.Id);
        deleter.StockTransferRequests.Remove(trackedRequest);
        await deleter.SaveChangesAsync();

        await using var verify = _fixture.CreateContext();
        var remainingLines = await verify.StockTransferRequestLines
            .CountAsync(line => line.StockTransferRequestId == request.Id);
        var remainingRequests = await verify.StockTransferRequests
            .CountAsync(row => row.Id == request.Id);
        Assert.Equal(0, remainingLines);
        Assert.Equal(0, remainingRequests);
    }

    private static async Task<long> TableCount(AppDbContext db, string tableName) =>
        await db.Database.SqlQuery<long>($"""
            SELECT COUNT(*)::bigint AS "Value"
            FROM information_schema.tables
            WHERE table_schema = 'public' AND table_name = {tableName}
            """).SingleAsync();

    private static async Task<OrganizationLocation> SeedLocationAsync(AppDbContext db)
    {
        var suffix = Guid.NewGuid().ToString("N")[..10];
        var location = new OrganizationLocation
        {
            Id = Guid.NewGuid(),
            Code = "IT" + suffix,
            Name = "Integration synthetic location",
            SectorCode = "PHARMACIES",
            LocationType = "Branch",
            RecordStatus = "OwnerProvided",
            IsActive = true,
            CreatedAtUtc = DateTimeOffset.UtcNow,
            UpdatedAtUtc = DateTimeOffset.UtcNow
        };
        db.OrganizationLocations.Add(location);
        await db.SaveChangesAsync();
        return location;
    }

    private static async Task<(OrganizationLocation Source, OrganizationLocation Destination)> SeedTwoLocationsAsync(AppDbContext db)
    {
        var source = await SeedLocationAsync(db);
        var destination = await SeedLocationAsync(db);
        return (source, destination);
    }

    private static async Task<(CatalogueProduct Product, UnitOfMeasure Unit)> SeedProductAndUnitAsync(AppDbContext db)
    {
        var suffix = Guid.NewGuid().ToString("N")[..10];
        var product = new CatalogueProduct
        {
            Id = Guid.NewGuid(),
            DisplayName = "Integration synthetic product",
            Status = "Draft",
            CreatedBySubject = "integration-test",
            UpdatedBySubject = "integration-test",
            CreatedAtUtc = DateTimeOffset.UtcNow,
            UpdatedAtUtc = DateTimeOffset.UtcNow
        };
        var unit = new UnitOfMeasure
        {
            Id = Guid.NewGuid(),
            Code = "IU" + suffix,
            Name = "Integration synthetic unit",
            CreatedBySubject = "integration-test"
        };
        db.CatalogueProducts.Add(product);
        db.UnitsOfMeasure.Add(unit);
        await db.SaveChangesAsync();
        return (product, unit);
    }

    private static StockTransferRequest TransferRequest(Guid sourceLocationId, Guid destinationLocationId) => new()
    {
        Id = Guid.NewGuid(),
        SourceLocationId = sourceLocationId,
        DestinationLocationId = destinationLocationId,
        Status = "Draft",
        RequestedBySubject = "integration-test",
        UpdatedBySubject = "integration-test",
        RequestedAtUtc = DateTimeOffset.UtcNow,
        UpdatedAtUtc = DateTimeOffset.UtcNow
    };

    private static StockMovement Movement(Guid locationId, Guid productId, Guid unitId, decimal quantity) => new()
    {
        Id = Guid.NewGuid(),
        LocationId = locationId,
        ProductId = productId,
        UnitId = unitId,
        Quantity = quantity,
        MovementType = "Receipt",
        Reason = "Integration synthetic movement",
        Status = "Draft",
        CreatedBySubject = "integration-test",
        CreatedAtUtc = DateTimeOffset.UtcNow
    };
}
