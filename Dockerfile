FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src
# NuGet's enhanced retry policy helps with transient feed/network failures, but
# keep the total bounded so an unreachable api.nuget.org (NU1301) fails fast and
# clearly instead of stalling the whole compose build for many minutes.
ENV NUGET_ENHANCED_MAX_NETWORK_TRY_COUNT=4 \
    NUGET_ENHANCED_NETWORK_RETRY_DELAY_MILLISECONDS=2000
COPY global.json ./
COPY Directory.Packages.props ./
COPY src/Sgsctr.Api/Sgsctr.Api.csproj src/Sgsctr.Api/
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
