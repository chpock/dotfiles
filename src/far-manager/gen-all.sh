#!/bin/bash

SELF_DIR="$(dirname "$0")"
OUT_DIR="$SELF_DIR/../../far-manager"
OUT="$OUT_DIR/_all.farconfig"

{
    cat <<EOF
<?xml version="1.0" encoding="UTF-8"?>

<!--

    Far manager configuration: UI colors / filetypes / filetype colors
    Maintained by: Konstantin Kushnir <chpock@gmail.com> (https://github.com/chpock/dotfiles)
    Generated at: $(date --iso-8601=ns)

-->

<farconfig>
EOF
    for fn in "$OUT_DIR"/*.farconfig "$OUT_DIR"/*/*.farconfig; do
        [ -f "$fn" ] || continue
        [ "${fn##*/}" != "${OUT##*/}" ] || continue
        sed -e '1,/^<farconfig>/d' -e '/^<\/farconfig>/,$d' "$fn"
    done
    echo '</farconfig>'
} > "$OUT"

