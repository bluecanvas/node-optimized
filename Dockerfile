# Node.js with V8 pointer compression for Alpine
# Usage: docker build --build-arg NODE_VERSION=v24.1.4 -o out .
ARG NODE_VERSION=v24.1.4

FROM alpine:3.21 AS builder
ARG NODE_VERSION

RUN apk add --no-cache \
    build-base git python3 curl linux-headers openssl-dev ccache bash procps

WORKDIR /build
RUN git clone --depth 1 --branch ${NODE_VERSION} https://github.com/nodejs/node.git .

RUN ./configure \
    --experimental-enable-pointer-compression \
    --prefix=/usr/local

RUN make -j$(nproc)
RUN make install DESTDIR=/out

# Output stage - just the install directory
FROM scratch AS export
COPY --from=builder /out /
