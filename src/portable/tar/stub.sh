#/bin/sh

# Self-extracting script for tar !TAR_VERSION!.
# Packaged by Konstantin Kushnir <chpock@gmail.com>
# Sources are here: https://github.com/chpock/dotfiles

TAR_VERSION="!TAR_VERSION!"

if [ "$1" = "--portable-version" ]; then
    echo "$TAR_VERSION"
    exit 0
fi

error() {
    echo "Error: $1" >&2
    exit 1
}

for i in "$TEMP" "$TMP" "/tmp" "/var/tmp"; do
    [ -d "$i" ] || continue
    [ -w "$i" ] || continue
    TEMP_DIR="$i"
    break
done

[ -n "$TEMP_DIR" ] || error "Could not find temporary directory."

TEMP_DIR="${TEMP_DIR}/tar-portable-${TAR_VERSION}-$(id -un)"

mkdir -p -m 0700 "$TEMP_DIR" || error "Could not create the temporary directory '$TEMP_DIR'."

PERM="$(stat -c '%a' "$TEMP_DIR")"
[ "$PERM" = "700" ] || error "The temporary directory '$TEMP_DIR' has unexpected permissions '$PERM'. It may have been created in advance. Check its contents and delete it."

OWN="$(stat -c '%u' "$TEMP_DIR")"
[ "$OWN" = "$(id -u)" ] || error "The temporary directory '$TEMP_DIR' has unexpected owner '$OWN'. It may have been created in advance. Check its contents and delete it."

if [ ! -x "$TEMP_DIR/tar" ]; then
    [ "$(echo "$TEMP_DIR"/*)" = "$TEMP_DIR/*" ] || error "The temporary directory '$TEMP_DIR' is not empty. It may have been created in advance. Check its contents and delete it."
    command -v gzip >/dev/null 2>&1 && GZIP=gzip || GZIP=gzip-portable
    SKIP="$(awk '/^__ARCHIVE_HERE__/ { print NR + 1; exit 0; }' "$0")"
    tail -n+$SKIP "$0" | "$GZIP" -d > "$TEMP_DIR/tar"
    chmod +x "$TEMP_DIR/tar"
fi

exec "${TEMP_DIR}/tar" "$@"

__ARCHIVE_HERE__
