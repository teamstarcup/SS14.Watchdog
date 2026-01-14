FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build

WORKDIR /build
ADD . .

RUN dotnet publish -c Release -r linux-x64 --no-self-contained

FROM mcr.microsoft.com/dotnet/sdk:9.0

RUN apt update -y && \
    apt install -y git python3 python-is-python3 iproute2 tini net-tools

RUN useradd -m -d /home/container -s /bin/bash container
USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

COPY --chown=container:container --from=build /build/SS14.Watchdog/bin/Release/net9.0/linux-x64/publish /

ENV DOTNET_ENVIRONMENT=Production

ENTRYPOINT ["/usr/bin/tini", "-g", "--"]
CMD ["/SS14.Watchdog"]

STOPSIGNAL SIGINT
