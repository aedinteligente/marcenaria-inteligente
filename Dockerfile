FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY marcenaria-inteligente-app.tar.gz /tmp/marcenaria-inteligente-app.tar.gz
RUN mkdir -p /src/app && tar -xzf /tmp/marcenaria-inteligente-app.tar.gz -C /src/app
WORKDIR /src/app/src/MarcenariaInteligente.CloudApi
RUN dotnet restore && dotnet publish -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish ./
ENV ASPNETCORE_URLS=http://0.0.0.0:8080
EXPOSE 8080
ENTRYPOINT ["sh", "-c", "ASPNETCORE_URLS=http://0.0.0.0:${PORT:-8080} dotnet MarcenariaInteligente.CloudApi.dll"]
