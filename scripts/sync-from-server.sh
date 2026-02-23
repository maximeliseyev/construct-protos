#!/usr/bin/env bash
# Sync .proto files from a local construct-server checkout.
# Usage: ./scripts/sync-from-server.sh /path/to/construct-server
set -euo pipefail

SERVER_DIR="${1:-}"
if [[ -z "$SERVER_DIR" ]]; then
  echo "Usage: $0 /path/to/construct-server" >&2
  exit 1
fi

PROTO_SRC="$SERVER_DIR/shared/proto"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

if [[ ! -d "$PROTO_SRC" ]]; then
  echo "Error: $PROTO_SRC does not exist" >&2
  exit 1
fi

for dir in core messaging services signaling; do
  if [[ -d "$PROTO_SRC/$dir" ]]; then
    mkdir -p "$REPO_ROOT/$dir"
    cp "$PROTO_SRC/$dir/"*.proto "$REPO_ROOT/$dir/"
    echo "  synced: $dir/"
  fi
done

if [[ -f "$PROTO_SRC/buf.yaml" ]]; then
  cp "$PROTO_SRC/buf.yaml" "$REPO_ROOT/"
  echo "  synced: buf.yaml"
fi

echo "✅ Sync complete. Review changes with: git diff"
