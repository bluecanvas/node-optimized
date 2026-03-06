FROM alpine:3.21

ARG NODE_MAJOR=24

# Resolve latest version and install
RUN apk add --no-cache \
    ca-certificates \
    libssl3 \
    libstdc++ \
    libgcc \
    && VERSION=$(wget -qO- https://api.github.com/repos/bluecanvas/node-optimized/releases \
        | grep -oE '"tag_name":\s*"v'${NODE_MAJOR}'\.[^"]+' \
        | head -1 \
        | grep -oE 'v[0-9.]+') \
    && ARCH=$(uname -m | sed 's/aarch64/arm64/' | sed 's/x86_64/amd64/') \
    && wget -qO- https://github.com/bluecanvas/node-optimized/releases/download/${VERSION}/node-${VERSION#v}-${ARCH}.tar.gz \
    | tar xz -C /usr/local

# Optional: Example app setup
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .

CMD ["node", "index.js"]
