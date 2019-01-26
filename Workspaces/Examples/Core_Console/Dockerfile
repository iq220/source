#Depending on the operating system of the host machines(s) that will build or run the containers, the image specified in the FROM statement may need to be changed.
#For more information, please see http://aka.ms/containercompat 

FROM microsoft/dotnet:2.1-runtime-nanoserver-1809 AS base
WORKDIR /app

FROM microsoft/dotnet:2.1-sdk-nanoserver-1809 AS build
WORKDIR /src
COPY Core_Console/Core_Console.csproj Core_Console/
RUN dotnet restore Core_Console/Core_Console.csproj
COPY . .
WORKDIR /src/Core_Console
RUN dotnet build Core_Console.csproj -c Release -o /app

FROM build AS publish
RUN dotnet publish Core_Console.csproj -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "Core_Console.dll"]
