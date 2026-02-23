#!/usr/bin/env bash
# Generate Swift gRPC client stubs from .proto files.
# Prerequisites: brew install swift-protobuf grpc-swift protobuf
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
OUT_DIR="$REPO_ROOT/generated/swift"

mkdir -p "$OUT_DIR"

PROTO_FILES=(
  services/auth_service.proto
  services/user_service.proto
  services/messaging_service.proto
  services/notification_service.proto
  services/invite_service.proto
  services/media_service.proto
  services/key_service.proto
  services/mls_service.proto
  services/sentinel_service.proto
  core/crypto.proto
  core/identity.proto
  core/envelope.proto
  core/pagination.proto
  messaging/content.proto
)

cd "$REPO_ROOT"

protoc \
  --swift_out=Visibility=Public:"$OUT_DIR" \
  --grpc-swift_out=Visibility=Public,Client=true,Server=false:"$OUT_DIR" \
  --proto_path=. \
  --proto_path="$REPO_ROOT" \
  "${PROTO_FILES[@]}"

echo "✅ Swift files generated in $OUT_DIR"
