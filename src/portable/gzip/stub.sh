#/bin/sh

# Self-extracting script for gzip !GZIP_VERSION!.
# Packaged by Konstantin Kushnir <chpock@gmail.com>
# Sources are here: https://github.com/chpock/dotfiles

GZIP_VERSION="!GZIP_VERSION!"

if [ "$1" = "--portable-version" ]; then
    echo "$GZIP_VERSION"
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

TEMP_DIR="${TEMP_DIR}/gzip-portable-${GZIP_VERSION}-$(id -un)"

mkdir -p -m 0700 "$TEMP_DIR" || error "Could not create the temporary directory '$TEMP_DIR'."

PERM="$(stat -c '%a' "$TEMP_DIR")"
[ "$PERM" = "700" ] || error "The temporary directory '$TEMP_DIR' has unexpected permissions '$PERM'. It may have been created in advance. Check its contents and delete it."

OWN="$(stat -c '%u' "$TEMP_DIR")"
[ "$OWN" = "$(id -u)" ] || error "The temporary directory '$TEMP_DIR' has unexpected owner '$OWN'. It may have been created in advance. Check its contents and delete it."

if [ ! -x "$TEMP_DIR/gzip" ]; then
    [ "$(echo "$TEMP_DIR"/*)" = "$TEMP_DIR/*" ] || error "The temporary directory '$TEMP_DIR' is not empty. It may have been created in advance. Check its contents and delete it."
    SKIP="$(awk '/^__ARCHIVE_HERE__/ { print NR + 1; exit 0; }' "$0")"
    tail -n+$SKIP "$0" > "$TEMP_DIR/gzip"
    chmod +x "$TEMP_DIR/gzip"
fi

exec "${TEMP_DIR}/gzip" "$@"

__ARCHIVE_HERE__
