#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["Pet.Project.Cart.Api/Pet.Project.Cart.Api.csproj", "Pet.Project.Cart.Api/"]
COPY ["Pet.Project.Cart.Domain/Pet.Project.Cart.Domain.csproj", "Pet.Project.Cart.Domain/"]
COPY ["Pet.Project.Cart.Infraestructure/Pet.Project.Cart.Infraestructure.csproj", "Pet.Project.Cart.Infraestructure/"]
RUN dotnet restore "Pet.Project.Cart.Api/Pet.Project.Cart.Api.csproj"
COPY . .
WORKDIR "/src/Pet.Project.Cart.Api"
RUN dotnet build "Pet.Project.Cart.Api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Pet.Project.Cart.Api.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Pet.Project.Cart.Api.dll"]