ARG ALPINE_VERSION=3.20
ARG STARTUP_TIMEOUT=120

FROM alpine:${ALPINE_VERSION}

ARG STARTUP_TIMEOUT

RUN apk add \
        conntrack-tools \
        iproute2 \
        iptables \
        nftables \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk add \
        libecap \
        s6-overlay \
        skalibs-dev

#COPY --link --from=foo /usr/bin/bar /usr/bin/ # TODO

COPY /rootfs/ /

ENV STARTUP_TIMEOUT="$STARTUP_TIMEOUT"

ENTRYPOINT ["/entrypoint.sh"]

#EXPOSE 1234/tcp # TODO

#VOLUME # TODO

#HEALTHCHECK CMD nc -z # TODO
