# brotli

Standalone build of [brotli](https://github.com/google/brotli) — Google's
general-purpose compressor.

[![CI](https://github.com/unpins/brotli/actions/workflows/brotli.yml/badge.svg)](https://github.com/unpins/brotli/actions)
![Linux](https://img.shields.io/badge/Linux-✓-success?logo=linux&logoColor=white)
![macOS](https://img.shields.io/badge/macOS-✓-success?logo=apple&logoColor=white)
![Windows](https://img.shields.io/badge/Windows-✓-success?logo=windows&logoColor=white)

Part of the [unpins](https://unpins.org) project — native single-binary builds with no third-party runtime dependencies.

## Installation

Install with [unpin](https://github.com/unpins/unpin):

```bash
unpin brotli
```

Or run without installing:

```bash
unpin run brotli
```

## Build locally

```bash
nix build github:unpins/brotli
./result/bin/brotli --version
```

Or run directly:

```bash
nix run github:unpins/brotli
```

The first invocation will offer to add the [unpins.cachix.org](https://unpins.cachix.org) substituter so most pulls come pre-built.

## Manual download

The [Releases](https://github.com/unpins/brotli/releases) page has standalone binaries for manual download.

## Build notes

- Single binary — `brotli` both compresses and (with `-d`) decompresses, so
  there is no multicall to assemble.
- **Windows** is built with mingw (not Cosmopolitan): brotli is portable CMake
  C with no Unix-only headers, so the cross compiles cleanly.
- The upstream install adds library reference pages under `man3`
  (`decode.h.3`, `encode.h.3`, …); those are dropped on every target (native in
  `postInstall`, Windows via a curated `winManRoot`) so only the CLI's
  `brotli.1` is embedded.

## Man pages

The `brotli` man page is embedded in the binary; read it with `unpin man brotli`.
