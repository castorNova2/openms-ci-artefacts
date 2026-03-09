#!/bin/bash
set -e

REPO="castorNova2/openms-ci-artefacts"
RELEASE_TAG="vcpkg-cache-x64-linux"
CACHE_DIR="${HOME}/.cache/vcpkg/archives"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TMP_DIR="$SCRIPT_DIR/.vcpkg-cache-tmp"

mkdir -p "$TMP_DIR"

gh release download "$RELEASE_TAG" \
    --repo "$REPO" \
    --dir "$TMP_DIR" \
    --clobber

for f in "$TMP_DIR"/*.zip; do
    filename=$(basename "$f")     
    prefix="${filename:0:2}"     
    mkdir -p "$CACHE_DIR/$prefix"
    mv "$f" "$CACHE_DIR/$prefix/$filename"
done

rm -rf "$TMP_DIR"

echo "Done."