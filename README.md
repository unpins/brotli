# brotli

[brotli](https://github.com/google/brotli) — Google's general-purpose compressor. A single self-contained binary, built natively for Linux, macOS, and Windows.

[![CI](https://github.com/unpins/brotli/actions/workflows/brotli.yml/badge.svg)](https://github.com/unpins/brotli/actions)
![Linux](https://img.shields.io/badge/Linux-✓-success?logo=linux&logoColor=white)
![macOS](https://img.shields.io/badge/macOS-✓-success?logo=apple&logoColor=white)
![Windows](https://img.shields.io/badge/Windows-✓-success?logo=windows&logoColor=white)

Part of the [unpins](https://unpins.org) catalog; install it with [`unpin`](https://github.com/unpins/unpin): `unpin install brotli`.

## Usage

Run the `brotli` program with [unpin](https://github.com/unpins/unpin):

```bash
unpin brotli file          # compress   -> file.br
unpin brotli -d file.br    # decompress
```

To install it onto your PATH:

```bash
unpin install brotli
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

- **Platforms:** Linux, macOS, Windows.
- **Single binary:** `brotli` both compresses and (with `-d`) decompresses, so there is no multicall to assemble.
- **Tests:** brotli's own ctest roundtrip suite runs on every build the runner can execute (12/12 under static-musl). The crosses it cannot run are covered by the `--version` smoke only.
- **Man pages:** the `brotli.1` page is embedded; read it with `unpin man brotli`. The `libbrotli` C API pages (`decode.h.3`, `encode.h.3`, …) are not — this binary ships the program, not a linkable library.

