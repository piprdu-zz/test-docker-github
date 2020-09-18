FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-alpine AS base
WORKDIR /app
EXPOSE 5000

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-alpine AS build
WORKDIR /src
COPY ["test-docker-github.csproj", "./"]
RUN dotnet restore "test-docker-github.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "test-docker-github.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "test-docker-github.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "test-docker-github.dll"]
