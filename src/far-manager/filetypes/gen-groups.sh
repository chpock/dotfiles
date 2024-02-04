#!/bin/bash

SELF_DIR="$(dirname "$0")"
OUT_DIR="$SELF_DIR/../../../far-manager/filetypes"
OUT_MASKS="$OUT_DIR/masks.farconfig"
OUT_GROUPS="$OUT_DIR/groups.farconfig"
CONF="$SELF_DIR/groups.ini"
MASKS="$SELF_DIR/masks"
SAMPLE_ANS="$SELF_DIR/../../../far-manager/preview/filetypes.ans"
SAMPLE_SVG="$SELF_DIR/../../../far-manager/preview/filetypes.svg"

B_LT="╔" B_T="═" B_RT="╗"
B_LB="╚" B_L="║" B_RB="╝"

WIDTH="50"

C_BG="234"
C_FG="223"

MAIN_GROUP=

HL_GROUP_IDX=0
UP_GROUP_IDX=0
LO_GROUP_IDX=0
LW_GROUP_IDX=0

schema_set() {
    local k v rec
    for rec in $1; do
        k="${rec%%=*}"
        v="${rec#*=}"
        case "$k" in
            attr)  SCH_ATTR="$v";;
            !attr) SCH_NOATTR="$v";;
            masks) SCH_MASK="$v";;
            uppergroup) SCH_UPGR="1";;
            lowergroup) SCH_LOGR="1";;
            lowest)     SCH_LWGR="1";;
            *) echo "WARNING: unknown rec in schema: '$rec'";;
        esac
    done
}

schema_reset() {
    unset SCH_UPGR
    unset SCH_LOGR
    unset SCH_LWGR
    unset SCH_MASK
    unset SCH_ATTR
    unset SCH_NOATTR
}

gen_value() {
    local i
    printf '                    <value'
    for (( i = 1; i <= $#; i++ )); do
        printf ' %s=' "${!i}"
        i=$(( i + 1 ))
        printf '"%s"' "${!i}"
    done
    echo '/>'
}

norm_col() {
    local C="$1" R G B S
    if [ "$C" -lt 16 ]; then
        echo "Unexpected color: '$C'" >&2
        exit 1
    fi
    if [ "$C" -lt 232 ]; then
        C=$(( 10#$C - 16 ))
        R=$(( C / 36 ))
        G=$(( ( C - R*36 ) / 6 ))
        B=$(( C - R*36 - G*6 ))
        S=("00" "5f" "87" "AF" "D7" "FF")
        printf 'FF%s%s%s' "${S[B]}" "${S[G]}" "${S[R]}"
    else
        C=$(( 8 + 2570 * ( C  - 232 ) / 256 ))
        printf 'FF%02X%02X%02X' "$C" "$C" "$C"
    fi

}

gen_group() {
    local GROUP="$1"
    shift
    local Title="$GROUP" Mask="$SCH_MASK" AttrClear="0000000000000000" AttrSet="0000000000000000" UseMask="0000000000000000" UseAttr="0000000000000000"
    local Mark="" MarkChar="0000000000000000"
    local k="" kf="-" kb="-" cf="-" cb="-"
    local opt OPTIND APTARG
    while getopts "f:b:m:k:l:" opt; do
        case $opt in
            f) cf="$OPTARG";;
            b) cb="$OPTARG";;
            m) Mark="$OPTARG";;
            k) kf="$OPTARG";;
            l) kb="$OPTARG";;
        esac
    done
    if [ -n "$SCH_UPGR" ]; then
        echo   '            <key name="SortGroups">'
        printf '                <key name="UpperGroup%s">\n' "$UP_GROUP_IDX"
        UP_GROUP_IDX=$(( UP_GROUP_IDX + 1 ))
    elif [ -n "$SCH_LOGR" ]; then
        echo   '            <key name="SortGroups">'
        printf '                <key name="LowerGroup%s">\n' "$LO_GROUP_IDX"
        LO_GROUP_IDX=$(( LO_GROUP_IDX + 1 ))
    elif [ -n "$SCH_LWGR" ]; then
        echo   '            <key name="Highlight">'
        printf '                <key name="LastGroup%s">\n' "$LW_GROUP_IDX"
        LW_GROUP_IDX=$(( LW_GROUP_IDX + 1 ))
    else
        echo   '            <key name="Highlight">'
        printf '                <key name="Group%s">\n' "$HL_GROUP_IDX"
        HL_GROUP_IDX=$(( HL_GROUP_IDX + 1 ))
    fi
    gen_value name Title type text value "$Title"
    if [ -z "$Mask" ]; then
        Mask="&lt;${GROUP}&gt;"
    fi
    if [ -n "$Mark" ]; then
        printf -v MarkChar "%016X" "'$Mark"
    fi
    UseMask="0000000000000001"
    if [ -n "$SCH_ATTR" ]; then
        if [ "$SCH_ATTR" = "H" ]; then
            AttrSet="0000000000000002"
        elif [ "$SCH_ATTR" = "S" ]; then
            AttrSet="0000000000000004"
        elif [ "$SCH_ATTR" = "D" ]; then
            AttrSet="0000000000000010"
        else
            echo "WARNING: unknown attribute: '$SCH_ATTR'"
        fi
        UseAttr="0000000000000001"
    fi
    if [ -n "$SCH_NOATTR" ]; then
        if [ "$SCH_NOATTR" = "H" ]; then
            AttrClear="0000000000000002"
        elif [ "$SCH_NOATTR" = "S" ]; then
            AttrClear="0000000000000004"
        elif [ "$SCH_NOATTR" = "D" ]; then
            AttrClear="0000000000000010"
        else
            echo "WARNING: unknown attribute: '$SCH_NOATTR'"
        fi
        UseAttr="0000000000000001"
    fi
    gen_value name Mask type text value "$Mask"
    gen_value name UseMask type qword value "$UseMask"
    gen_value name AttrSet type qword value "$AttrSet"
    gen_value name AttrClear type qword value "$AttrClear"
    gen_value name UseAttr type qword value "$UseAttr"
    gen_value name Mark type text value "$Mark"
    gen_value name MarkChar type qword value "$MarkChar"
    if [ "$cf" = "-" -a "$cb" = "-" ]; then
        gen_value name NormalColor type color flags "fgindex bgindex"
    elif [ "$cf" = "-" ]; then
        gen_value name NormalColor type color background "$(norm_col "$cb")" flags "fgindex"
    elif [ "$cb" = "-" ]; then
        gen_value name NormalColor type color foreground "$(norm_col "$cf")" flags "bgindex"
    else
        gen_value name NormalColor type color background "$(norm_col "$cb")" foreground "$(norm_col "$cf")"
    fi
    if [ "$kf" = "-" -a "$kb" = "-" ]; then
        gen_value name MarkCharNormalColor type color flags "fgindex bgindex"
    elif [ "$kf" = "-" ]; then
        gen_value name MarkCharNormalColor type color background "$(norm_col "$kb")" flags "fgindex"
    elif [ "$kb" = "-" ]; then
        gen_value name MarkCharNormalColor type color foreground "$(norm_col "$kf")" flags "bgindex"
    else
        gen_value name MarkCharNormalColor type color background "$(norm_col "$kb")" foreground "$(norm_col "$kf")"
    fi
    # default values
    gen_value name SelectedColor type color flags "fgindex bgindex"
    gen_value name SelectedCursorColor type color flags "fgindex bgindex"
    gen_value name CursorColor type color flags "fgindex bgindex"
    gen_value name MarkCharCursorColor type color flags "fgindex bgindex"
    gen_value name MarkCharSelectedColor type color flags "fgindex bgindex"
    gen_value name MarkCharSelectedCursorColor type color flags "fgindex bgindex"
    # unused values
    gen_value name ContinueProcessing type qword value 0000000000000000
    gen_value name DateRelative type qword value 0000000000000000
    gen_value name DateTimeAfter type qword value 0000000000000000
    gen_value name DateTimeBefore type qword value 0000000000000000
    gen_value name DateType type qword value 0000000000000000
    gen_value name HardLinksAbove type qword value 0000000000000000
    gen_value name HardLinksBelow type qword value 0000000000000000
    gen_value name SizeAboveS type text value ""
    gen_value name SizeBelowS type text value ""
    gen_value name UseDate type qword value 0000000000000000
    gen_value name UseHardLinks type qword value 0000000000000000
    gen_value name UseSize type qword value 0000000000000000
    echo   '                </key>'
    echo   '            </key>'
}

gen() {
    if [ -z "$SCH_MASK" ]; then
        local masks="$MASKS/$1"
        if [ ! -f "$masks" ]; then
            echo "WARNING: no masks in '$masks'"
            return
        fi
        {
            printf '        <setting key="Masks" name="%s" type="text" value="' "$1"
            # 1. ignore lines starting with '#'
            # 2. join all lines by comma
            # 3. remove possible commas around the pipe symbol
            grep -v '^#' "$masks" | awk 'NR==1{print $1}NR!=1{print "," $1}' ORS='' | sed -E 's/,*\|,*/|/'
            echo '"/>'
        } >&3
    fi
    gen_group "$@" >&4
    schema_reset
}

# -t - top line
# -o - bottom line
out() {
    local opt OPTIND OPTARG
    local l="$B_L" r="$B_L" f=" " a=left cb="-" cf="-" m
    local mk="" k="" kb="-" kf="-"
    local GROUP GROUP_PAD
    while getopts "tof:b:m:k:l:" opt; do
        case $opt in
            t) l="$B_LT" r="$B_RT" f="$B_T" a=center;;
            o) l="$B_LB" r="$B_RB" f="$B_T" a=center;;
            f) cf="$OPTARG";;
            b) cb="$OPTARG";;
            m) k="$OPTARG";;
            k) kf="$OPTARG";;
            l) kb="$OPTARG";;
        esac
    done
    shift $((OPTIND-1))
    GROUP="$1"
    if [ "${GROUP:0:1}" != " " ]; then
        if [ "${GROUP:0:1}" = "&" ]; then
            GROUP="${GROUP:1}"
        elif [ -n "$GROUP" ]; then
            gen "$GROUP" -f "$cf" -b "$cb" -m "$k" -k "$kf" -l "$kb"
        fi
        MAIN_GROUP="$GROUP"
        GROUP_PAD=""
    elif [ -n "$MAIN_GROUP" ] && [ "$a" != "center" ]; then
        GROUP_PAD="${GROUP% *}"
        GROUP="${MAIN_GROUP}-${GROUP##* }"
        gen "$GROUP" -f "$cf" -b "$cb" -m "$k" -k "$kf" -l "$kb"
    fi
    [ "$cf" != "-" ] || cf="$C_FG"
    [ "$cb" != "-" ] || cb="$C_BG"
    [ "$kf" != "-" ] || kf="$cf"
    [ "$kb" != "-" ] || kb="$cb"
    printf '\033[48;5;%sm\033[38;5;%sm%s\033[0m \033[38;5;236m| \033[0m' "$cb" "$cf" "$cf"
    printf -v l '\033[48;5;%sm\033[38;5;%sm%s' "$C_BG" "$C_FG" "$l"
    printf -v r '\033[48;5;%sm\033[38;5;%sm%s\033[0m' "$C_BG" "$C_FG" "$r"
    [ -z "$k" ] || printf -v mk '\033[48;5;%sm\033[38;5;%sm%s' "$kb" "$kf" "$k"
    if [ "$a" = "left" ]; then
        printf -v m '\033[48;5;%sm%s%s\033[48;5;%sm\033[38;5;%sm%s' "$cb" "$GROUP_PAD" "$mk" "$cb" "$cf" "$GROUP"
        printf "%s%s%s%s" "$l" "$m" "$(printf "$f%.0s" $(seq 1 $(( WIDTH - 2 - ${#GROUP} - ${#GROUP_PAD} - ${#k} ))))" "$r"
    else
        printf -v m '%s%s\033[48;5;%sm\033[38;5;%sm%s\033[48;5;%sm\033[38;5;%sm' "$GROUP_PAD" "$mk" "$cb" "$cf" "$GROUP" "$C_BG" "$C_FG"
        local p1=$(( (WIDTH - ${#GROUP} - ${GROUP_PAD} - ${#k} - 2) / 2 ))
        local p2=$(( WIDTH - p1 - ${#GROUP} - ${GROUP_PAD} - ${#k} - 2 ))
        printf "%s%s%s%s%s" "$l" "$(printf "$f%.0s" $(seq 1 $p1))" "$m" "$(printf "$f%.0s" $(seq 1 $p2))" "$r"
    fi
    echo
}

GEN_DATE="$(date --iso-8601=ns)"

cat <<EOF >"$OUT_MASKS"
<?xml version="1.0" encoding="UTF-8"?>

<!--

    Far manager configuration: filetypes
    Maintained by: Konstantin Kushnir <chpock@gmail.com> (https://github.com/chpock/dotfiles)
    Generated at: $GEN_DATE

-->

<farconfig>
    <generalconfig>
EOF

cat <<EOF >"$OUT_GROUPS"
<?xml version="1.0" encoding="UTF-8"?>

<!--

    Far manager configuration: filetype colors
    Maintained by: Konstantin Kushnir <chpock@gmail.com> (https://github.com/chpock/dotfiles)
    Generated at: $GEN_DATE

-->

<farconfig>
    <highlight>
        <hierarchicalconfig>
EOF

{
    out -t " C:/Far Manager "
    while IFS= read -r i; do
        if [ -z "$i" ]; then
            out "$i"
        else
            c="${i%% *}"
            i="${i:$(( ${#c} + 1 ))}"
            if [ "$c" = "schema:" ]; then
                schema_set "$i"
                continue
            fi
            if [ "${i%| *}" = "$i" ]; then
                m="" mc="-/-"
            else
                m="${i#*| }"
                mc="${m%% *}"
                m="${m:$(( ${#mc} + 1 ))}"
                i="${i%|*}"
            fi
            while [ "${i:$((${#i}-1))}" = " " ] || [ "${i:$((${#i}-1))}" = "|" ]; do i="${i:0:$((${#i}-1))}"; done
            out -f "${c%/*}" -b "${c#*/}" -m "$m" -k "${mc%/*}" -l "${mc#*/}" -- "$i"
        fi
    done < <(grep -v '^#' "$CONF") 3>>"$OUT_MASKS" 4>>"$OUT_GROUPS"
    out -o " Bytes: 10,0 G, files: 54, folders: 10 "
} | tee "$SAMPLE_ANS"

cat <<EOF >>"$OUT_MASKS"
    </generalconfig>
</farconfig>
EOF

cat <<EOF >>"$OUT_GROUPS"
        </hierarchicalconfig>
    </highlight>
</farconfig>
EOF

"$SELF_DIR/../gen-all.sh"
! command -v ansisvg >/dev/null 2>&1 || ansisvg < "$SAMPLE_ANS" > "$SAMPLE_SVG"

