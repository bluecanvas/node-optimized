FROM alpine:3.21

ARG NODE_VERSION=24.1.4

# Required: Install runtime dependencies and node-optimized
RUN apk add --no-cache \
    ca-certificates \
    libssl3 \
    libstdc++ \
    libgcc \
    && ARCH=$(uname -m | sed 's/x86_64/x64/; s/aarch64/arm64/') \
    && wget -qO- https://github.com/bluecanvas/node-optimized/releases/download/v${NODE_VERSION}/node-${NODE_VERSION}-${ARCH}.tar.gz \
    | tar xz -C /usr/local --strip-components=1

# Optional: Example app setup
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .

CMD ["node", "index.js"]
