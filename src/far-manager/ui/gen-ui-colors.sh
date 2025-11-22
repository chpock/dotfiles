#!/bin/bash

set -e

SELF_DIR="$(dirname "$0")"
OUT_DIR="$SELF_DIR/../../../far-manager/ui"
CONF="$SELF_DIR/ui-colors.ini"
OUT="$OUT_DIR/ui-colors.farconfig"
IN_FAR2L="$SELF_DIR/farcolors.ini.in"
OUT_FAR2L="$OUT_DIR/farcolors.ini"

declare -A RAW_DATA

get() {
#    grep -oP "^${1}=\\K.+\$" "$CONF"
    echo "${RAW_DATA[$1]}"
}

normalize() {
    local fg="${1% *}"
    local bg="${1#* }"
    fg="${fg:4:2}${fg:2:2}${fg:0:2}"
    bg="${bg:4:2}${bg:2:2}${bg:0:2}"
    echo "$bg $fg"
}

normalizeReverse() {
    local fg="${1% *}"
    local bg="${1#* }"
    fg="${fg:0:2}${fg:2:2}${fg:4:2}"
    bg="${bg:0:2}${bg:2:2}${bg:4:2}"
    echo "$bg $fg"
}

normalizeRGB() {
    local fg="${1% *}"
    local bg="${1#* }"
    fg="fore_rgb($((0x${fg:0:2})), $((0x${fg:2:2})), $((0x${fg:4:2})))"
    bg="back_rgb($((0x${bg:0:2})), $((0x${bg:2:2})), $((0x${bg:4:2})))"
    echo "$bg | $fg"
}

get_colors() {
    local fg bg val
    val="$(get "$1")"
    if [ -z "$val" ]; then
        echo "Error: value '$1' was not found" >&2
        exit 1
    fi
    if [ "${val:0:1}" = "#" ]; then
        echo "${val:1}"
    elif [ "${val% *}" = "$val" ]; then
        get_colors "$val"
    else
        fg="${val% *}"
        bg="${val#* }"
        if [ "${fg#*#}" = "$fg" ]; then
            fg="$(get_colors "$fg")"
        else
            local type="${fg#*#}"
            val="$(get_colors "${fg%#*}")"
            if [ "$type" = "fg" ]; then
                fg="${val% *}"
            else
                fg="${val#* }"
            fi
        fi
        if [ "${bg#*#}" = "$bg" ]; then
            bg="$(get_colors "$bg")"
        else
            local type="${bg#*#}"
            val="$(get_colors "${bg%#*}")"
            if [ "$type" = "fg" ]; then
                bg="${val% *}"
            else
                bg="${val#* }"
            fi
        fi
        echo "$fg $bg"
    fi
}

while IFS="=" read k v; do
    [ -n "$k" ] || continue
    [ -n "$v" ] || continue
    RAW_DATA["$k"]="$v"
done < "$CONF"

if [ -n "$1" ]; then
    set -x
    get_colors "$1"
    exit 0
fi

{
    cat <<EOF
<?xml version="1.0" encoding="UTF-8"?>

<!--

    Far manager configuration: UI colors
    Maintained by: Konstantin Kushnir <chpock@gmail.com> (https://github.com/chpock/dotfiles)
    Generated at: $(date --iso-8601=ns)

-->

<farconfig>
    <colors>
EOF
    # Disable: To read lines rather than words, pipe/redirect to a 'while read' loop. [SC2013]
    # shellcheck disable=SC2013
    for i in $(grep -oP '^[A-Z][^=]+' "$CONF" | sort); do
        # Disable: Quote this to prevent word splitting. [SC2046]
        # Disable: This format string has 5 variables, but is passed 4 arguments. [SC2183]
        # shellcheck disable=SC2046,SC2183
        printf '        <object name="%s" background="FF%s" foreground="FF%s"/>\n' "$i" $(normalize "$(get_colors "$i")")
    done
    cat <<EOF
        <object name="CommandLine" background="FF000000" foreground="FF000007" flags="fgindex bgindex"/>
        <object name="CommandLine.Prefix" background="FF000000" foreground="FF000007" flags="fgindex bgindex"/>
        <object name="CommandLine.Selected" background="FF000003" foreground="FF000000" flags="fgindex bgindex"/>
        <object name="CommandLine.UserScreen" background="FF000000" foreground="FF000007" flags="fgindex bgindex"/>
    </colors>
</farconfig>
EOF
} >"$OUT"


{

    cat <<EOF
; Far manager configuration: UI colors
; Maintained by: Konstantin Kushnir <chpock@gmail.com> (https://github.com/chpock/dotfiles)
; Generated at: $(date --iso-8601=ns)

EOF

    while read -r LINE; do
        case "$LINE" in
            CommandLine*|Not.Used=*) :;;
            *=background:*)
                LINE="${LINE%;*}"
                ID="${LINE%=*}"
                # Disable: Quote this to prevent word splitting. [SC2046]
                # Disable: This format string has 5 variables, but is passed 4 arguments. [SC2183]
                # shellcheck disable=SC2046,SC2183
                printf -v LINE '%s=background:#%s foreground:#%s, %s; %s' "${LINE%%=*}" $(normalizeReverse "$(get_colors "$ID")") "${LINE#*, }" "$(normalizeRGB "$(get_colors "$ID")")"
                ;;
        esac
        echo "$LINE"
    done < "$IN_FAR2L"

} >"$OUT_FAR2L"

"$SELF_DIR/../gen-all.sh"
