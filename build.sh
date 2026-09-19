#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VERSION="$(/usr/bin/tr -d '\r\n' < "$SCRIPT_DIR/VERSION")"

BUILD="$SCRIPT_DIR/build"
ROOT="$BUILD/root"
PKGDIR="$BUILD/packages"
RESOURCES="$BUILD/resources"

DEST="$ROOT/Library/Printers/CommunityProject/BrotherMFC9970"

COMPONENT="$PKGDIR/Brother-MFC9970-macOS-Community-Driver-component.pkg"
DISTRIBUTION="$BUILD/Distribution.xml"

OUT="$SCRIPT_DIR/Brother-MFC9970-macOS-Community-Driver-${VERSION}.pkg"

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

render()
{
    /usr/bin/sed "s/__VERSION__/${VERSION}/g" "$1" > "$2"
}

echo
echo "Building Brother MFC-9970CDW macOS Community Driver v${VERSION}"
echo

/bin/rm -rf "$BUILD"
/bin/rm -f "$OUT"

/bin/mkdir -p "$DEST"
/bin/mkdir -p "$PKGDIR"
/bin/mkdir -p "$RESOURCES"

echo "[1/6] Installing driver payload..."

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

echo "[2/6] Preparing Installer resources..."

render \
    "$SCRIPT_DIR/pkg/resources/welcome.html" \
    "$RESOURCES/welcome.html"

render \
    "$SCRIPT_DIR/pkg/resources/readme.html" \
    "$RESOURCES/readme.html"

render \
    "$SCRIPT_DIR/pkg/resources/conclusion.html" \
    "$RESOURCES/conclusion.html"

/bin/cp \
    "$SCRIPT_DIR/LICENSE" \
    "$RESOURCES/LICENSE.txt"

render \
    "$SCRIPT_DIR/pkg/Distribution.xml.in" \
    "$DISTRIBUTION"

echo "[3/6] Removing extended attributes..."

/usr/bin/xattr -cr "$ROOT" 2>/dev/null || true
/usr/bin/xattr -cr "$RESOURCES" 2>/dev/null || true
/usr/bin/xattr -cr "$SCRIPT_DIR/pkg/scripts" 2>/dev/null || true

echo "[4/6] Building component package..."

run_pkgbuild /usr/bin/pkgbuild \
    --root "$ROOT" \
    --scripts "$SCRIPT_DIR/pkg/scripts" \
    --identifier "org.communityproject.brother.mfc9970.communitydriver" \
    --version "$VERSION" \
    --install-location "/" \
    --ownership recommended \
    "$COMPONENT"

echo "[5/6] Building macOS Distribution package..."

/usr/bin/productbuild \
    --distribution "$DISTRIBUTION" \
    --resources "$RESOURCES" \
    --package-path "$PKGDIR" \
    "$OUT"

echo "[6/6] Build complete."

echo
echo "Package:"
echo "$OUT"
echo
