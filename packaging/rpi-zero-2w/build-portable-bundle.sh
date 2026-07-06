#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
OUTPUT_DIR="$REPO_ROOT/dist/rpi-zero-2w"

mkdir -p "$OUTPUT_DIR"

docker buildx build \
  --platform linux/arm64 \
  -f "$SCRIPT_DIR/Dockerfile.bundle" \
  --output "type=local,dest=$OUTPUT_DIR" \
  "$REPO_ROOT"

echo "Raspberry Pi Zero 2W portable bundle written to $OUTPUT_DIR"
