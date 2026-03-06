# node-optimized

Optimized Node.js binaries for Blue Canvas production workloads.

## Why

Inspired by [node-caged](https://github.com/bengl/node-caged). We needed binaries we could drop into our existing Alpine-based infrastructure.

## Optimizations

- **V8 Pointer Compression** - Reduces memory usage by ~40% on 64-bit systems

## Downloads

See [Releases](https://github.com/bluecanvas/node-optimized/releases).

**Requires Alpine ≥3.21** (musl libc forward-compatibility only)

## Usage

See [example.Dockerfile](example.Dockerfile) for a working example.

## Verifying Checksums

Each release includes `checksums.sha256`:

```bash
sha256sum -c checksums.sha256
```
