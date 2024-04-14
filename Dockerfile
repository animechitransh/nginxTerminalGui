# https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-build
# https://stackoverflow.com/questions/75273749/how-can-one-dockerize-a-terminal-gui-application-to-run-on-linux
# https://anuraj.dev/blog/how-to-nginx-reverse-proxy-with-docker-compose/
# https://github.com/gui-cs/Terminal.Gui/blob/develop/Showcase.md

FROM mcr.microsoft.com/dotnet/runtime:6.0.28-bookworm-slim-amd64  AS base
WORKDIR /app
RUN apt-get update -y
RUN apt-get install -y libncursesw6 nginx

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

COPY /src /app/
WORKDIR /app

RUN dotnet restore "nginxGui.sln"
# RUN dotnet build "nginxGui.sln" -c Release  -o /app/build -r linux-x64 --self-contained
RUN dotnet publish -c release -o /app/publish -r linux-x64 --self-contained

FROM base AS final
COPY --from=build /app/publish /app/

RUN cd /app/
WORKDIR /app/
# ENTRYPOINT ["./nginxManager"]

# https://stackoverflow.com/questions/26351608/nginx-change-config-location
# https://docs.nginx.com/nginx/deployment-guides/setting-up-nginx-demo-environment/