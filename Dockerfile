FROM ubuntu:20.04

# RUN apk update && apk add gcc ca-certificates openssl musl-dev git fuse syslog-ng coreutils curl

ARG S6_ARCH="amd64"
 # renovate: datasource=github-tags depName=just-containers/s6-overlay versioning=loose
ARG S6_VERSION=v2.2.0.3

RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get -yq update \
 && apt-get -yq upgrade \
 && apt-get -yq install --no-install-recommends \
    apt-transport-https \
    gcc \
    openssl \
    ca-certificates \
    curl \
    coreutils \
    git \
    gnupg2 \
    musl-dev \
    fuse3 \
    fuse-overlayfs \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && echo "user_allow_other" >> /etc/fuse.conf

# ENV GOOFYS_VERSION 0.24.0
# RUN curl --fail -sSL -o /usr/local/bin/goofys https://github.com/kahing/goofys/releases/download/v${GOOFYS_VERSION}/goofys \
#     && chmod +x /usr/local/bin/goofys
COPY --chown=65534:0 goofys /usr/local/bin/

# install - s6 overlay
RUN export GNUPGHOME=/tmp/ \
 && curl -sL "https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-${S6_ARCH}-installer" -o /tmp/s6-overlay-${S6_VERSION}-installer \
 && curl -sL "https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-${S6_ARCH}-installer.sig" -o /tmp/s6-overlay-${S6_VERSION}-installer.sig \
 && gpg --keyserver keys.gnupg.net --keyserver pgp.surfnet.nl --recv-keys 6101B2783B2FD161 \
 && gpg -q --verify /tmp/s6-overlay-${S6_VERSION}-installer.sig /tmp/s6-overlay-${S6_VERSION}-installer \
 && chmod +x /tmp/s6-overlay-${S6_VERSION}-installer \
 && /tmp/s6-overlay-${S6_VERSION}-installer / \
 && rm /tmp/s6-overlay-${S6_VERSION}-installer.sig /tmp/s6-overlay-${S6_VERSION}-installer \
 && touch /etc/mtab \
 && chown -R 65534:0 /usr/local/bin \
 && chown -R 65534:0 /etc/s6 \
  && chown -R 65534:0 /etc/mtab

RUN curl -sSL -o /usr/local/bin/catfs https://github.com/kahing/catfs/releases/download/v0.8.0/catfs && chmod +x /usr/local/bin/catfs

# s6 - copy scripts
COPY --chown=65534:0 s6/ /etc

ENTRYPOINT ["/init"]
