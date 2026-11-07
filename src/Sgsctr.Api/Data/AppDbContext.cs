using Microsoft.EntityFrameworkCore;

namespace Sgsctr.Api.Data;

/// <summary>No business entities or migrations are included in the foundation phase.</summary>
public sealed class AppDbContext(DbContextOptions<AppDbContext> options) : DbContext(options)
{
}
