#!/bin/bash

set -e

SELF_DIR="$(dirname "$0")"
OUT_DIR="$SELF_DIR/../../../far-manager/colorer"
SAMPLE_ANS="$SELF_DIR/../../../far-manager/preview"
SAMPLE_SVG="$SELF_DIR/../../../far-manager/preview"

WIDTH=72

PALETTE_FILE="$SELF_DIR/palette.hrd"

DEF_BG=""
DEF_FG=""
PALETTE=""

if [ -z "$1" ]; then
    for fn in "$SELF_DIR"/*.hrd; do
        [ "${fn##*/}" != "palette.hrd" ] || continue
        [ "${fn##*/}" != "sample.hrd" ] || continue
        "$0" generate "$fn"
    done
    exit 0
fi

if [ "$1" = "generate" ]; then
    GENERATE=1
    shift
fi

HRD="$1"
BASE_FULL="${HRD##*/}"
OUT="$OUT_DIR/$BASE_FULL"
BASE_NAME="${BASE_FULL%.hrd}"

SAMPLE_ANS="$SAMPLE_ANS/${BASE_NAME}.ans"
SAMPLE_SVG="$SAMPLE_SVG/${BASE_NAME}.svg"

get() {
    local line="$1" attr="$2" var="$3"
    local R="${line#*${attr}=\"}"
    if [ "$R" = "$line" ]; then
        unset R
    else
        R="${R%%\"*}"
    fi
    printf -v "$var" '%s' "$R"

}

pal() {
    local macro="$1" var="$2"
    local R="${PALETTE#*:${macro}:}"
    if [ "$R" = "$PALETTE" ]; then
        unset R
    else
        R="${R%%:*}"
    fi
    printf -v "$var" '%s' "$R"
}

col() {
    local C="$2"
    [ -n "$C" ] || return 0
    printf '\033['
    [ "$1" = "fg" ] && printf '38' || printf '48'
    printf ';2'
    [ "${C:0:1}" = "#" ] && C="${C:1}" || pal "$C" C
    printf ';%d' $((16#${C:0:2}))
    printf ';%d' $((16#${C:2:2}))
    printf ';%d' $((16#${C:4:2}))
    printf 'm'
}

replace() {
    local str="$1" attr="$2" var="$3"
    local val
    get "$str" "$attr" val
    if [ -z "$val" -o "${val:0:1}" = "#" ]; then
        printf -v "$var" '%s' "$str"
    else
        pal "$val" val
        local x="${str#*${attr}=\"}"
        printf -v "$var" '%s%s%s%s' "${str%${attr}=\"*}" "${attr}=\"" "#$val" "\"${x#*\"}"
    fi
}

cprint() {
    local opt OPTIND APTARG
    local fg bg
    while getopts "f:b:" opt; do
        case "$opt" in
            f) fg="$OPTARG";;
            b) bg="$OPTARG";;
        esac
    done
    shift $((OPTIND-1))
    printf '\033[?7l'; # wrap off
    col fg "$fg"; col bg "$bg"
    printf "%-${WIDTH}s" "$1"
    printf '\033[0m\n'
    printf '\033[?7h'; # wrap on
}

process() {
    local line fg bg out
    while IFS= read -r line || [ -n "$line" ]; do
        out="$line"
        get "$line" "fore" fg
        [ -z "$fg" ] || replace "$out" "fore" out
        get "$line" "back" bg
        [ -z "$bg" ] || replace "$out" "back" out
        out="${out/@@DATE@@/$GEN_DATE}"
        echo "$out" >&3
        get "$line" "name" name
        if [ "$name" = "def:Text" ]; then
            DEF_BG="$bg"
            DEF_FG="$fg"
        elif [ "$name" = "def:bg" ]; then
            DEF_BG="$fg"
        fi
        [ -n "$bg" ] || bg="$DEF_BG"
        [ -n "$fg" ] || fg="$DEF_FG"
        cprint -f "$fg" -b "$bg" -- "$line"
    done
}

while read -r line || [ -n "$line" ]; do
    get "$line" "name" name
    [ -n "$name" ] || continue
    get "$line" "fore" fg
    PALETTE="$PALETTE:${name##*:}:${fg:1}"
done < "$PALETTE_FILE"

GEN_DATE="$(date --iso-8601=ns)"

if [ ! -f "$1" ]; then
    process < "$PALETTE_FILE" 3>/dev/null
    exit 0
elif [ -z "$GENERATE" ]; then
    process < "$HRD" 3>/dev/null
    exit 0
fi

process < "$HRD" 3>"$OUT" | tee "$SAMPLE_ANS"

! command -v ansisvg >/dev/null 2>&1 || ansisvg < "$SAMPLE_ANS" > "$SAMPLE_SVG"
