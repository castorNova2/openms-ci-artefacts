
#!/bin/bash
set -e


VCPKG_CACHE_DIR="$HOME/.cache/vcpkg/archives"
TRIPLET="x64-linux"
REPO="https://github.com/castorNova2/openms-ci-artefacts"
RELEASE_TAG="vcpkg-cache-$TRIPLET"

if ! gh release view "$RELEASE_TAG" --repo "$REPO" &>/dev/null; then
    gh release create "$RELEASE_TAG" \
        --repo "$REPO" \
        --title "vcpkg cache ($TRIPLET)" \
        --notes " vcpkg cache for triplet $TRIPLET" \
        --prerelease
else
    echo "Release $RELEASE_TAG already exists"
fi

echo "Fetching already uploaded files"
UPLOADED=$(gh release view "$RELEASE_TAG" --repo "$REPO" --json assets --jq '.assets[].name')

COPIED=0
SKIPPED=0

find "$VCPKG_CACHE_DIR" -name "*.zip" | while read -r archive; do
    FILENAME=$(basename "$archive")
    SUBDIR=$(basename "$(dirname "$archive")")

    CAHCE_NAME="${SUBDIR}__${FILENAME}"

    if echo "$UPLOADED" | grep -q "^${CAHCE_NAME}$"; then
        SKIPPED=$((SKIPPED + 1))
        continue
    fi

    echo "==> Uploading $CAHCE_NAME..."
    gh release upload "$RELEASE_TAG" "$archive#$CAHCE_NAME" \
        --repo "$REPO" \
        --clobber

    COPIED=$((COPIED + 1))
done

echo "Upload complete"
EOF

chmod +x upload.sh