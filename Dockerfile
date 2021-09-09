FROM ubuntu:20.04

# RUN apk update && apk add gcc ca-certificates openssl musl-dev git fuse syslog-ng coreutils curl

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

RUN curl -sSL -o /usr/local/bin/catfs https://github.com/kahing/catfs/releases/download/v0.8.0/catfs && chmod +x /usr/local/bin/catfs

COPY --chown=65534:0 rootfs/ /

ENTRYPOINT ["sh"]
CMD ["/usr/bin/run.sh"]
