# syntax=docker/dockerfile:1
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
COPY src/Sgsctr.Api/Sgsctr.Api.csproj src/Sgsctr.Api/
# Hostile DNS workaround: if the container resolver returns IPv6 (AAAA) records
# that cannot actually connect, NuGet reports NU1301 "Resource temporarily
# unavailable" while plain curl still works. Force dual-stack feeds to IPv4.
RUN printf 'Acquire::ForceIPv4 "true";\n' > /etc/apt/apt.conf.d/90forceipv4
# Pre-flight check: fail in seconds with a clear message instead of letting
# dotnet retry against a dead network for minutes.
RUN --mount=type=cache,target=/root/.nuget/packages \
    set -eux; \
    if ! getent ahostsv4 api.nuget.org >/dev/null 2>&1; then \
      echo "ERROR: DNS inside the build container cannot resolve api.nuget.org." >&2; \
      echo "Fix Docker DNS: add \"dns\": [\"1.1.1.1\", \"8.8.8.8\"] to /etc/docker/daemon.json," >&2; \
      echo "then run: sudo systemctl restart docker" >&2; \
      exit 1; \
    fi; \
    if ! curl -fsS --ipv4 --connect-timeout 10 --max-time 30 -o /dev/null https://api.nuget.org/v3/index.json; then \
      echo "ERROR: build container cannot reach https://api.nuget.org over IPv4." >&2; \
      echo "Check host connectivity/proxy first: curl -fsSI https://api.nuget.org/v3/index.json" >&2; \
      echo "If the host needs a proxy, export HTTPS_PROXY and rerun: sudo -E docker compose up --build -d" >&2; \
      exit 1; \
    fi
# BuildKit cache mount persists downloaded packages across builds, so once a
# restore succeeds even a later offline rebuild works, and transient registry
# outages do not force re-downloading every package on each "compose up --build".
RUN --mount=type=cache,target=/root/.nuget/packages \
    dotnet restore src/Sgsctr.Api/Sgsctr.Api.csproj
COPY src/Sgsctr.Api/ src/Sgsctr.Api/
RUN --mount=type=cache,target=/root/.nuget/packages \
    dotnet publish src/Sgsctr.Api/Sgsctr.Api.csproj --configuration Release --output /app/publish --no-restore /p:UseAppHost=false
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
WORKDIR /app
RUN apt-get update && apt-get install -y --no-install-recommends curl && rm -rf /var/lib/apt/lists/*
ENV ASPNETCORE_HTTP_PORTS=8080
RUN mkdir -p /var/lib/sgsctr/data-protection-keys && chown -R $APP_UID:$APP_UID /var/lib/sgsctr
COPY --from=build /app/publish .
USER $APP_UID
EXPOSE 8080
ENTRYPOINT ["dotnet", "Sgsctr.Api.dll"]
