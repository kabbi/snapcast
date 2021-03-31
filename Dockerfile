FROM rust:1.48.0-slim-buster

RUN apt update \
    && apt install -y git

WORKDIR /build

RUN git clone https://github.com/librespot-org/librespot.git \
    && cd librespot \
    && git checkout 6a4bc83259dd723dfecce073c363be84f31565d9 \
    && cargo build --release --no-default-features


FROM debian:buster-slim

ENV SNAPCAST_VERSION=0.24.0
ARG TARGETARCH
ARG TARGETVARIANT

RUN apt update \
    && apt install -y wget

RUN export DEB_FILENAME=snapserver_${SNAPCAST_VERSION}-1_$(dpkg --print-architecture).deb \
    && wget https://github.com/badaix/snapcast/releases/download/v${SNAPCAST_VERSION}/${DEB_FILENAME} \
    && apt install -y ./${DEB_FILENAME} \
    && rm ${DEB_FILENAME}

COPY --from=0 /build/librespot/target/release/librespot /usr/local/bin/librespot
