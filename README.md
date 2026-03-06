# node-optimized

Optimized Node.js binaries for Blue Canvas production workloads.

## Why

Inspired by [node-caged](https://github.com/platformatic/node-caged) ([blog post](https://blog.platformatic.dev/we-cut-nodejs-memory-in-half)). We needed binaries we could drop into our existing Alpine-based infrastructure.

## Optimizations

- **V8 Pointer Compression** - Reduces memory usage by ~40% on 64-bit systems

## Downloads

See [Releases](https://github.com/bluecanvas/node-optimized/releases).

**Requires Alpine ≥3.21** (musl libc forward-compatibility only)

## Usage

See [example.Dockerfile](example.Dockerfile) for a working example.

For auto-resolving the latest version at build time, see [example-latest.Dockerfile](example-latest.Dockerfile).

## Verifying Checksums

Each release includes `checksums.sha256`:

```bash
sha256sum -c checksums.sha256
```

## Building Locally

```bash
# Build for arm64 and amd64
make NODE_VERSION=v24.1.4

# Build and publish to GitHub
make release NODE_VERSION=v24.1.4
```
