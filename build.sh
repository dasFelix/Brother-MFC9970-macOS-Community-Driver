#!/bin/bash

set -e
run_pkgbuild()
{
    local stderr_file
    local status

    stderr_file=$(/usr/bin/mktemp /private/tmp/brother9970-pkgbuild.XXXXXX)

    if "$@" 2>"$stderr_file"; then
        status=0
    else
        status=$?
    fi

    /usr/bin/grep -v '^write: Permission denied$' "$stderr_file" >&2 || true
    /bin/rm -f "$stderr_file"

    return "$status"
}

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

VERSION="$(/bin/cat "$SCRIPT_DIR/VERSION")"

BUILD="$SCRIPT_DIR/build"
ROOT="$BUILD/root"

DEST="$ROOT/Library/Printers/CommunityProject/BrotherMFC9970"

OUT="$SCRIPT_DIR/Brother-MFC9970-Community-Driver-${VERSION}.pkg"

echo "Building Brother MFC-9970CDW Community-Project Driver v${VERSION}"
echo

/bin/rm -rf "$BUILD"
/bin/rm -f "$OUT"

/bin/mkdir -p "$DEST"

/usr/bin/install \
    -m 755 \
    "$SCRIPT_DIR/src/nativefilter" \
    "$DEST/nativefilter"

/usr/bin/install \
    -m 755 \
    "$SCRIPT_DIR/src/commandlevels-direct" \
    "$DEST/commandlevels-direct"

/usr/bin/install \
    -m 644 \
    "$SCRIPT_DIR/src/Brother-MFC9970-Community.ppd" \
    "$DEST/Brother-MFC9970-Community.ppd"

/usr/bin/xattr -cr "$ROOT"

run_pkgbuild /usr/bin/pkgbuild \
    --root "$ROOT" \
    --scripts "$SCRIPT_DIR/pkg/scripts" \
    --identifier "org.communityproject.brother.mfc9970.communitydriver" \
    --version "$VERSION" \
    --install-location "/" \
    --ownership recommended \
    "$OUT"

echo
echo "Build complete:"
echo "$OUT"
