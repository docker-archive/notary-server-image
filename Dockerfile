# Build a notary-server container without the build environment

FROM ubuntu:14.04

RUN apt-get update && \
    apt-get install -y ca-certificates && \
    rm -rf /var/lib/apt/lists/*

COPY ./notary-server/notary-server /bin/notary-server
COPY ./notary-server/config.json /etc/docker/notary-server/config.json
COPY ./notary-server/fixtures /fixtures

EXPOSE 4443
ENTRYPOINT ["/bin/notary-server"]
CMD ["-config", "/etc/docker/notary-server/config.json"]
