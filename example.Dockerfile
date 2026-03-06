FROM alpine:3.21

# Required: Install runtime dependencies and node-optimized
RUN apk add --no-cache \
    ca-certificates \
    libssl3 \
    libstdc++ \
    libgcc \
    && wget -qO- https://github.com/bluecanvas/node-optimized/releases/download/v24.1.4/node-24.1.4-arm64.tar.gz \
    | tar xz -C /usr/local --strip-components=1

# Optional: Example app setup
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .

CMD ["node", "index.js"]
