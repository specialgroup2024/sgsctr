FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src
COPY global.json ./
COPY Directory.Packages.props ./
COPY src/Sgsctr.Api/Sgsctr.Api.csproj src/Sgsctr.Api/
RUN dotnet restore src/Sgsctr.Api/Sgsctr.Api.csproj
COPY src/Sgsctr.Api/ src/Sgsctr.Api/
RUN dotnet publish src/Sgsctr.Api/Sgsctr.Api.csproj --configuration Release --output /app/publish --no-restore /p:UseAppHost=false
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
WORKDIR /app
ENV ASPNETCORE_HTTP_PORTS=8080
RUN mkdir -p /var/lib/sgsctr/data-protection-keys && chown -R $APP_UID:$APP_UID /var/lib/sgsctr
COPY --from=build /app/publish .
USER $APP_UID
EXPOSE 8080
ENTRYPOINT ["dotnet", "Sgsctr.Api.dll"]
