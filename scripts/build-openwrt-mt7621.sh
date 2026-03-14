#!/usr/bin/env bash
set -euo pipefail

# Build UA3F binary for OpenWrt ramips/mt7621 (mipsel_24kc)
# Usage: ./scripts/build-openwrt-mt7621.sh [output_path]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SRC_DIR="$ROOT_DIR/src"

VERSION="$(sed -n 's/^release_version="\([^"]*\)"/\1/p' "$SCRIPT_DIR/build.sh" | head -n1)"
VERSION="${VERSION:-dev}"
OUT_DEFAULT="$ROOT_DIR/dist/ua3f-${VERSION}-linux-mipsel_24kc"
OUT_PATH="${1:-$OUT_DEFAULT}"

mkdir -p "$(dirname "$OUT_PATH")"

cd "$SRC_DIR"
CGO_ENABLED=0 GOOS=linux GOARCH=mipsle GOMIPS=softfloat \
  go build -trimpath -ldflags="-s -w" -o "$OUT_PATH" main.go

echo "Built: $OUT_PATH"
if command -v file >/dev/null 2>&1; then
  file "$OUT_PATH"
fi
