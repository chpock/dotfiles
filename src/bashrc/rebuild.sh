#!/bin/bash

set -eo pipefail

SRC_DIR="$(cd "$(dirname "$0")"; pwd)"
OUT_DIR="$(cd "$SRC_DIR"/../..; pwd)"
BASHRC_OUT_FILE="$OUT_DIR/bashrc"
BASHRC_SRC_FILE="$SRC_DIR/skeleton"
TOOLS_OUT_FILE="$OUT_DIR/tools.list"
TOOLS_SRC_FILE="$SRC_DIR/tools.list"

plain() {
    while IFS= read -r line; do echo "$line"; done
}

getSize() {
    stat -c '%s' "$1"
}

getHash() {
    _hash < "$1"
    echo "#$_HASH"
}

_has() {
    command -v "$1" >/dev/null 2>&1 && return 0 || return 1
}

_hash() {
    # here is Adler-32
    # disable messages during -x
    {
        if [ $# -eq 0 ]; then
            _hash_in
        else
            # Set C locale to avoid processing strings as Unicode. This will
            # improve performance.
            local LC_ALL=C LC_TYPE=C
            local A=1 B=0 C i M="$@"
            local L=${#M}
            for (( i = 0; i < L; i++ )); do
                printf -v C '%d' "'${M:i:1}"
                (( A = (A + C) % 65521 )) || :
                (( B = (B + A) % 65521 )) || :
            done
            printf -v _HASH '%08X' $(( A + ( B << 16 ) ))
        fi
    } 2>/dev/null
    # For debugging only
    : _HASH = $_HASH
}

if _has perl; then
    _hash_in() {
        _HASH="$(command perl -e '$a=1;$b=0;while(read(STDIN,$c,1)){$a=($a+ord$c)%65521;$b=($b+$a)%65521}printf("%08X",($b<<16)|$a)')"
    }
elif _has python3; then
    _hash_in() {
        _HASH="$(command python3 -c 'import sys;a,b=1,0;exec("for c in sys.stdin.buffer.read(): a=(a+c)%65521; b=(b+a)%65521");print(f"{(b<<16)|a:08X}",end="")')"
    }
else
    _hash_in() {
        # here is Adler-32
        # disable messages during -x
        {
            # Set C locale to avoid processing strings as Unicode. This will
            # improve performance.
            local LC_ALL=C LC_TYPE=C
            local A=1 B=0 C
            while IFS= read -d '' -r -n1 C; do
                printf -v C '%d' "'$C"
                (( A = (A + C) % 65521 )) || :
                (( B = (B + A) % 65521 )) || :
            done
            printf -v _HASH '%08X' $(( A + ( B << 16 ) ))
        } 2>/dev/null
    }
fi

terminfo() {
    # remove comments
    # delete spaces from the beginning of lines
    # join all lines
    #
    # note: tic from ncurses 5.7.x (e.g. on macos) cannot parse terminfo as
    # a single line. Name (and alias) must be separated by a new line, and
    # the feature set line must start with a space.
    sed -E -e '/^[[:space:]]*#/d' -e 's/^[[:space:]]+//' | awk 'NR==1{print $0 "\n "}NR!=1{print}' ORS=''
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
    # more-or-less smart detection for inline comments: when there are 3 or more spaces before quote
    # remove empty lines
    # delete spaces from the beginning of lines
    sed -E -e '/^[[:space:]]*"/d' -e 's/[[:space:]]{3,}".+$//' -e '/^[[:space:]]*$/d' -e 's/^[[:space:]]+//'
}

shell() {
    # remove comments
    # remove empty lines
    # delete spaces from the beginning of lines
    sed -E -e '/^[[:space:]]*#/d' -e '/^[[:space:]]*$/d' -e 's/^[[:space:]]+//'
}

tools-list() {
    # remove comments
    # remove empty lines
    sed -E -e '/^[[:space:]]*#/d' -e '/^[[:space:]]*$/d'
}

process() {
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
        elif [ "${line%% *}" = "@setSize" ]; then
            line="${line#* }"
            var="${line%% *}"
            fn="${line#* }"
            fn="${fn/REPO_ROOT/..\/../}"
            printf '%s=%s\n' "$var" "$(getSize "$SRC_DIR/$fn")"
        elif [ "${line%% *}" = "@getSize" ]; then
            fn="${line#* }"
            fn="${fn/REPO_ROOT/..\/..\//}"
            getSize "$SRC_DIR/$fn"
        elif [ "${line%% *}" = "@getHash" ]; then
            fn="${line#* }"
            fn="${fn/REPO_ROOT/..\/..\//}"
            getHash "$SRC_DIR/$fn"
        elif [ "${line%% *}" = "@setHash" ]; then
            line="${line#* }"
            var="${line%% *}"
            fn="${line#* }"
            fn="${fn/REPO_ROOT/..\/../}"
            _hash < "$SRC_DIR/$fn"
            printf '%s=%s\n' "$var" "$_HASH"
        else
            echo "$line"
        fi
    done
}

[ "$1" = "silent" ] || printf "Build tools.list ..."
cat "$TOOLS_SRC_FILE" | tools-list | process > "$TOOLS_OUT_FILE"
[ "$1" = "silent" ] || echo " OK"

[ "$1" = "silent" ] || printf "Build bashrc ..."
process < "$BASHRC_SRC_FILE" > "$BASHRC_OUT_FILE"
[ "$1" = "silent" ] || echo " OK"

if [ -e "/c/Far Manager/Stuff/bashrc" ]; then
    cp -f "$BASHRC_OUT_FILE" "/c/Far Manager/Stuff/bashrc"
fi
if [ -e "/d/Sync/Envy" ]; then
    mkdir -p /d/Sync/Envy/dotfiles
    cp -f "$BASHRC_OUT_FILE" /d/Sync/Envy/dotfiles/bashrc
fi

[ "$1" = "silent" ] || echo "Done."
