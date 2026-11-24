#!/usr/bin/env bash
# Seed NuGet packages for offline Docker builds.
#
# Use on ANY machine with working internet + .NET 10 SDK (laptop, CI runner):
#   ./scripts/nuget-offline.sh            # restore + pack ./nuget-seed/ + nuget-seed.tar.gz
#
# Then copy the repo (or just the archive) to the build VM and unpack at root:
#   tar -xzf nuget-seed.tar.gz            # recreates ./nuget-seed/
#   docker compose up --build -d          # API restore now runs fully offline
#
# On a networked machine that also runs Docker, `--docker` does everything:
#   ./scripts/nuget-offline.sh --docker   # packs the image's own cache mount
set -euo pipefail
cd "$(dirname "$0")/.."

SEED_DIR="nuget-seed"

if [[ "${1:-}" == "--docker" ]]; then
  docker run --rm \
    -v "$PWD:/src" -w /src \
    --mount=type=volume,source=sgsctr_nuget_cache,target=/root/.nuget/packages \
    mcr.microsoft.com/dotnet/sdk:10.0 \
    sh -c 'dotnet restore src/Sgsctr.Api/Sgsctr.Api.csproj && rm -rf /src/nuget-seed && mkdir -p /src/nuget-seed && cp -a /root/.nuget/packages/. /src/nuget-seed/ && find /src/nuget-seed -name "*.nupkg" | sed "s|^/src/nuget-seed/||" > /src/nuget-seed/manifest.txt'
else
  command -v dotnet >/dev/null || { echo "error: dotnet SDK required (or use --docker on a machine with Docker)" >&2; exit 1; }
  PKGS="${NUGET_PACKAGES:-$HOME/.nuget/packages}"
  dotnet restore src/Sgsctr.Api/Sgsctr.Api.csproj
  rm -rf "$SEED_DIR"
  mkdir -p "$SEED_DIR"
  cp -a "$PKGS/." "$SEED_DIR/"
  find "$SEED_DIR" -name "*.nupkg" | sed "s|^$SEED_DIR/||" > "$SEED_DIR/manifest.txt"
fi

tar -czf nuget-seed.tar.gz "$SEED_DIR"
echo "Created $SEED_DIR/ and nuget-seed.tar.gz ($(wc -l < "$SEED_DIR/manifest.txt") packages)."
echo "Copy nuget-seed.tar.gz to the build VM, unpack with: tar -xzf nuget-seed.tar.gz"
echo "Then: docker compose up --build -d   (restore runs without internet)"
