# syntax=docker/dockerfile:1
# Optional offline seed stage. The tracked nuget-seed/.gitkeep keeps the
# directory in clean Git checkouts; a real offline seed replaces/adds a
# non-empty manifest.txt and package cache files. Without that manifest,
# restore falls back to the configured NuGet feed.
FROM scratch AS seed
COPY nuget-seed/ /

FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src
# NuGet's enhanced retry policy helps with transient feed/network failures, but
# keep the total bounded so an unreachable api.nuget.org (NU1301) fails fast and
# clearly instead of stalling the whole compose build for many minutes.
ENV NUGET_ENHANCED_MAX_NETWORK_TRY_COUNT=4 \
    NUGET_ENHANCED_NETWORK_RETRY_DELAY_MILLISECONDS=2000
COPY global.json ./
COPY Directory.Packages.props ./
COPY nuget.config ./
COPY scripts/nuget-offline.sh scripts/nuget-offline.sh
COPY src/Sgsctr.Api/Sgsctr.Api.csproj src/Sgsctr.Api/
# Offline-first strategy: this VM's Docker containers may not resolve/route
# external hostnames, while image downloads via the daemon still work. Consume
# a pre-seeded NuGet package cache when supplied; otherwise use live restore.
ARG NUGET_PACKAGES=/root/.nuget/packages
ENV NUGET_PACKAGES=$NUGET_PACKAGES
# BuildKit cache mount persists downloaded packages across builds, so once a
# restore succeeds (from the seed or from the network) later rebuilds can reuse
# packages without contacting api.nuget.org again.
RUN --mount=type=bind,from=seed,target=/seed,ro=true \
    --mount=type=cache,target=/root/.nuget/packages \
    set -eu; \
    if [ -s /seed/manifest.txt ]; then \
      find /seed -mindepth 1 -maxdepth 1 ! -name .gitkeep ! -name manifest.txt \
        -exec cp -a {} "$NUGET_PACKAGES"/ \\; ; \
      echo "Restored NuGet packages from offline seed ($(wc -l < /seed/manifest.txt) nupkgs)."; \
    else \
      echo "No populated ./nuget-seed/ found; falling back to live restore."; \
      echo "If this fails with NU1301, run scripts/nuget-offline.sh on a networked machine,"; \
      echo "copy nuget-seed.tar.gz here and unpack it at the repo root before building."; \
    fi; \
    dotnet restore src/Sgsctr.Api/Sgsctr.Api.csproj
COPY src/Sgsctr.Api/ src/Sgsctr.Api/
RUN --mount=type=cache,target=/root/.nuget/packages \
    dotnet publish src/Sgsctr.Api/Sgsctr.Api.csproj --configuration Release --output /app/publish --no-restore /p:UseAppHost=false
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
WORKDIR /app
# No apt here: the aspnet 10 image already ships curl (used by the compose
# healthcheck), and deb.debian.org is unreachable from containers on this
# network (same DNS issue as NuGet) — installing it would only stall builds.
ENV ASPNETCORE_HTTP_PORTS=8080
RUN mkdir -p /var/lib/sgsctr/data-protection-keys && chown -R $APP_UID:$APP_UID /var/lib/sgsctr
COPY --from=build /app/publish .
USER $APP_UID
EXPOSE 8080
ENTRYPOINT ["dotnet", "Sgsctr.Api.dll"]
