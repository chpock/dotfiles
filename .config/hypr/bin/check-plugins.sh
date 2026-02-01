#!/bin/sh

DYNAMIC_CONF_DIR="$XDG_RUNTIME_DIR/hypr"
mkdir -p "$DYNAMIC_CONF_DIR"

DYNAMIC_CONF_FILE="$DYNAMIC_CONF_DIR/hyprland.conf"
DYNAMIC_CONF_FILE_TEMP="$(mktemp)"

LC_ALL=C hyprctl plugin list | grep -q '^Plugin hy3 ' && HY3_PREFIX="hy3:" || HY3_PREFIX=""
LC_ALL=C hyprctl plugin list | grep -q '^Plugin hyprsplit ' && HYPRSPLIT_PREFIX="split:" || HYPRSPLIT_PREFIX=""

{

    # shellcheck disable=SC2016
    [ -z "$HY3_PREFIX" ] \
        && echo '$has_plugin_hy3 =' \
        || echo '$has_plugin_hy3 = 1'

    # shellcheck disable=SC2016
    [ -z "$HYPRSPLIT_PREFIX" ] \
        && echo '$has_plugin_hyprsplit =' \
        || echo '$has_plugin_hyprsplit = 1'

    # shellcheck disable=SC2043
    for d in workspace
    do
        echo "\$dispatch_$d = ${HYPRSPLIT_PREFIX}$d"
    done

    for d in \
        togglefocuslayer \
        makegroup \
        movefocus \
        movewindow \
        movetoworkspace \
        killactive
    do
        echo "\$dispatch_$d = ${HY3_PREFIX}$d"
    done

} > "$DYNAMIC_CONF_FILE_TEMP"

if [ ! -e "$DYNAMIC_CONF_FILE" ] || [ "$(cat "$DYNAMIC_CONF_FILE")" != "$(cat "$DYNAMIC_CONF_FILE_TEMP")" ]; then
    mv -f "$DYNAMIC_CONF_FILE_TEMP" "$DYNAMIC_CONF_FILE"
else
    rm -f "$DYNAMIC_CONF_FILE_TEMP"
fi
