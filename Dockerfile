### Se hizo el poc para comprobar que todo funcionara como debería y así se dio, se creo un aplicativo sencillo que utilizaba recursos de AWS.

# Primera etapa: configuración base
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
USER $APP_UID

# Segunda etapa: construcción
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copiamos y restauramos el proyecto (esto necesita permisos root)
COPY ["src/MocWebApi/*.csproj", "./"]
RUN dotnet restore

# Copiamos todo el código fuente
COPY ["src/MocWebApi/", "./"]
RUN dotnet build "MocWebApi.csproj" -c Release -o /app/build

# Tercera etapa: publicación
FROM build AS publish
RUN dotnet publish "MocWebApi.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Etapa final: usando la configuración base
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

ENV ASPNETCORE_URLS=http://+:80
EXPOSE 80
ENTRYPOINT ["dotnet", "MocWebApi.dll"]