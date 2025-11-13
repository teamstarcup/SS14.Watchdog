FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build

WORKDIR /build
ADD . .

RUN dotnet publish -c Release -r linux-x64 --no-self-contained

FROM mcr.microsoft.com/dotnet/sdk:9.0

# These are apparently required dependencies.
RUN apt update -y && \
    apt install -y git python3 python-is-python3

USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

COPY --chown=container:container --from=build /build/SS14.Watchdog/bin/Release/net9.0/linux-x64/publish /home/container

VOLUME ["/home/container"]

ENV DOTNET_ENVIRONMENT Production

ENTRYPOINT ["./SS14.Watchdog"]
