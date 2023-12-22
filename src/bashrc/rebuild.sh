#!/bin/bash

set -eo pipefail

SRC_DIR="$(cd "$(dirname "$0")"; pwd)"
OUT_DIR="$(cd "$SRC_DIR"/../..; pwd)"
OUT_FILE="$OUT_DIR/bashrc"
SRC_FILE="$SRC_DIR/skeleton"

plain() {
    while IFS= read -r line; do echo "$line"; done
}

terminfo() {
    # remove comments
    # delete spaces from the beginning of lines
    # join all lines
    sed -E -e '/^[[:space:]]*#/d' -e 's/^[[:space:]]+//' | awk '{print}' ORS=''
    echo
}

tcl() {
    # remove empty lines
    # delete spaces from the beginning of lines
    sed -E -e '/^[[:space:]]*$/d' -e 's/^[[:space:]]+//'
}

tmux-conf() {
    # remove comments
    # remove empty lines
    sed -E -e '/^[[:space:]]*#/d' -e '/^[[:space:]]*$/d'
}

vimrc() {
    # remove comments
    # remove empty lines
    # more-or-less smart detection for inline comments: when there are 3 or more spaces before quote
    sed -E -e '/^[[:space:]]*"/d' -e 's/[[:space:]]{3,}".+$//' -e '/^[[:space:]]*$/d'
}

shell() {
    # remove comments
    # remove empty lines
    # delete spaces from the beginning of lines
    sed -E -e '/^[[:space:]]*#/d' -e '/^[[:space:]]*$/d' -e 's/^[[:space:]]+//'
}

[ "$1" = "silent" ] || printf "Build bashrc ..."

while IFS= read -r line; do
    if [ "${line%% *}" = "@include" ]; then
        inc="${line#* }"
        if [ "${inc%% *}" != "part" ]; then
            unset part
            start="1"
            end='$'
        else
            inc="${inc#* }"
            part="${inc%% *}"
            inc="${inc#* }"
            lines="$(wc -l "$SRC_DIR/$inc" | awk '{print $1}')"
            if [ "$part" = 0 ]; then
                start="1"
                end=$(( lines / 2 ))
            else
                start=$(( lines / 2 + 1 ))
                end="$"
            fi
        fi
        case "$inc" in
            *.terminfo) filter="terminfo";;
            *.tcl)      filter="tcl";;
            *.sh)       filter="shell";;
            tmux.conf)  filter="tmux-conf";;
            vimrc)      filter="vimrc";;
            *)          filter="plain" ;;
        esac
        $filter < <(sed -n "${start},${end}p" "$SRC_DIR/$inc")
    else
        echo "$line"
    fi
done < "$SRC_FILE" > "$OUT_FILE"

[ "$1" = "silent" ] || echo " Done."
