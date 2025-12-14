# ---- build ----
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src
COPY . .
RUN dotnet publish -c Release -o /out

# ---- runtime ----
FROM mcr.microsoft.com/dotnet/aspnet:9.0

# Inyección Dynatrace OneAgent code modules (application-only)
# (Dynatrace: "COPY --from=<environmentURL>/linux/oneagent-codemodules:<TECHNOLOGY> / /" + LD_PRELOAD) :contentReference[oaicite:3]{index=3}
COPY --from=hra98375.live.dynatrace.com/linux/oneagent-codemodules:dotnet / /
ENV LD_PRELOAD=/opt/dynatrace/oneagent/agent/lib64/liboneagentproc.so

WORKDIR /app
COPY --from=build /out .

EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080
ENTRYPOINT ["dotnet", "PocApi.dll"]
