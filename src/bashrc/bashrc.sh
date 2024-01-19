#!/bin/bash

COLOR_WHITE=$'\e[1;37m'
COLOR_LIGHTGRAY=$'\e[0;37m'
COLOR_GRAY=$'\e[1;30m'
COLOR_BLACK=$'\e[0;30m'
COLOR_RED=$'\e[0;31m'
COLOR_LIGHTRED=$'\e[1;31m'
COLOR_GREEN=$'\e[0;32m'
COLOR_LIGHTGREEN=$'\e[1;32m'
COLOR_BROWN=$'\e[0;33m'
COLOR_YELLOW=$'\e[1;33m'
COLOR_BLUE=$'\e[0;34m'
COLOR_LIGHTBLUE=$'\e[1;34m'
COLOR_PURPLE=$'\e[0;35m'
COLOR_PINK=$'\e[1;35m'
COLOR_CYAN=$'\e[0;36m'
COLOR_LIGHTCYAN=$'\e[1;36m'
COLOR_DEFAULT=$'\e[0m'
COLOR_BOLD=$'\e[1m'

COLOR_ERROR=$'\e[41m\e[1m\e[97m'
COLOR_SIGN=$'\e[38;5;136m'

_hash() {
    # here is Adler-32
    # disable messages during -x
    {
        local A=1 B=0 M="$@" C i
        [ -n "$M" ] || IFS= read -r -d '' M || :
        local L=${#M}
        for (( i = 0; i < $L; i++ )); do
            printf -v C '%d' "'${M:$i:1}"
            A=$(( (A + C) % 65521 ))
            B=$(( (B + A) % 65521 ))
        done
    } 2>/dev/null
    printf -v _HASH '%X' $(( A + ( B << 16 ) ))
}

# old bash doesn't support to set default value during indirect expansion
# i.e. echo "${!V:=$R}"
_cache() {
    _hash "$@"
    local V="__CACHE_$_HASH"
    [ -n "${!V}" ] || printf -v "$V" '%s' "$("$@")"
    _CACHE="${!V}"
}

_check() {
    _hash "$@"
    local V="__CACHE_CHECK_$_HASH"
    [ -n "${!V}" ] || { "$@" >/dev/null 2>&1 && printf -v "$V" 0 || printf -v "$V" 1; }
    return "${!V}"
}

_once() {
    _hash "$@"
    local V="__CACHE_ONCE_$_HASH"
    [ -z "${!V}" ] || return 1
    printf -v "$V" 0
    return 0
}

_glob_match() {
    # case doesn't allow pipe '|' in variable as a pattern, that is why 'eval' is used here
    # https://unix.stackexchange.com/a/574088
    eval "case \"\$2\" in ${1// /\\ }) return 0;; *) return 1;; esac"
}

# Returns the size of the file(s) in bytes.
# Use GNU stat with "-c '%s'" if available.
# Use BSD stat with "-f '%z'" is available. BSD stat has the -F option, which is not present in GNU stat.
# Use GNU du with "--bytes --summarize" if available.
# print 'unknown' otherwise.
_get_size() {
    if _check command stat --version; then
        command stat -c '%s' "$@"
    elif _check command stat -F /dev/null; then
        command stat -f '%z' "$@"
    elif _check command du --bytes /dev/null; then
        command du --bytes --summarize "$@" | awk '{ print $1 }'
    else
        local a
        for a; do echo "unknown"; done
    fi
}

_get_url() {
    if [ "$1" = "-check" ]; then
        if _has curl || _has wget || _has openssl || [ -x /usr/lib/apt/apt-helper ]; then
            return 0
        else
            return 1
        fi
    fi
    local URL="$1"
    if _has curl; then
        curl --fail --silent --show-error -k -L "$URL"
    elif _has wget; then
        wget -q -O - "$URL"
    elif [ -x /usr/lib/apt/apt-helper ]; then
        local R OUT ERR TMP="$(mktemp)"
        _catch OUT ERR /usr/lib/apt/apt-helper -oAcquire::https::Verify-Peer=false download-file "$URL" "$TMP" && R=0 || R=$?
        if [ $R -eq 0 ]; then
            cat "$TMP"
        else
            echo "$ERR" >&2
        fi
        rm -f "$TMP"
        return $R
    elif _has openssl; then
        local LOOP=1
        while [ -n "$LOOP" ]; do
            local X="$URL" HOST UPATH PORT=443 R="" S=""
            unset LOOP
            X="${X#https://}"
            HOST="${X%%/*}"
            UPATH="/${X#*/}"
            [ "$UPATH" != "/$X" ] || UPATH="/"
            while IFS= read -r line; do
                if [ -z "$R" ]; then
                    R="${line#* }"
                    S="${R%% *}"
                    if [ "$S" != "200" -a "$S" != "301" -a "$S" != "302" ]; then
                        echo "Error: $R" >&2
                        return 1
                    fi
                elif [ "${line%% *}" = "Location:" ]; then
                    URL="${line#* }"
                    URL="${URL%$'\r'}"
                    [ "${URL#https://}" != "$URL" ] || URL="https://$HOST$URL"
                    LOOP=1
                    break
                elif [ "${#line}" -eq 1 ]; then
                    # if line contains only '\r'
                    cat
                fi
            done < <(printf '%s\r\n' "GET $UPATH HTTP/1.1" "Host: $HOST" "Connection: Close" "" | openssl s_client -quiet -connect "$HOST:443" 2>/dev/null)
        done
    else
        return 1
    fi
}

_has() { _check command -v "$1" && return 0 || return 1; }
_hasnot() { _has "$1" && return 1 || return 0; }

__vercomp() {
    local i IFS=.
    local v1=($1) v2=($2)
    for (( i = 0; i < ${#v1[@]} || i < ${#v2[@]}; i++ )); do
        [ "${v1[i]:-0}" -le "${v2[i]:-0}" ] || return 1
        [ "${v1[i]:-0}" -ge "${v2[i]:-0}" ] || return 0
    done
    return $3
}

_vercomp() {
    case "$2" in
        le|-le|'<=') __vercomp "$1" "$3" 0;;
        lt|-lt|'<')  __vercomp "$1" "$3" 1;;
        ge|-ge|'>=') ! _vercomp "$1" lt "$3";;
        gt|-gt|'>')  ! _vercomp "$1" le "$3";;
    esac
}

_addpath() {
    local pos="end" d
    if [ "$1" = "-start" ]; then
        pos="start"
        shift
    fi
    PATH=":${PATH}:"
    for d; do
        # strip trailing slash
        d="${d%/}"
        PATH="${PATH//:${d}:/:}"
        [ "$pos" = "end" ] && PATH="$PATH${d}:" || PATH=":$d$PATH"
    done
    PATH=${PATH%:}
    PATH=${PATH#:}
    export PATH
}

_catch() {
    local USE_V USE_X R STDOUT STDERR
    # check "verbose" option, turn if off if enabled, and save restore status USE_V
    [ "${-/v}" != "$-" ] && set +v && USE_V="-v" || USE_V="+v"
    # check "xtrace" option, turn if off if enabled, and save restore status USE_X
    [ "${-/x}" != "$-" ] && set +x && USE_X="-x" || USE_X="+x"
    eval "$({
        STDERR="$({ STDOUT="$("${@:3}")"; } 2>&1 && R=0 || R=$?; declare -p STDOUT >&2; exit $R)" && R=0 || R=$?
        declare -p STDERR
        declare -p R
    } 2>&1)"
    printf -v "$1" '%s' "$STDOUT"
    printf -v "$2" '%s' "$STDERR"
    set $USE_X
    set $USE_V
    return $R
}

__uname_machine() { uname --machine 2>/dev/null || uname -m 2>/dev/null || uname -p 2>/dev/null || echo "Unknown"; }
__uname_kernel_name() { uname --kernel-name 2>/dev/null || uname -s 2>/dev/null || echo "Unknown"; }
__uname_kernel_release() { uname --kernel-release 2>/dev/null || uname -r 2>/dev/null || uname -v 2>/dev/null || echo "Unknown"; }
__uname_all() { uname --all 2>/dev/null || uname -a 2>/dev/null || echo "Unknown"; }

_is() {
    local V="__CACHE_IS_$1"
    [ -z "${!V}" ] || return "${!V}"
    local R
    _cache __uname_kernel_name
    case "$1" in
        hpux)      [ "$_CACHE" = "HP-UX" ] && R=0 || R=1 ;;
        aix)       [ "$_CACHE" = "AIX" ] && R=0 || R=1 ;;
        sunos)     [ "$_CACHE" = "SunOS" ] && R=0 || R=1 ;;
        macos)     [ "$_CACHE" = "Darwin" ] && R=0 || R=1 ;;
        linux)     [ "$_CACHE" = "Linux" ] && R=0 || R=1 ;;
        cygwin)    [ "$_CACHE" = ${_CACHE#CYGWIN_NT*} ] && R=1 || R=0 ;;
        msys)      [ "$_CACHE" = ${_CACHE#MSYS_NT*} ] && R=1 || R=0 ;;
        mingw)     [ "$_CACHE" = ${_CACHE#MINGW*} ] && R=1 || R=0 ;;
        windows)   if _is cygwin || _is mingw || _is mingw; then R=0; else R=1; fi ;;
        unix)      if ! _is windows; then R=0; else R=1; fi ;;
        wsl)
            _cache __uname_kernel_release
            [ -z ${_CACHE%%*-WSL2} ] && R=0 || R=1
            ;;
        root)      [ "$(id -u 2>/dev/null)" = "0" ] && R=0 || R=1;;
        dockerenv) [ -f /.dockerenv ] && R=0 || R=1;;
        sudo)      [ -n "$SUDO_USER" ] && R=0 || R=1;;
        tmux)      [ -n "$TMUX" ] && R=0 || R=1;;
    esac
    printf -v "$V" '%s' "$R"
    return "${!V}"
}

_isnot() { _is "$1" && return 1 || return 0; }

if _is aix; then
    # Insert path to GNU utilities for AIX platform
    _addpath -start "/opt/freeware/bin"
elif _is sunos; then
    # Insert path to GNU utilities for Solaris platform
    _addpath -start "/usr/xpg4/bin"
elif _is macos; then
    # Add local bin directory
    # Insert path to GNU utilities for MacOS platform
    _addpath -start "/usr/local/bin" "/usr/local/opt/coreutils/libexec/gnubin"
elif _is msys || _is mingw; then
    for i in ucrt64 clang64 mingw64; do
        [ ! -d "/${i}/bin" ] || _addpath -start "/${i}/bin"
    done
    # Disable Automatic Unix -> Windows Path Conversion
    # https://www.msys2.org/docs/filesystem-paths/#automatic-unix-windows-path-conversion
    MSYS2_ARG_CONV_EXCL="*"
    export MSYS2_ARG_CONV_EXCL
    MSYS2_ENV_CONV_EXCL="*"
    export MSYS2_ENV_CONV_EXCL
fi

# try to use en_US.UTF-8 locale if available
if [ "$LANG" != "en_US.UTF-8" ] && _has locale && [ "$(LANG=en_US.UTF-8 locale charmap 2>/dev/null)" = "UTF-8" ]; then
    LANG="en_US.UTF-8"
    export LANG
fi

if _has tmux; then

    if [ -e "$IAM_HOME/tmux.conf" ]; then
        if [ "$(_get_size "$IAM_HOME/tmux.conf.template")" = "$(head -n 1 ~/.kk_home/tmux.conf | sed -E 's/^.+[[:space:]]//')" ]; then
            TMUX_CONF_CACHED=1
        fi
    fi

    [ -z "$TMUX_CONF_CACHED" ] && {
        # strip beta prefix for versions like '3.0a', '3.1c', etc.
        echo "# generated from tmux.conf.template, size: $(_get_size "$IAM_HOME/tmux.conf.template")"
        ver="$(tmux -V | sed -E -e 's/^.*[[:space:]]//' -e 's/[^[:digit:].]//')"
        unset blank
        while IFS= read -r line; do
            [ -z "$line" ] && [ -n "$blank" ] && continue || true
            unset min_ver max_ver
            case "$line" in
                [0-9].[0-9][+-]:*) min_ver="${line:0:3}"; line="${line:5}" ;;
                -[0-9].[0-9]:*)    max_ver="${line:1:3}"; line="${line:5}" ;;
                [0-9].[0-9]-[0-9].[0-9]:*)
                    min_ver="${line:0:3}"
                    max_ver="${line:4:3}"
                    line="${line:8}"
                    ;;
            esac
            [ -z "$min_ver" ] || { _vercomp "$min_ver" '<=' "$ver" || continue; }
            [ -z "$max_ver" ] || { _vercomp "$max_ver" '>=' "$ver" || continue; }
            [ -z "$line" ] && blank=1 || unset blank
            echo "$line"
        done
        unset min_ver max_ver line ver blank
    } < "$IAM_HOME/tmux.conf.template" > "$IAM_HOME/tmux.conf" || unset TMUX_CONF_CACHED

    # don't store session sockets in /tmp because they can be
    # cleared by anyone at any time
    TMUX_TMPDIR="$IAM_HOME/tmux_sessions"
    export TMUX_TMPDIR
    [ -e "$TMUX_TMPDIR" ] || mkdir -p "$TMUX_TMPDIR"

    if _isnot tmux; then

        # Restore tmux for session
        if [ -n "$__KITTY_ID" ] && [ -e "$IAM_HOME/kitty_sessions/$__KITTY_ID/tmux" ]; then
            # TMUX variable has session id without '$', also here we remove ',' between socker/server pid/session id
            SID="$(sed -E 's/,([^,]+),([^,]+)$/\1$\2/' "$IAM_HOME/kitty_sessions/$__KITTY_ID/tmux")"
            # tmux v3.0a doesn't support filter for 'list-sessions'
            if SID="$(tmux list-sessions -F"#{socket_path}#{pid}#{session_id}@@@@@#{session_name}" | grep --fixed-string "$SID" | sed -E 's/^.+@@@@@//')" ; then
                exec tmux attach-session -t "$SID"
            fi
        fi

        tmux() {
            if [ -z "$1" ]; then
                exec tmux -f "$IAM_HOME/tmux.conf" new
            else
                command tmux -f "$IAM_HOME/tmux.conf" "$@"
            fi
        }

    else
        alias tmux="tmux -f \"$IAM_HOME/tmux.conf\""
    fi

fi; # tmux

# GCP
if [ -f ~/gcloud/google-cloud-sdk/path.bash.inc ]; then
    . ~/gcloud/google-cloud-sdk/path.bash.inc
fi

_addpath -start "$IAM_HOME/tools/bin"
_addpath "/usr/local/bin"

# Add user PATH in cygwin
# https://stackoverflow.com/a/51430239
for fn in \
    "/proc/registry/HKEY_CURRENT_USER/Environment/Path" \
    "/proc/registry/HKEY_LOCAL_MACHINE/SYSTEM/CurrentControlSet/Control/Session Manager/Environment/Path"
do
    if [ -e "$fn" ]; then
        IFS= read -d $'\0' -r __val < "$fn"
        while read -r -d ';' p; do
            [ -n "$p" ] || continue
            p="${p/\%SystemRoot\%/$SYSTEMROOT}"
            p="${p/\%ProgramFiles\%/$PROGRAMFILES}"
            p="${p/\%USERPROFILE\%/$USERPROFILE}"
            p="${p/\%HomeDrive\%\%HomePath\%/$USERPROFILE}"
            _addpath "$(cygpath -u "$p")"
        done <<< "$__val;"
        unset p
        unset __val
    fi
done
unset fn

hostinfo() {

    local UNAME_MACHINE UNAME_RELEASE UNAME_ALL
    local MSHELL="unknown"

    ! _glob_match "*.*" "$BASH_VERSION" || MSHELL="bash $BASH_VERSION"
    ! _glob_match "*.*" "$ZSH_VERSION" || MSHELL="zsh $ZSH_VERSION"
    ! _glob_match "*zsh*" "$VERSION" || MSHELL="$VERSION"
    ! _glob_match "*PD*" "$SH_VERSION" || MSHELL="$SH_VERSION"
    ! _glob_match "*MIRBSD*" "$KSH_VERSION" || MSHELL="$KSH_VERSION"
    ! _glob_match "*.*|*POSH*" "$POSH_VERSION" || MSHELL="posh $POSH_VERSION"
    ! _glob_match "*.*" "$YASH_VERSION" || MSHELL="yash $YASH_VERSION"

    _cache __uname_machine
    UNAME_MACHINE="$_CACHE"
    _cache __uname_kernel_release
    UNAME_RELEASE="$_CACHE"
    _cache __uname_all
    UNAME_ALL="$_CACHE"

    if _is linux; then
        # Linux
        if [ -f /etc/redhat-release ]; then
            # RedHat
            UNAME_RELEASE="$(cat /etc/redhat-release)"
        elif [ -f /etc/alpine-release ]; then
            # Alpine
            UNAME_RELEASE="$(grep 'PRETTY_NAME=' /etc/os-release | cut -d= -f2 | tr -d '"')"
        elif [ -f /etc/SuSE-release ]; then
            # SUSE
            UNAME_RELEASE="SUSE Linux Enterprise Server $(grep VERSION /etc/SuSE-release | cut -d= -f2 | awk '{print $1}') SP$(grep PATCHLEVEL /etc/SuSE-release | cut -d= -f2 | awk '{print $1}')"
        elif [ -f /etc/lsb-release ]; then
            # Linux standard base, grep&sed in the box
            # * Ubuntu
            UNAME_RELEASE="$(grep DISTRIB_DESCRIPTION= /etc/lsb-release | sed 's/DISTRIB_DESCRIPTION\s*=\s*"//' | sed 's/""*$//')"
        else
            # Linux, unknown distr
            UNAME_RELEASE="Linux, unknown distributive"
        fi
        case "$UNAME_MACHINE" in
            x86_64) UNAME_MACHINE="Intel x86-64" ;;
            i386)   UNAME_MACHINE="Intel x86" ;;
        esac
    elif _is aix; then
        # AIX
        UNAME_MACHINE="$(lsattr -El proc0 -a type | cut -d ' ' -f 2) ($(prtconf -c); $(prtconf -k))"
        UNAME_RELEASE="AIX v$(oslevel)"
    elif _is macos; then
        # MacOS
        UNAME_RELEASE="$(sw_vers -productName) $(sw_vers -productVersion)"
        case "$UNAME_MACHINE" in
            i386)   UNAME_MACHINE="Intel x86";;
            x86-64) UNAME_MACHINE="Intel x86-64";;
            ppc)    UNAME_MACHINE="PowerPC";;
            ppc64)  UNAME_MACHINE="PowerPC-64";;
        esac
        UNAME_MACHINE="$UNAME_MACHINE (Kernel Type: $(getconf LONG_BIT)-bit)"
    elif _is cygwin; then
        # Cygwin on Windows
        UNAME_RELEASE="$(/usr/lib/csih/winProductName.exe)"
        case "$UNAME_MACHINE" in
            x86_64) UNAME_MACHINE="Intel x86-64" ;;
            i386)   UNAME_MACHINE="Intel x86" ;;
        esac
    elif _is mingw || _is msys; then
        # MSYS / MinGW on Windows
        UNAME_RELEASE="$(cmd /c "ver" | tr -d '\n\r')"
        case "$UNAME_MACHINE" in
            x86_64) UNAME_MACHINE="Intel x86-64" ;;
            i386)   UNAME_MACHINE="Intel x86" ;;
        esac
    elif _is hpux; then
        # HP-UX
        UNAME_MACHINE="$(model | sed -e 's/[[:space:]]*$//') (CPU Type: $(getconf HW_CPU_SUPP_BITS)-bit; Kernel Type: $(getconf KERNEL_BITS)-bit)"
        UNAME_RELEASE="HP-UX $UNAME_RELEASE"
    elif _is sunos; then
        # Solaris
        UNAME_RELEASE="$(head -n 1 /etc/release | sed 's/^ *//')"
        TMPARCH="$(isainfo -kv | cut -d ' ' -f 2)"
        case "$TMPARCH" in
            i386)   UNAME_MACHINE="Intel x86";;
            amd64)  UNAME_MACHINE="Intel x86-64";;
            sparc*) UNAME_MACHINE="SPARC ${TMPARCH:5}";;
        esac
        unset TMPARCH
        UNAME_MACHINE="$UNAME_MACHINE (Kernel Type: $(isainfo -b)-bit)"
    fi

    printf -- "------------------------------------------------------------------------------\n"
    printf -- "Hostname  : %s\n" "$HOSTNAME"
    printf -- "Kernel    : %s\n" "$UNAME_ALL"
    printf -- "Machine   : %s\n" "$UNAME_MACHINE"
    printf -- "Release   : %s\n" "$UNAME_RELEASE"
    printf -- "------------------------------------------------------------------------[ OS ]--\n"

    if ! _is dockerenv && ! _is sudo; then
        if _is linux || _is macos || _is sunos; then
            if [ -e /sbin/ifconfig ]; then
                # https://stackoverflow.com/questions/13322485/how-to-get-the-primary-ip-address-of-the-local-machine-on-linux-and-os-x
                int2ip() {
                    # avoid overflow in bash math
                    # _a=$(echo "$1 / 2^16" | bc)
                    # printf "%d.%d.%d.%d" $(($_a>>8&255)) $(($_a&255)) $(($1>>8&255)) $(($1&255))
                    printf "%d.%d.%d.%d" $(($1>>24)) $(($1>>16&255)) $(($1>>8&255)) $(($1&255))
                }
                ip2int() {
                    _a=(${1//./ })
                    printf "%u" $(( _a<<24 | ${_a[1]} << 16 | ${_a[2]} << 8 | ${_a[3]} ))
                }

                runOnMac=0
                while IFS=$' :\t\r\n' read a b c d; do
                    [ "$a" = "usage" ] && [ "$b" = "route" ] && runOnMac=1
                    if [ "x$runOnMac" = "x1" ]; then
                        case $a in
                            gateway )    gWay=$b  ;;
                            interface )  iFace=$b ;;
                        esac
                    else
                        [ "$a" = "0.0.0.0" ] && [ "$c" = "$a" ] && iFace=${d##* } gWay=$b
                    fi
                done < <(/sbin/route -n 2>&1 || /sbin/route -n get 0.0.0.0/0 2>&1 || true)

                [ -z "$gWay" ] && gw=0 || gw=$(ip2int $gWay)

                while read lhs rhs; do
                    [ "$lhs" ] && {
                        [ "x$lhs" != "xinet" ] && [ "x$lhs" != "xinet6" ] && iface="$lhs"
                        [ -z "${lhs#*:}" ] && iface=${lhs%:}
                        [ "x$lhs" = "xinet" ] && {
                            mask=${rhs#*netmask }
                            mask=${mask#*Mask:}
                            mask=${mask%% *}
                            case "$mask" in
                                0x*) mask="$(printf %u $mask)"; ;;
                                f*)  mask="$(printf %u 0x$mask)"; ;;
                                *)   mask="$(ip2int $mask)"; ;;
                            esac
                            myIp=${rhs%% *}
                            myIp=${myIp#*addr:}
                            ip=$(ip2int $myIp)
                            netMask=$(int2ip $mask)
                            (( ( ip & mask ) == ( gw & mask ) )) && myGway=", gw: $gWay" || myGway=
                            [ "x$myIp" != "x127.0.0.1" ] && \
                                printf -- "Interface : %s (name: '%s', mask: %s%s)\n" "$myIp" "$iface" "$netMask" "$myGway"
                        }
                    }
                done < <(/sbin/ifconfig 2>&1 || /sbin/ifconfig -a)

                printf -- "-------------------------------------------------------------------[ Network ]--\n"
            fi
        fi
    fi

    _showfeature() {

        local line
        local width=15

        for f in "$@"; do

            local feature
            local state
            local part
            local color

            feature="${f%:*}"
            state="${f#*:}"

            if [ "$feature" = "$state" ]; then
                _has "$feature" && state=0 || state=1
            elif [ "$state" != 1 ] && [ "$state" != 0 ]; then
                _has "$state" && state=0 || state=1
            fi

            if [ "$state" = "0" ]; then
                color="$COLOR_GREEN"
            elif [ "$state" = "1" ]; then
                color="$COLOR_DEFAULT"
            else
                color="$COLOR_RED"
            fi

            part="$(printf "${COLOR_GRAY}[ %s%-${width}s${COLOR_GRAY} ]${COLOR_DEFAULT}" "$color" "$feature")"

            if [ -z "$line" ]; then
                line="$part"
            else
                line="$line $part"
            fi

        done

        echo "$line"

    }

    _showinfo() {
        # $1 - info type
        # $2 - total
        # $3 - free
        # $4 - additional info
        # $5 - additional info

        local infoType="$1"
        local total="$2"
        local free="$3"
        local add="$4"
        local add2="$5"

        gauge() {
            # $1 - total
            # $2 - free
            # $3 - color
            local PRC1
            local PRC2
            PRC1=$(( 100 - 100 * ($1 - $2) / $1 ))
            PRC2=$(( $PRC1 / 4 ))
            PRC2="$(printf "%${PRC2}s")"
            PRC2="${PRC2// /=}"
            if [ "$PRC1" != '100' ]; then
                PRC1=$(printf '%02d' "$PRC1")
            fi
            printf "${COLOR_GRAY}[${COLOR_BLUE}%-25s${COLOR_GRAY}]${COLOR_DEFAULT} ${3}%3s%%${COLOR_DEFAULT}" "$PRC2" "$PRC1"
        }

        local color="$(( 100 - 100 * ($total - $free) / $total ))"

        if [ $color -gt 19 ]; then
            color="${COLOR_GREEN}"
        elif [ $color -gt 9 ]; then
            color="${COLOR_YELLOW}"
        else
            color="${COLOR_LIGHTRED}"
        fi

        local gauge=$(gauge $total $free $color)

        local units="MB"
        if [ "$total" -gt 1022976 ]; then
            total="$(( 100 * $total / 1024 / 1024 ))e-2"
            free="$(( 100 * $free / 1024 / 1024 ))e-2"
            units="TB"
        elif [ "$total" -gt 999 ]; then
            total="$(( 100 * $total / 1024 ))e-2"
            free="$(( 100 * $free / 1024 ))e-2"
            units="GB"
        else
            total="$(( 100 * $total ))e-2"
            free="$(( 100 * $free ))e-2"
        fi

        total="$(printf '%.2f %s' "$total" "$units")"
        free="$(printf '%.2f %s' "$free" "$units")"

        if [ -n "$add" ]; then
            add="  ${COLOR_WHITE}$add${COLOR_DEFAULT}"
        fi

        if [ -n "$add2" ]; then
            add2=" ${COLOR_GRAY}$add2${COLOR_DEFAULT}"
        fi

        printf -- "%-9s : Free ${color}%9s${COLOR_DEFAULT} of %9s %s%s%s\n" "$infoType" "$free" "$total" "$gauge" "$add" "$add2"

    }

    if ! _is dockerenv && ! _is sudo; then

        local MEM_TOTAL="" MEM_FREE SWAP_TOTAL SWAP_FREE

        if [ -f /proc/meminfo ]; then

            local _buffers=0 _cached=0 _memTotal _memFree _swapTotal _swapFree

            while IFS=$' :\t\r\n' read a b c; do
                case "$a" in
                    MemTotal)  _memTotal="$b";;
                    MemFree)   _memFree="$b";;
                    Buffers)   _buffers="$b";;
                    Cached)    _cached="$b";;
                    SwapTotal) _swapTotal="$b";;
                    SwapFree)  _swapFree="$b";;
                esac
            done < /proc/meminfo

            MEM_TOTAL=$(( $_memTotal / 1024 ))
            MEM_FREE=$(( ($_memFree + $_buffers + $_cached) / 1024 ))
            SWAP_TOTAL=$(( $_swapTotal / 1024 ))
            SWAP_FREE=$(( $_swapFree / 1024 ))

        elif _has vm_stat; then

            read SWAP_TOTAL SWAP_FREE <<< $(sysctl vm.swapusage | awk '{ print $4 "\n" $10 }')
            SWAP_TOTAL="${SWAP_TOTAL%%.*}"
            SWAP_FREE="${SWAP_FREE%%.*}"

            MEM_TOTAL="$(sysctl hw.memsize | awk '{ print $NF }')"
            MEM_TOTAL="$(( $MEM_TOTAL / 1024 / 1024 ))"

            MEM_FREE=0
            while IFS=$':\r\n' read a b; do
                if [ "$a" = "Pages free" ] || [ "$a" = "Pages inactive" ] || [ "$a" = "Pages speculative" ]; then
                    b="${b// /}"
                    b="${b//./}"
                    MEM_FREE="$(( $MEM_FREE + $b ))"
                fi
            done < <(vm_stat)
            MEM_FREE="$(( $MEM_FREE * 4096 / 1024 / 1024 ))"

        fi

        if [ -n "$MEM_TOTAL" ]; then
            _showinfo "RAM" "$MEM_TOTAL" "$MEM_FREE"
            if [ $SWAP_TOTAL -eq 0 ]; then
                printf -- "Swap      : %s\n" "${COLOR_BROWN}Not installed${COLOR_DEFAULT}"
            else
                _showinfo "Swap" "$SWAP_TOTAL" "$SWAP_FREE"
            fi
            printf -- "--------------------------------------------------------------------[ Memory ]--\n"
        fi

    fi

    if ! _is dockerenv && ! _is sudo; then
        # df (GNU coreutils) 8.32
        #   Filesystem     1M-blocks  Used Available Use% Mounted on
        #   /dev/disk1s5      476612 10744    315301   4% /
        # BSD df
        #   Filesystem     1M-blocks  Used Available Capacity iused      ifree %iused  Mounted on
        #   /dev/disk1s5s1    476802  9486    383863     3%  356050 3930762280    0%   /
        if _is linux; then
            while IFS=$' \t\r\n' read a b c d e f; do

                [ "$f" = "/dev/shm" ] && continue
                [ "$f" = "/dev" ]     && continue
                [ "$f" = "/run" ]     && continue
                [ "$f" = "/boot" ]    && continue
                [ "${f:0:5}" = "/sys/" ] && continue
                [ "${f:0:5}" = "/run/" ] && continue
                [ "${f:0:6}" = "/boot/" ] && continue

                # hide WSL volumes
                if _is wsl; then
                    # [ "$f" = "/init" ]                && continue
                    [ "${f:0:13}" = "/usr/lib/wsl/" ] && continue
                fi

                if [ "$a" = "${a%:*}" ]; then
                    unset a
                else
                    a="(nfs: $a)"
                fi

                _showinfo "Mount" "$b" "$d" "$f" "$a"

            done < <(df -m -P | tail -n +2 | grep -v '^/dev/loop')
        elif _is macos; then
            while IFS=$' \t\r\n' read a b c d e f g h i; do
                # if BSD df
                _check df --version || f="$i"
                _showinfo "Mount" "$b" "$d" "$f"
            done < <(df -m 2>/dev/null | tail -n +2 | grep -v -E ' +0 +0 +0 +100%')
        elif _is sunos; then
            while IFS=$' \t\r\n' read a b c d e f; do

                [ "$f" = "/var/run" ] && continue
                [ "$f" = "/etc/svc/volatile" ] && continue
                [ "$f" = "/lib/libc.so.1" ]  && continue

                b="$(( $b / 1024 ))"
                d="$(( $d / 1024 ))"
                _showinfo "Mount" "$b" "$d" "$f"

            done < <(df -k -t | tail -n +2 | grep -v -E ' +0 +0 +0 +0%')
        elif _is hpux; then
            while IFS=$' \t\r\n' read a b c d e f; do

                b="$(( $b / 1024 ))"
                d="$(( $d / 1024 ))"
                _showinfo "Mount" "$b" "$d" "$f"

            done < <(df -P -k | tail -n +2)
        elif _is aix; then
            while IFS=$' \t\r\n' read a b c d e f; do

                _showinfo "Mount" "$b" "$d" "$f"

            done < <(df -m -P | tail -n +2 | grep -v -E ' +- +- +0 +-')
        elif _is windows; then
            while IFS=$' ,\t\r\n' read a b c d; do

                [ -z "$c" ] && continue

                b="$(( $b / 1024 / 1024 ))"
                c="$(( $c / 1024 / 1024 ))"

                _showinfo "Mount" "$c" "$b" "$a"

            done < <(wmic logicaldisk get Caption,FreeSpace,Size | tail -n +2)
        fi
        unset a b c d e f g h i
        printf -- "----------------------------------------------------------------[ Filesystem ]--\n"
    fi

    # long parameters such as '--user' and '--name' are not supported on some platforms
    printf -- "Username  : %s\n" "$(id --user --name 2>/dev/null || id -u -n)"
    printf -- "Shell     : %s\n" "$MSHELL"
    printf -- "----------------------------------------------------------------------[ User ]--\n"

    local DOCKER_COMPOSE_V2=1
    if _has docker && docker compose version >/dev/null 2>&1; then
        DOCKER_COMPOSE_V2=0
    fi

    _showfeature "AWS CLI:aws" "gcloud CLI:gcloud"
    _showfeature "docker" "docker-comp.V1:docker-compose" "docker-comp.V2:$DOCKER_COMPOSE_V2"
    _showfeature "kubectl" "eksctl" "OpenShift CLI:oc"
    _showfeature "vim" "git" "curl" "wget"
    _showfeature "gpg" "tmux"

    if _has sudo; then
        local SUDO_STATUS="$(printf '' | LC_ALL=C sudo -l -S 2>&1)"
        local SUDO_AVAIL="$(echo "$SUDO_STATUS" | grep --fixed-strings --silent 'may run'; echo $?)"
        local SUDO_NOPASS="$(echo "$SUDO_STATUS" | grep --fixed-strings --silent 'NOPASSWD'; echo $?)"
        _showfeature \
            "sudo avail:$SUDO_AVAIL" \
            "sudo nopass:$SUDO_NOPASS"
    fi

    printf -- "------------------------------------------------------------------[ Features ]--\n\n"

}

_is tmux || hostinfo

mkdir -p "$IAM_HOME/state"

KUBECONFIG="$IAM_HOME/kubeconfig"
export KUBECONFIG

# Don't want my shell to warn me of incoming mail.
unset MAILCHECK

if _has git; then
    __GIT_VERSION="$(command git --version | awk '{print $3}')"

    GIT_CONFIG_GLOBAL="$IAM_HOME/gitconfig"
    export GIT_CONFIG_GLOBAL
fi

if _has gpg; then

    GNUPGHOME="$IAM_HOME/gnupg"
    export GNUPGHOME
    mkdir -p "$GNUPGHOME"
    # avoid:
    #  gpg: WARNING: unsafe permissions on homedir
    chmod 0700 "$GNUPGHOME"

    # required for GPG
    GPG_TTY="$(tty)"
    export GPG_TTY

fi

# See http://stackoverflow.com/questions/791765/unable-to-forward-search-bash-history-similarly-as-with-ctrl-r to make ctrl-s work forward
stty -ixon

# Shell options
# notify - Notify when jobs running in background terminate
set -o notify
# cdspell - If set, minor errors in the spelling of a directory component in a cd command will be corrected.
shopt -s cdspell
# This option is for bash only
if [ -n "$BASH_VERSION" ]; then
    # dirspell - If set, Bash attempts spelling correction on directory names during word completion if the directory name initially supplied does not exist.
    shopt -s dirspell 2>/dev/null || echo "FYI: 'dirspell' bash option is not supported."
fi
# checkwinsize - If set, Bash checks the window size after each command and, if necessary, updates the values of LINES and COLUMNS.
shopt -s checkwinsize
# cmdhist - If set, Bash attempts to save all lines of a multiple-line command in the same history entry. This allows easy re-editing of multi-line commands.
shopt -s cmdhist
# mailwarn - If set, and a file that Bash is checking for mail has been accessed since the last time it was checked, the message "The mail in mailfile has been read" is displayed.
shopt -u mailwarn

# Readline options
# Be 8 bit clean
bind "set input-meta on"
bind "set output-meta on"
# show-all-if-ambiguous - words which have more than one possible completion
# cause the matches to be listed immediately instead of ringing the bell
bind "set show-all-if-ambiguous on"
# Be more intelligent when autocompleting by also looking at the text after
# the cursor. For example, when the current line is "cd ~/src/mozil", and
# the cursor is on the "z", pressing Tab will not autocomplete it to "cd
# ~/src/mozillail", but to "cd ~/src/mozilla". (This is supported by the
# Readline used by Bash 4.)
bind "set skip-completed-text on"
# add colors
bind "set colored-completion-prefix on"
bind "set colored-stats on"
# mark-directories - if set to `on', completed directory names have a slash appended.
bind "set mark-directories on"
# mark-symlinked-directories - if set to `on', completed names which are
# symbolic links to directories have a slash appended
bind "set mark-symlinked-directories on"
# visible-stats - If set to `on', a character denoting a file's type is
# appended to the filename when listing possible completions.
bind "set visible-stats on"
# enable blink on parens match
bind "set blink-matching-paren on"
# turn off the use of the internal pager when returning long completion lists
bind "set page-completions off"

# How to find out keys:
# 1. run "od -c"
# 2. press key
# 3. press <enter>
# 4. press <ctrl-d>

# allow the use of the Home/End keys
bind '"\e[1~": beginning-of-line'
bind '"\e[4~": end-of-line'

# allow the use of the Delete/Insert keys
bind '"\e[3~": delete-char'
bind '"\e[2~": quoted-insert'

# bind arrow keys to search in history
#bind '"\e[A": history-search-backward'
#bind '"\e[B": history-search-forward'
# ctrl+arrow_left/arrow_right - word backward/word forward
bind '"\e[1;5D": backward-word'
bind '"\e[1;5C": forward-word'

ls() {
    set -- -F -l "$@"
    ! _check command ls --color=auto --version || set -- --color=auto "$@"
    ! _check command ls -h --version || set -- -h "$@"
    ! _check command ls --group-directories-first --version || set -- --group-directories-first "$@"
    # CLICOLOR / LSCOLORS are for BSD ls
    # https://github.com/trapd00r/LS_COLORS
    # Version: 0.254
    # Updated: Tue Mar 29 21:25:30 AEST 2016
    # fixes:
    #   1. 'ca=' is removed. It is incompatible with some environments.
    # How-to generate:
    #   1. Download https://github.com/trapd00r/LS_COLORS/blob/master/LS_COLORS
    #   2. Run: $ dircolors -b ./LS_COLORS
    env \
        CLICOLOR=1 \
        LSCOLORS=GxFxCxDxBxegedabagaced \
        LS_COLORS='bd=38;5;68:cd=38;5;113;1:di=38;5;30:do=38;5;127:ex=38;5;208;1:pi=38;5;126:fi=0:ln=target:mh=38;5;222;1:no=0:or=48;5;196;38;5;232;1:ow=38;5;220;1:sg=48;5;3;38;5;0:su=38;5;220;1;3;100;1:so=38;5;197:st=38;5;86;48;5;234:tw=48;5;235;38;5;139;3:*LS_COLORS=48;5;89;38;5;197;1;3;4;7:*README=38;5;220;1:*README.rst=38;5;220;1:*LICENSE=38;5;220;1:*COPYING=38;5;220;1:*INSTALL=38;5;220;1:*COPYRIGHT=38;5;220;1:*AUTHORS=38;5;220;1:*HISTORY=38;5;220;1:*CONTRIBUTORS=38;5;220;1:*PATENTS=38;5;220;1:*VERSION=38;5;220;1:*NOTICE=38;5;220;1:*CHANGES=38;5;220;1:*.log=38;5;190:*.txt=38;5;253:*.etx=38;5;184:*.info=38;5;184:*.markdown=38;5;184:*.md=38;5;184:*.mkd=38;5;184:*.nfo=38;5;184:*.pod=38;5;184:*.rst=38;5;184:*.tex=38;5;184:*.textile=38;5;184:*.bib=38;5;178:*.json=38;5;178:*.msg=38;5;178:*.pgn=38;5;178:*.rss=38;5;178:*.xml=38;5;178:*.yaml=38;5;178:*.yml=38;5;178:*.RData=38;5;178:*.rdata=38;5;178:*.cbr=38;5;141:*.cbz=38;5;141:*.chm=38;5;141:*.djvu=38;5;141:*.pdf=38;5;141:*.PDF=38;5;141:*.docm=38;5;111;4:*.doc=38;5;111:*.docx=38;5;111:*.eps=38;5;111:*.ps=38;5;111:*.odb=38;5;111:*.odt=38;5;111:*.rtf=38;5;111:*.odp=38;5;166:*.pps=38;5;166:*.ppt=38;5;166:*.pptx=38;5;166:*.ppts=38;5;166:*.pptxm=38;5;166;4:*.pptsm=38;5;166;4:*.csv=38;5;78:*.ods=38;5;112:*.xla=38;5;76:*.xls=38;5;112:*.xlsx=38;5;112:*.xlsxm=38;5;112;4:*.xltm=38;5;73;4:*.xltx=38;5;73:*cfg=1:*conf=1:*rc=1:*.ini=1:*.plist=1:*.viminfo=1:*.pcf=1:*.psf=1:*.git=38;5;197:*.gitignore=38;5;240:*.gitattributes=38;5;240:*.gitmodules=38;5;240:*.awk=38;5;172:*.bash=38;5;172:*.bat=38;5;172:*.BAT=38;5;172:*.sed=38;5;172:*.sh=38;5;172:*.zsh=38;5;172:*.vim=38;5;172:*.ahk=38;5;41:*.py=38;5;41:*.ipynb=38;5;41:*.rb=38;5;41:*.pl=38;5;208:*.PL=38;5;160:*.t=38;5;114:*.msql=38;5;222:*.mysql=38;5;222:*.pgsql=38;5;222:*.sql=38;5;222:*.tcl=38;5;64;1:*.r=38;5;49:*.R=38;5;49:*.gs=38;5;81:*.asm=38;5;81:*.cl=38;5;81:*.lisp=38;5;81:*.lua=38;5;81:*.moon=38;5;81:*.c=38;5;81:*.C=38;5;81:*.h=38;5;110:*.H=38;5;110:*.tcc=38;5;110:*.c++=38;5;81:*.h++=38;5;110:*.hpp=38;5;110:*.hxx=38;5;110:*.ii=38;5;110:*.M=38;5;110:*.m=38;5;110:*.cc=38;5;81:*.cs=38;5;81:*.cp=38;5;81:*.cpp=38;5;81:*.cxx=38;5;81:*.cr=38;5;81:*.go=38;5;81:*.f=38;5;81:*.for=38;5;81:*.ftn=38;5;81:*.s=38;5;110:*.S=38;5;110:*.rs=38;5;81:*.swift=38;5;219:*.sx=38;5;81:*.hi=38;5;110:*.hs=38;5;81:*.lhs=38;5;81:*.pyc=38;5;240:*.css=38;5;125;1:*.less=38;5;125;1:*.sass=38;5;125;1:*.scss=38;5;125;1:*.htm=38;5;125;1:*.html=38;5;125;1:*.jhtm=38;5;125;1:*.mht=38;5;125;1:*.eml=38;5;125;1:*.mustache=38;5;125;1:*.coffee=38;5;074;1:*.java=38;5;074;1:*.js=38;5;074;1:*.mjs=38;5;074;1:*.jsm=38;5;074;1:*.jsm=38;5;074;1:*.jsp=38;5;074;1:*.php=38;5;81:*.ctp=38;5;81:*.twig=38;5;81:*.vb=38;5;81:*.vba=38;5;81:*.vbs=38;5;81:*Dockerfile=38;5;155:*.dockerignore=38;5;240:*Makefile=38;5;155:*MANIFEST=38;5;243:*pm_to_blib=38;5;240:*.am=38;5;242:*.in=38;5;242:*.hin=38;5;242:*.scan=38;5;242:*.m4=38;5;242:*.old=38;5;242:*.out=38;5;242:*.SKIP=38;5;244:*.diff=48;5;197;38;5;232:*.patch=48;5;197;38;5;232;1:*.bmp=38;5;97:*.tiff=38;5;97:*.tif=38;5;97:*.TIFF=38;5;97:*.cdr=38;5;97:*.gif=38;5;97:*.ico=38;5;97:*.jpeg=38;5;97:*.JPG=38;5;97:*.jpg=38;5;97:*.nth=38;5;97:*.png=38;5;97:*.psd=38;5;97:*.xpm=38;5;97:*.ai=38;5;99:*.eps=38;5;99:*.epsf=38;5;99:*.drw=38;5;99:*.ps=38;5;99:*.svg=38;5;99:*.avi=38;5;114:*.divx=38;5;114:*.IFO=38;5;114:*.m2v=38;5;114:*.m4v=38;5;114:*.mkv=38;5;114:*.MOV=38;5;114:*.mov=38;5;114:*.mp4=38;5;114:*.mpeg=38;5;114:*.mpg=38;5;114:*.ogm=38;5;114:*.rmvb=38;5;114:*.sample=38;5;114:*.wmv=38;5;114:*.3g2=38;5;115:*.3gp=38;5;115:*.gp3=38;5;115:*.webm=38;5;115:*.gp4=38;5;115:*.asf=38;5;115:*.flv=38;5;115:*.ts=38;5;115:*.ogv=38;5;115:*.f4v=38;5;115:*.VOB=38;5;115;1:*.vob=38;5;115;1:*.3ga=38;5;137;1:*.S3M=38;5;137;1:*.aac=38;5;137;1:*.au=38;5;137;1:*.dat=38;5;137;1:*.dts=38;5;137;1:*.fcm=38;5;137;1:*.m4a=38;5;137;1:*.mid=38;5;137;1:*.midi=38;5;137;1:*.mod=38;5;137;1:*.mp3=38;5;137;1:*.mp4a=38;5;137;1:*.oga=38;5;137;1:*.ogg=38;5;137;1:*.opus=38;5;137;1:*.s3m=38;5;137;1:*.sid=38;5;137;1:*.wma=38;5;137;1:*.ape=38;5;136;1:*.aiff=38;5;136;1:*.cda=38;5;136;1:*.flac=38;5;136;1:*.alac=38;5;136;1:*.midi=38;5;136;1:*.pcm=38;5;136;1:*.wav=38;5;136;1:*.wv=38;5;136;1:*.wvc=38;5;136;1:*.afm=38;5;66:*.fon=38;5;66:*.fnt=38;5;66:*.pfb=38;5;66:*.pfm=38;5;66:*.ttf=38;5;66:*.otf=38;5;66:*.PFA=38;5;66:*.pfa=38;5;66:*.7z=38;5;40:*.a=38;5;40:*.arj=38;5;40:*.bz2=38;5;40:*.cpio=38;5;40:*.gz=38;5;40:*.lrz=38;5;40:*.lz=38;5;40:*.lzma=38;5;40:*.lzo=38;5;40:*.rar=38;5;40:*.s7z=38;5;40:*.sz=38;5;40:*.tar=38;5;40:*.tgz=38;5;40:*.xz=38;5;40:*.z=38;5;40:*.Z=38;5;40:*.zip=38;5;40:*.zipx=38;5;40:*.zoo=38;5;40:*.zpaq=38;5;40:*.zz=38;5;40:*.apk=38;5;215:*.deb=38;5;215:*.rpm=38;5;215:*.jad=38;5;215:*.jar=38;5;215:*.cab=38;5;215:*.pak=38;5;215:*.pk3=38;5;215:*.vdf=38;5;215:*.vpk=38;5;215:*.bsp=38;5;215:*.dmg=38;5;215:*.r[0-9]{0,2}=38;5;239:*.zx[0-9]{0,2}=38;5;239:*.z[0-9]{0,2}=38;5;239:*.part=38;5;239:*.dmg=38;5;124:*.iso=38;5;124:*.bin=38;5;124:*.nrg=38;5;124:*.qcow=38;5;124:*.sparseimage=38;5;124:*.toast=38;5;124:*.vcd=38;5;124:*.vmdk=38;5;124:*.accdb=38;5;60:*.accde=38;5;60:*.accdr=38;5;60:*.accdt=38;5;60:*.db=38;5;60:*.fmp12=38;5;60:*.fp7=38;5;60:*.localstorage=38;5;60:*.mdb=38;5;60:*.mde=38;5;60:*.sqlite=38;5;60:*.typelib=38;5;60:*.nc=38;5;60:*.pacnew=38;5;33:*.un~=38;5;241:*.orig=38;5;241:*.BUP=38;5;241:*.bak=38;5;241:*.o=38;5;241:*core=38;5;241:*.rlib=38;5;241:*.swp=38;5;244:*.swo=38;5;244:*.tmp=38;5;244:*.sassc=38;5;244:*.pid=38;5;248:*.state=38;5;248:*lockfile=38;5;248:*.err=38;5;160;1:*.error=38;5;160;1:*.stderr=38;5;160;1:*.aria2=38;5;241:*.dump=38;5;241:*.stackdump=38;5;241:*.zcompdump=38;5;241:*.zwc=38;5;241:*.pcap=38;5;29:*.cap=38;5;29:*.dmp=38;5;29:*.DS_Store=38;5;239:*.localized=38;5;239:*.CFUserTextEncoding=38;5;239:*.allow=38;5;112:*.deny=38;5;196:*.service=38;5;45:*@.service=38;5;45:*.socket=38;5;45:*.swap=38;5;45:*.device=38;5;45:*.mount=38;5;45:*.automount=38;5;45:*.target=38;5;45:*.path=38;5;45:*.timer=38;5;45:*.snapshot=38;5;45:*.application=38;5;116:*.cue=38;5;116:*.description=38;5;116:*.directory=38;5;116:*.m3u=38;5;116:*.m3u8=38;5;116:*.md5=38;5;116:*.properties=38;5;116:*.sfv=38;5;116:*.srt=38;5;116:*.theme=38;5;116:*.torrent=38;5;116:*.urlview=38;5;116:*.asc=38;5;192;3:*.bfe=38;5;192;3:*.enc=38;5;192;3:*.gpg=38;5;192;3:*.signature=38;5;192;3:*.sig=38;5;192;3:*.p12=38;5;192;3:*.pem=38;5;192;3:*.pgp=38;5;192;3:*.asc=38;5;192;3:*.enc=38;5;192;3:*.sig=38;5;192;3:*.32x=38;5;213:*.cdi=38;5;213:*.fm2=38;5;213:*.rom=38;5;213:*.sav=38;5;213:*.st=38;5;213:*.a00=38;5;213:*.a52=38;5;213:*.A64=38;5;213:*.a64=38;5;213:*.a78=38;5;213:*.adf=38;5;213:*.atr=38;5;213:*.gb=38;5;213:*.gba=38;5;213:*.gbc=38;5;213:*.gel=38;5;213:*.gg=38;5;213:*.ggl=38;5;213:*.ipk=38;5;213:*.j64=38;5;213:*.nds=38;5;213:*.nes=38;5;213:*.sms=38;5;213:*.pot=38;5;7:*.pcb=38;5;7:*.mm=38;5;7:*.pod=38;5;7:*.gbr=38;5;7:*.spl=38;5;7:*.scm=38;5;7:*.Rproj=38;5;11:*.sis=38;5;7:*.1p=38;5;7:*.3p=38;5;7:*.cnc=38;5;7:*.def=38;5;7:*.ex=38;5;7:*.example=38;5;7:*.feature=38;5;7:*.ger=38;5;7:*.map=38;5;7:*.mf=38;5;7:*.mfasl=38;5;7:*.mi=38;5;7:*.mtx=38;5;7:*.pc=38;5;7:*.pi=38;5;7:*.plt=38;5;7:*.pm=38;5;7:*.rdf=38;5;7:*.rst=38;5;7:*.ru=38;5;7:*.sch=38;5;7:*.sty=38;5;7:*.sug=38;5;7:*.t=38;5;7:*.tdy=38;5;7:*.tfm=38;5;7:*.tfnt=38;5;7:*.tg=38;5;7:*.vcard=38;5;7:*.vcf=38;5;7:*.xln=38;5;7:*.iml=38;5;166:*.xcconfig=1:*.entitlements=1:*.strings=1:*.storyboard=38;5;196:*.xcsettings=1:*.xib=38;5;208:' \
        ls "$@"
}

_hasnot ps || psa() {
    _check command ps --version && set -- aux "$@" || set -- -e -f "$@"
    env ps "$@"
}

_hasnot ps || psaf() {
    _check command ps --version && set -- auxf "$@" || set -- -e -f "$@"
    env ps "$@"
}

_hasnot grep || grep() {
    ! _check command grep --color=auto --version || set -- --color=auto "$@"
    env grep "$@"
}

_hasnot grep || grepzip() {
    local ret i start_fn
    for (( i = 1; $i <= $#; i++ )); do
        _glob_match "*.zip" "${!i}" || continue
        start_fn=$i
        break
    done
    [ -n "$start_fn" ] || { echo "Error: zip files in command line were not found." >&2; return 1; }
    for (( i = $start_fn; $i <= $#; i++ )); do
        local TEMP_DIR="$(mktemp --directory)"
        if unzip -q "${!i}" -d "$TEMP_DIR"; then
            grep "${@:1:$(( start_fn - 1 ))}" -r "$TEMP_DIR" || true
        else
            ret=$?
        fi
        rm -rf "$TEMP_DIR"
        [ -z "$ret" ] || return $ret
    done
}

_hasnot ip || ip() {
    ! _check command ip -color -Version || set -- -color "$@"
    env ip "$@"
}

# GNU diffutils 3.4+ (2016-08-08)
_hasnot diff || diff() {
    # don't add color parameters if stdout is not terminal
    if [ -t 1 ]; then
        # :ad=[ ANSI code] - added lines
        # :de=[ ANSI code] - deleted lines
        # :ln=[ ANSI code] - line numbers.
        ! _check command diff --color=auto --version || set -- --palette=':ad=32:de=31:ln=35' --color=auto "$@"
    fi
    env diff "$@"
}

shellcheck() {
    if [ -e "$IAM_HOME/tools/bin/install-shellcheck" ]; then
        "$IAM_HOME/tools/bin/install-shellcheck" "$IAM_HOME/tools/bin"
    fi
    env shellcheck "$@"
}

alias mv='mv -i'

alias mkdir='mkdir -p'
alias mkcd='_(){ mkdir -p $1; cd $1; }; _'
alias mkcdtmp='_(){ cd "$(test -z "$1" && mktemp -d || mktemp -d -t "${1}.XXXXXXX")"; }; _'

alias ..='cd ..'

alias tailf='tail -F'

alias ff='find . -name'

if _has vim; then
    EDITOR="vim -u $IAM_HOME/vimrc -i $IAM_HOME/viminfo"
elif _has vi; then
    EDITOR=vi
else
    echo "${COLOR_RED}Warning: vi/vim not found${COLOR_DEFAULT}"
    echo
fi
export EDITOR

alias vi=vim
vim() {
    local CMD="vim"
    if _hasnot vim; then
        if [ -e "$IAM_HOME/tools/bin/install-vim-portable" ]; then
            "$IAM_HOME/tools/bin/install-vim-portable" "$IAM_HOME/tools/bin"
        fi
        CMD="vim-portable"
    fi
    if _isnot tmux; then
        if [ -e "$IAM_HOME/kitty_sessions/$__KITTY_ID" ]; then
            if [ -e "$IAM_HOME/kitty_sessions/$__KITTY_ID/vim" ]; then
                set -- $(cat "$IAM_HOME/kitty_sessions/$__KITTY_ID/vim")
            else
                echo "$@" > "$IAM_HOME/kitty_sessions/$__KITTY_ID/vim"
            fi
        fi
    fi
    command "$CMD" -u "$IAM_HOME/vimrc" -i "$IAM_HOME/viminfo" "$@"
    if _isnot tmux && [ -e "$IAM_HOME/kitty_sessions/$__KITTY_ID" ]; then
        rm -f "$IAM_HOME/kitty_sessions/$__KITTY_ID/vim"
    fi
}

[ -d "$IAM_HOME/vim_swap" ] || mkdir -p "$IAM_HOME/vim_swap"

_has apt-get && apt-get() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "${COLOR_RED}The 'sudo' prefix was added automatically for the 'apt-get' command${COLOR_DEFAULT}" >&2
        sudo apt-get "$@"
    else
        command apt-get "$@"
    fi
}

_has apt && apt() {
    if [ "$(id -u)" -ne 0 ]; then
        case "$1" in
            install|remove|purge|autoremove|update|upgrade|full-upgrade|edit-sources)
                echo "${COLOR_RED}The 'sudo' prefix was added automatically for the 'apt' command${COLOR_DEFAULT}" >&2
                sudo apt "$@"
            ;;
            *) command apt "$@"
            ;;
        esac
    else
        command apt "$@"
    fi
}

man() {
    # LESS man page colors (makes Man pages more readable).
    env \
        LESS_TERMCAP_mb=$'\E[01;31m' \
        LESS_TERMCAP_md=$'\E[01;31m' \
        LESS_TERMCAP_me=$'\E[0m' \
        LESS_TERMCAP_se=$'\E[0m' \
        LESS_TERMCAP_so=$'\E[01;44;33m' \
        LESS_TERMCAP_ue=$'\E[0m' \
        LESS_TERMCAP_us=$'\E[01;32m' \
        man "$@"
}

#magic

__magic_ssh() {
    printf '%s\n' \
        "IAM=\"$IAM\" && export IAM" \
        "IAM_HOME=\"\$HOME/.${IAM}_home\" && export IAM_HOME" \
        "SSH_PUB_KEY=\"$SSH_PUB_KEY\" && export SSH_PUB_KEY" \
        "_GIT_USER_NAME=\"$_GIT_USER_NAME\" && export _GIT_USER_NAME" \
        "_GIT_USER_EMAIL=\"$_GIT_USER_EMAIL\" && export _GIT_USER_EMAIL" \
        "[ -d \"\$IAM_HOME\" ] || mkdir -p \"\$IAM_HOME\"" \
        "if [ \"\$TERM\" = 'xterm' ]; then TERM='xterm-256color'; export TERM; fi" \
        "if [ \"\$TERM\" = 'xterm-256color' -o \"\$TERM\" = 'tmux-256color' ] && command -v tic >/dev/null 2>&1; then" \
        "rm -rf \"\$IAM_HOME/terminfo\"" \
        "mkdir \"\$IAM_HOME/terminfo\"" \
        "echo \"$(cat ${IAM_HOME}/terminfo/.terminfo | sed 's/\([$"\`\\]\)/\\\1/g')\">\"\$IAM_HOME/terminfo/.terminfo\"" \
        "TERMINFO=\"\$IAM_HOME/terminfo\"" \
        "export TERMINFO" \
        "tic \"\$IAM_HOME/terminfo/.terminfo\" >/dev/null 2>&1 || true" \
        "fi" \
        "echo \"$(cat ${IAM_HOME}/tmux.conf.template | sed 's/\([$"\`\\]\)/\\\1/g')\">\"\$IAM_HOME/tmux.conf.template\"" \
        "echo \"$(cat ${IAM_HOME}/vimrc | sed 's/\([$"\`\\]\)/\\\1/g')\">\"\$IAM_HOME/vimrc\"" \
        "echo \"$(cat ${IAM_HOME}/local_tools | sed 's/\([$"\`\\]\)/\\\1/g')\">\"\$IAM_HOME/local_tools\"" \
        "echo \"$(cat ${HOME}/.tclshrc | sed 's/\([$"\`\\]\)/\\\1/g')\">\"\$HOME/.tclshrc\"" \
        "echo \"$(cat ${IAM_HOME}/bashrc | sed 's/\([$"\`\\]\)/\\\1/g')\">\"\$IAM_HOME/bashrc\"" \
        "echo \"$(cat ${IAM_HOME}/shellrc | sed 's/\([$"\`\\]\)/\\\1/g')\">\"\$IAM_HOME/shellrc\"" \
        "chmod +x \"\$IAM_HOME/shellrc\"" \
        "exec \"\$IAM_HOME/shellrc\""
}

reload() {
    if _is tmux && [ "$1" != "current" ]; then
        local current_wid wid cmd
        current_wid="$(tmux display-message -p -t $TMUX_PANE '#{window_id}')"
        for wid in $(tmux list-windows -F '#{window_id}'); do
            [ "$wid" != "$current_wid" ] || continue
            cmd="$(tmux display-message -p -t "$wid" '#{pane_current_command}')"
            if [ "$cmd" != "bash" ]; then
                echo "Error: can't reload window '$(tmux display-message -p -t "$wid" '#{window_index}:#{window_name}')' as its command '$cmd' is not 'bash'."
                return 1
            fi
        done
        "$IAM_HOME/tools/bin/tmux-helper" reset-options-to-default >/dev/null 2>&1 || true
        tmux source-file "$IAM_HOME/tmux.conf"
        for wid in $(tmux list-windows -F '#{window_id}'); do
            [ "$wid" != "$current_wid" ] || continue
            tmux send-keys -t $wid 'reload current' C-m
        done
    fi
    exec bash --rcfile "$IAM_HOME/bashrc" -i
}
,ssh() {
    ssh -t "$@" "$(__magic_ssh)"
}
gssh() {
    host="$1"
    shift
    # --internal-ip
    # --tunnel-through-iap
    gcloud compute ssh --internal-ip "$host" "$@" -- -t "$(__magic_ssh)"
}
,sudo() {
    local sudo_cmd
    if [ -z "$1" ]; then
        sudo_cmd="sudo"
    else
        sudo_cmd="sudo -u $1"
    fi
    $sudo_cmd -H bash -c "$(__magic_ssh)"
}
wsl() {
    if [ -n "$1" ]; then
        command wsl "$@"
    else

        echo "IAM=\"$IAM\" && export IAM && \
              SSH_PUB_KEY=\"$SSH_PUB_KEY\" && export SSH_PUB_KEY && \
              IAM_HOME=\"\$HOME/.${IAM}_home\" && export IAM_HOME && \
              _GIT_USER_NAME=\"$_GIT_USER_NAME\" && export _GIT_USER_NAME && \
              _GIT_USER_EMAIL=\"$_GIT_USER_EMAIL\" && export _GIT_USER_EMAIL && \
              rm -rf \"\$HOME/.${IAM}_terminfo\" && \
              if [ ! -d \"\$IAM_HOME\" ]; then mkdir \"\$IAM_HOME\"; fi && \
              rm -rf \"\$IAM_HOME/terminfo\" && \
              mkdir \"\$IAM_HOME/terminfo\" && \
              mkdir -p \"\$IAM_HOME/vim_swap\" && \
              echo \"$(cat ${IAM_HOME}/terminfo/.terminfo | sed 's/\([$"\`\\]\)/\\\1/g')\">\"\$IAM_HOME/terminfo/.terminfo\" &&
              TERMINFO=\"\$IAM_HOME/terminfo\" && \
              export TERMINFO && \
              tic \"\$IAM_HOME/terminfo/.terminfo\" && \
              echo \"$(cat ${IAM_HOME}/vimrc | sed 's/\([$"\`\\]\)/\\\1/g')\">\"\$IAM_HOME/vimrc\" && \
              echo \"$(cat ${IAM_HOME}/local_tools | sed 's/\([$"\`\\]\)/\\\1/g')\">\"\$IAM_HOME/local_tools\" && \
              echo \"$(cat ${HOME}/.tclshrc | sed 's/\([$"\`\\]\)/\\\1/g')\">\"\$HOME/.tclshrc\" && \
              echo \"$(cat ${IAM_HOME}/bashrc | sed 's/\([$"\`\\]\)/\\\1/g')\">\"\$IAM_HOME/bashrc\"" \
        | wsl -d Ubuntu

        wsl -d Ubuntu /bin/bash -c "IAM=\"$IAM\" && export IAM && \
              SSH_PUB_KEY=\"$SSH_PUB_KEY\" && export SSH_PUB_KEY && \
              IAM_HOME=\"\$HOME/.${IAM}_home\" && export IAM_HOME && \
              _GIT_USER_NAME=\"$_GIT_USER_NAME\" && export _GIT_USER_NAME && \
              _GIT_USER_EMAIL=\"$_GIT_USER_EMAIL\" && export _GIT_USER_EMAIL && \
              rm -rf \"\$HOME/.${IAM}_terminfo\" && \
              if [ ! -d \"\\\$IAM_HOME\" ]; then mkdir \"\\\$IAM_HOME\"; fi && \
              rm -rf \"\\\$IAM_HOME/terminfo\" && \
              mkdir \"\\\$IAM_HOME/terminfo\" && \
              mkdir -p \"\\\$IAM_HOME/vim_swap\" && \
              echo \"$(cat $IAM_HOME/terminfo/.terminfo | sed 's/\([$"\`\\]\)/\\\1/g')\">\"\\\$IAM_HOME/terminfo/.terminfo\" &&
              TERMINFO=\"\\\$IAM_HOME/terminfo\" && \
              export TERMINFO && \
              tic \"\\\$IAM_HOME/terminfo/.terminfo\" && \
              exec bash --rcfile \"\\\$IAM_HOME/bashrc\" -i || exec \\\$SHELL -i"

    fi
}

_send_raw_term() {
    if _is tmux; then
        printf '\033Ptmux;'
        # all \033 must be doubled: https://github.com/tmux/tmux/wiki/FAQ#what-is-the-passthrough-escape-sequence-and-how-do-i-use-it
        sed -E 's/\x1B/&&/g'
        printf '\033\\'
    else
        cat
    fi
}

# KiTTY functions to receive file(s) and launch winscp
get() {
    local file
    {
        printf '\033]0;__pw:%s\007' "$PWD"
        for file; do
            if [ -d "$file" ]; then
                basename="$(basename "$file")"
                rm -f "/tmp/{basename}.tar.gz"
                tar czf "/tmp/${basename}.tar.gz" "$file"
                printf '\033]0;__rv:%s\007' "/tmp/${basename}.tar.gz"
                rm -f "/tmp/{basename}.tar.gz"
            else
                printf '\033]0;__rv:%s\007' "$file"
            fi
        done
        printf '\033]0;__ti\007'
    } | _send_raw_term
}
winscp() {
    printf '\033];__ws:%s\007' "$PWD" | _send_raw_term
}
clip() {
    {
        printf '\033[5i'
        cat $@
        printf '\033[4i'
    } | _send_raw_term
    echo "Copied to Windows clipboard" 1>&2
}
,fix-x-permission() {
    local fn T
    for fn; do
        cat "$fn" > "${fn}.fix-permissions"
        mv -f "${fn}.fix-permissions" "$fn"
    done
}

# 'less' settings
# -F Causes less to automatically exit if the entire file can be displayed on the first screen
# -X Disables sending the termcap initialization and deinitialization strings to the terminal.
#    It allows to see text when 'less' exited because of the above option (-F). Without this
#    option screen will be initialized and deinitialized, and console will be cleared.
# -R Turn on ANSI "color" escape sequences in output
# -i Causes searches to ignore case
# -w Temporarily highlights the first "new" line after a forward movement of a full page
# -z-4 Changes the default scrolling window size to "screen-4" lines
# -P Prompt. Must be last option
LESS="-F -X -R -i -w -z-4 -P spacebar\:page ahead b\:page back /\:search ahead \?\:search back h\:help q\:quit"
export LESS
#PAGER=less
#export PAGER

# append history rather than overwrite
shopt -s histappend
# one command per line
shopt -s cmdhist
unset HISTFILESIZE
HISTSIZE=1000000
# ignore commands that start with a space AND duplicate commands
HISTCONTROL=ignoreboth
# add the full date and time to lines
HISTTIMEFORMAT='%F %T '
HISTIGNORE="&:[bf]g:exit"
# history file
HISTFILE="$IAM_HOME/bash_history"
# move history file from old location
if [ -e "$HOME/.${IAM}_history" ] && [ ! -e "$HISTFILE" ]; then
    mv "$HOME/.${IAM}_history" "$HISTFILE"
fi

__kubectl_status() {

    local __K8S_CONTEXT
    local __K8S_CONF
    local __K8S_OUTPUT
    local __K8S_NS
    local __K8S_ERR

    if ! _has kubectl || [ ! -e "$IAM_HOME/state/on_kube" ]; then
        return 0
    fi

    if [ -z "$KUBECONFIG" ]; then
        __K8S_CONF="$HOME/.kube/config"
    else
        __K8S_CONF="$KUBECONFIG"
    fi

    __K8S_OUTPUT="${COLOR_GRAY}[${COLOR_WHITE}K8S${COLOR_GRAY}: $COLOR_CYAN$(prompt_workingdir "$__K8S_CONF")"

    if [ ! -e "$__K8S_CONF" ]; then
        __K8S_OUTPUT="${__K8S_OUTPUT}${COLOR_DEFAULT} - ${COLOR_RED}DOESN'T EXIST"
    else

        __K8S_OUTPUT="${__K8S_OUTPUT}${COLOR_GRAY}; ${COLOR_DEFAULT}cluster${COLOR_GRAY}: "

        if ! _catch __K8S_CONTEXT __K8S_ERR kubectl config current-context; then
            # convert from:
            #   error: current-context is not set
            # to:
            #   current-context is not set
            __K8S_CONTEXT="${__K8S_ERR#* }"
            __K8S_OUTPUT="${__K8S_OUTPUT}${COLOR_LIGHTRED}$__K8S_ERR"
        elif [ -n "$__K8S_ERR" ]; then
            __K8S_OUTPUT="${__K8S_OUTPUT}${COLOR_LIGHTRED}$__K8S_ERR"
        else

            __K8S_OUTPUT="${__K8S_OUTPUT}${COLOR_PURPLE}$__K8S_CONTEXT"

            __K8S_NS="$(kubectl config view -o=jsonpath="{.contexts[?(@.name==\"$__K8S_CONTEXT\")].context.namespace}")"
            [ -z "$__K8S_NS" ] && __K8S_NS="default"
            __K8S_OUTPUT="${__K8S_OUTPUT}${COLOR_GRAY}; ${COLOR_DEFAULT}namespace${COLOR_GRAY}: ${COLOR_PURPLE}$__K8S_NS"

        fi

    fi

    __K8S_OUTPUT="${__K8S_OUTPUT}${COLOR_GRAY}]${COLOR_DEFAULT}"

    _ps1_show_status "$__K8S_OUTPUT"

}

__aws_status() {

    local __AWS_OUTPUT
    local __AWS_INDENTITY

    if ! _has aws || [ ! -e "$IAM_HOME/state/on_aws" ]; then
        return 0
    fi

    __AWS_OUTPUT="${COLOR_GRAY}[${COLOR_WHITE}AWS${COLOR_GRAY}: "

    __AWS_OUTPUT="${__AWS_OUTPUT}${COLOR_DEFAULT}key${COLOR_GRAY}:"
    if declare -p AWS_ACCESS_KEY_ID >/dev/null 2>&1; then
        __AWS_OUTPUT="$__AWS_OUTPUT${COLOR_GREEN} Y"
    else
        __AWS_OUTPUT="$__AWS_OUTPUT${COLOR_RED} N"
    fi

    __AWS_OUTPUT="${__AWS_OUTPUT}${COLOR_GRAY}; ${COLOR_DEFAULT}secret${COLOR_GRAY}:"
    if declare -p AWS_SECRET_ACCESS_KEY >/dev/null 2>&1; then
        __AWS_OUTPUT="$__AWS_OUTPUT${COLOR_GREEN} Y"
    else
        __AWS_OUTPUT="$__AWS_OUTPUT${COLOR_RED} N"
    fi

    __AWS_OUTPUT="${__AWS_OUTPUT}${COLOR_GRAY}; ${COLOR_DEFAULT}session${COLOR_GRAY}:"
    if declare -p AWS_SESSION_TOKEN >/dev/null 2>&1; then
        __AWS_OUTPUT="$__AWS_OUTPUT${COLOR_GREEN} Y"
    else
        __AWS_OUTPUT="$__AWS_OUTPUT${COLOR_RED} N"
    fi

    __AWS_OUTPUT="${__AWS_OUTPUT}${COLOR_GRAY}; ${COLOR_DEFAULT}region${COLOR_GRAY}:"
    if declare -p AWS_DEFAULT_REGION >/dev/null 2>&1; then
        __AWS_OUTPUT="$__AWS_OUTPUT${COLOR_CYAN} $AWS_DEFAULT_REGION"
    else
        __AWS_OUTPUT="$__AWS_OUTPUT${COLOR_RED} N"
    fi

    __AWS_OUTPUT="${__AWS_OUTPUT}${COLOR_GRAY}; ${COLOR_DEFAULT}indentity${COLOR_GRAY}:"
    if ! __AWS_INDENTITY="$(aws sts get-caller-identity --query 'Arn' 2>&1)"; then
        # convert from:
        #   An error occurred (InvalidClientTokenId) when calling the GetCallerIdentity operation: The security token included in the request is invalid.
        # to
        #   The security token included in the request is invalid.
        __AWS_INDENTITY="${__AWS_INDENTITY#*:}"
        __AWS_OUTPUT="$__AWS_OUTPUT${COLOR_LIGHTRED}$__AWS_INDENTITY"
    else
        __AWS_OUTPUT="$__AWS_OUTPUT${COLOR_GREEN} $(echo "$__AWS_INDENTITY" | tr -d '"')"
    fi

    __AWS_OUTPUT="${__AWS_OUTPUT}${COLOR_GRAY}]${COLOR_DEFAULT}"

    _ps1_show_status "$__AWS_OUTPUT"

}

# based on: https://github.com/magicmonty/bash-git-prompt
__git_status() {

    local __GIT_STATUS __GIT_TEMP
    local TMP_VAL

    _has git || return 0

    if _check _vercomp 1.8.0 '<' "$__GIT_VERSION"; then
        __GIT_STATUS="$(LC_ALL=C command git status --porcelain 2>/dev/null)" || return 0
    else
        __GIT_STATUS="$(LC_ALL=C command git status --porcelain --branch 2>/dev/null)" || return 0
    fi

    # run only once per session
    _check _git-config-check

    local __GIT_REPO_ROOT="$(git rev-parse --git-dir 2>/dev/null)"

    if [ "$__GIT_REPO_ROOT" = ".git" ]; then
        __GIT_REPO_ROOT="$(pwd)"
    else
        __GIT_REPO_ROOT="$(dirname "$__GIT_REPO_ROOT")"
    fi

    local __GIT_IN_SUBMODULE=0
    # try to detect if we are inside submodule. This command may fail
    # on old git version.
    if __GIT_TEMP="$(git rev-parse --show-superproject-working-tree 2>/dev/null)"; then
        # the command didn't fail
        if [ -n "$__GIT_TEMP" ]; then
            __GIT_IN_SUBMODULE=1
        fi
    else
        # try another method
        if [ "${__GIT_REPO_ROOT%*/.git/modules}" != "$__GIT_REPO_ROOT" ]; then
            __GIT_IN_SUBMODULE=1
        fi
    fi

    # check configuration only once per session
    if _once "git check core.autocrlf in $PWD"; then
        if [ "$(set +e; LC_ALL=C git config --get core.autocrlf)" != "false" ]; then
            git config core.autocrlf false
        fi
    fi

    local __GIT_BRANCH="!ERROR!"
    local __GIT_NUM_STAGED=0
    local __GIT_NUM_CHANGED=0
    local __GIT_NUM_CONFLICT=0
    local __GIT_NUM_UNTRACKED=0

    local line status
    while IFS='' read -r line || [[ -n "${line}" ]]; do
        status="${line:0:2}"
        while [[ -n ${status} ]]; do
            case "${status}" in
                \#\#) __GIT_BRANCH="${line/\.\.\./^}"; break ;;
                \?\?) ((__GIT_NUM_UNTRACKED++)); break ;;
                U?) ((__GIT_NUM_CONFLICT++)); break;;
                ?U) ((__GIT_NUM_CONFLICT++)); break;;
                DD) ((__GIT_NUM_CONFLICT++)); break;;
                AA) ((__GIT_NUM_CONFLICT++)); break;;
                ?M) ((__GIT_NUM_CHANGED++)) ;;
                ?D) ((__GIT_NUM_CHANGED++)) ;;
                ?\ ) ;;
                U) ((__GIT_NUM_CONFLICT++)) ;;
                \ ) ;;
                *) ((__GIT_NUM_STAGED++)) ;;
            esac
            status="${status:0:(${#status}-1)}"
        done
    done <<< "${__GIT_STATUS}"

    if [ "$__GIT_BRANCH" = "!ERROR!" ]; then
        if TMP_VAL="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"; then
            __GIT_BRANCH="$TMP_VAL"
        fi
    fi

    local __GIT_BRANCH_FIELDS
    IFS="^" read -ra __GIT_BRANCH_FIELDS <<< "${__GIT_BRANCH/\#\# }"
    __GIT_BRANCH="${__GIT_BRANCH_FIELDS[0]}"

    local __GIT_OUTPUT
    __GIT_OUTPUT="${COLOR_GRAY}[${COLOR_WHITE}GIT${COLOR_GRAY}: $COLOR_CYAN$(prompt_workingdir "$__GIT_REPO_ROOT")"
    if [ "$__GIT_IN_SUBMODULE" -eq 1 ]; then
        __GIT_OUTPUT="${__GIT_OUTPUT}${COLOR_GRAY}(${COLOR_DEFAULT}submodule${COLOR_GRAY})"
    fi
    __GIT_OUTPUT="${__GIT_OUTPUT}${COLOR_GRAY}; ${COLOR_DEFAULT}branch${COLOR_GRAY}: $COLOR_PURPLE$__GIT_BRANCH"

    local __GIT_TAG
    if __GIT_TAG="$(git describe --exact-match --tags $(git rev-parse HEAD) 2>/dev/null)"; then
        __GIT_OUTPUT="${__GIT_OUTPUT}${COLOR_GRAY}; ${COLOR_DEFAULT}tag${COLOR_GRAY}: $COLOR_PURPLE$__GIT_TAG"
    fi

    if [ "$__GIT_NUM_CONFLICT" -ne 0 ]; then
        __GIT_OUTPUT="${__GIT_OUTPUT}${COLOR_GRAY}; ${COLOR_LIGHTRED}conflict${COLOR_GRAY}: $COLOR_DEFAULT$__GIT_NUM_CONFLICT"
    fi

    if [ "$__GIT_NUM_STAGED" -ne 0 ]; then
        __GIT_OUTPUT="${__GIT_OUTPUT}${COLOR_GRAY}; ${COLOR_GREEN}staged${COLOR_GRAY}: $COLOR_DEFAULT$__GIT_NUM_STAGED"
    fi

    if [ "$__GIT_NUM_CHANGED" -ne 0 ]; then
        __GIT_OUTPUT="${__GIT_OUTPUT}${COLOR_GRAY}; ${COLOR_BROWN}changed${COLOR_GRAY}: $COLOR_DEFAULT$__GIT_NUM_CHANGED"
    fi

    if [ "$__GIT_NUM_UNTRACKED" -ne 0 ]; then
        __GIT_OUTPUT="${__GIT_OUTPUT}${COLOR_GRAY}; ${COLOR_DEFAULT}untracked${COLOR_GRAY}: $COLOR_LIGHTRED$__GIT_NUM_UNTRACKED"
    fi

    __GIT_OUTPUT="${__GIT_OUTPUT}${COLOR_GRAY}]${COLOR_DEFAULT}"

    # other options

    __GIT_OUTPUT="${__GIT_OUTPUT} ${COLOR_GRAY}[${COLOR_DEFAULT}sign${COLOR_GRAY}:"

    local __GIT_SIGN

    if TMP_VAL="$(set +e; git config --local --get commit.gpgsign 2>/dev/null)"; then
        if [ "$TMP_VAL" = "true" ]; then
            TMP_VAL="${COLOR_GREEN}$TMP_VAL"
            __GIT_SIGN=1
        else
            TMP_VAL="${COLOR_RED}$TMP_VAL"
        fi
    elif ! TMP_VAL="$(set +e; git config --get commit.gpgsign 2>/dev/null)"; then
        TMP_VAL="${COLOR_LIGHTRED}undef"
    elif [ "$TMP_VAL" = "true" ]; then
        TMP_VAL="${COLOR_GREEN}$TMP_VAL${COLOR_GRAY}(${COLOR_DEFAULT}G${COLOR_GRAY})"
        __GIT_SIGN=1
    else
        TMP_VAL="${COLOR_RED}$TMP_VAL${COLOR_GRAY}(${COLOR_DEFAULT}G${COLOR_GRAY})"
    fi

    __GIT_OUTPUT="${__GIT_OUTPUT}$TMP_VAL"

    local __GIT_AUTHOR_EMAIL

    # don't check for author in submodules
    if [ "$__GIT_IN_SUBMODULE" -eq 0 ]; then

        __GIT_OUTPUT="${__GIT_OUTPUT}${COLOR_GRAY};${COLOR_DEFAULT} author${COLOR_GRAY}:"

        if TMP_VAL="$(set +e; LC_ALL=C git config --local --get user.email 2>/dev/null)"; then
            if [ "$TMP_VAL" = "$_GIT_USER_EMAIL" ]; then
                __GIT_AUTHOR_EMAIL="$TMP_VAL"
                TMP_VAL="${COLOR_GREEN}ON"
            else
                __GIT_AUTHOR_EMAIL="$TMP_VAL"
                TMP_VAL="${COLOR_BROWN}$TMP_VAL"
            fi
        elif ! TMP_VAL="$(set +e; LC_ALL=C git config --get user.email 2>/dev/null)"; then
            TMP_VAL="${COLOR_LIGHTRED}undef"
        elif [ "$TMP_VAL" = "$_GIT_USER_EMAIL" ]; then
            __GIT_AUTHOR_EMAIL="$TMP_VAL"
            TMP_VAL="${COLOR_GREEN}ON${COLOR_GRAY}(${COLOR_DEFAULT}G${COLOR_GRAY})"
        else
            __GIT_AUTHOR_EMAIL="$TMP_VAL"
            TMP_VAL="${COLOR_BROWN}$TMP_VAL${COLOR_GRAY}(${COLOR_DEFAULT}G${COLOR_GRAY})"
        fi

        __GIT_OUTPUT="${__GIT_OUTPUT}$TMP_VAL"

    fi

    local __GIT_SIGN_KEY

    if [ -n "$__GIT_SIGN" ] && [ -n "$__GIT_AUTHOR_EMAIL" ]; then

        __GIT_OUTPUT="${__GIT_OUTPUT}${COLOR_GRAY};${COLOR_DEFAULT} gpg${COLOR_GRAY}:"

        if ! _has gpg; then
            TMP_VAL="${COLOR_LIGHTRED}unavailable"
        else
            if TMP_VAL="$(set +e; LC_ALL=C git config --local --get user.signingkey 2>/dev/null)"; then
                __GIT_SIGN_KEY="$TMP_VAL"
            elif TMP_VAL="$(set +e; LC_ALL=C git config --get user.signingkey 2>/dev/null)"; then
                __GIT_SIGN_KEY="$TMP_VAL"
            else
                : nothing available
            fi

            if [ -z "$__GIT_SIGN_KEY" ]; then
                TMP_VAL="${COLOR_LIGHTRED}not set"
            elif ! TMP_VAL="$(set +e; LC_ALL=C gpg --list-secret-keys "$__GIT_SIGN_KEY" 2>/dev/null)"; then
                TMP_VAL="${COLOR_RED}no key '$__GIT_SIGN_KEY'"
            else
                if ! TMP_VAL="$(set +e; LC_ALL=C gpg --with-colons --list-secret-keys "$__GIT_AUTHOR_EMAIL" 2>/dev/null | cut -d: -f5 | head -n 1)"; then
                    TMP_VAL="${COLOR_RED}wrong key, no key for '$__GIT_AUTHOR_EMAIL'"
                elif [ "$TMP_VAL" != "$__GIT_SIGN_KEY" ]; then
                    TMP_VAL="${COLOR_RED}wrong key, set: $__GIT_SIGN_KEY; expected: $TMP_VAL"
                else
                    TMP_VAL="${COLOR_GREEN}ON"
                fi
            fi
        fi

        __GIT_OUTPUT="${__GIT_OUTPUT}$TMP_VAL"

    fi

    __GIT_OUTPUT="${__GIT_OUTPUT}${COLOR_GRAY}]${COLOR_DEFAULT}"

    _ps1_show_status "$__GIT_OUTPUT"

}

_ps1_show_status() {
    if _isnot tmux; then
        echo "$1"
        return
    fi
    [ -n "$_PS1_TMUX_CURRENT_WINDOW" ] || _PS1_TMUX_CURRENT_WINDOW="$(tmux display-message -p -t "$TMUX_PANE" '#{window_id}')"
    if [ -z "$_PS1_TMUX_CURRENT_STATUS" ]; then
        # we may have a status pane and lost its ID after reload.
        # #{pane_dead} doesn't work in tmux 3.0a. Status pane is not marked as dead.
        # However, #{pane_pid} works everywhere. Empty pane has 0 pane_pid.
        _PS1_TMUX_CURRENT_STATUS="$(tmux list-panes -t "$_PS1_TMUX_CURRENT_WINDOW" -F '#{pane_pid} #{pane_id}' | grep '^0 ' | awk '{print $2}' | tail -n 1)"
        # no panes, create one
        [ -n "$_PS1_TMUX_CURRENT_STATUS" ] || _PS1_TMUX_CURRENT_STATUS="$(tmux split-window -d -l 1 -v -t "$TMUX_PANE" -P -F '#{pane_id}' '')"
        #tmux select-pane -t "$_PS1_TMUX_CURRENT_STATUS" -P 'bg=colour236'
        #tmux select-pane -t "$TMUX_PANE"
        # defaults are:
        # pane-border-style bg=colour235,fg=colour238
        # pane-active-border-style bg=colour236,fg=colour51
        tmux set -p -t "$TMUX_PANE" pane-border-style 'bg=default,fg=colour238'
        tmux set -p -t "$TMUX_PANE" pane-active-border-style 'bg=default,fg=colour238'
        tmux set -p -t "$_PS1_TMUX_CURRENT_STATUS" pane-border-style 'bg=default,fg=colour238'
        tmux set -p -t "$_PS1_TMUX_CURRENT_STATUS" pane-active-border-style 'bg=default,fg=colour238'
    fi
    [ -z "${_PS1_STATUS_LINE}" ] && _PS1_STATUS_LINE=1 || _PS1_STATUS_LINE=$(( _PS1_STATUS_LINE + 1 ))
    tmux resize-pane -y "$_PS1_STATUS_LINE" -t "$_PS1_TMUX_CURRENT_STATUS"
    # "\033[?7l" / "\033[?7h" - disables/enables word wrap in tmux
    # https://github.com/tmux/tmux/issues/969#issuecomment-307659989
    printf "\n\033[?7l%s\033[?7h" "$1" | tmux display-message -t "$_PS1_TMUX_CURRENT_STATUS" -I
}

# Function to set prompt_command to.
function promptcmd () {

    # Exit status of the last command run.
    local exitcode="$1" i

    # fix cursor position when it is not on new line
    local CURPOS SAVE_STTY="$(stty -g)"
    stty raw -echo min 0
    echo -en "\033[6n" && read -sdR CURPOS
    stty "$SAVE_STTY"
    [ ${CURPOS##*;} -eq 1 ] || echo "${COLOR_ERROR}%${COLOR_DEFAULT}"

    PS1=''

    # A non-zero exit code is displayed here. It's not such a trivial task.
    # Bash doesn't cleanup the latest exit code when executing an empty command.
    # It is possible to use a hack and insert the exit status message
    # into PS1 ( https://stackoverflow.com/a/27473009 ) and don't show it
    # when array already has element at index as current command number.
    # But then there is an issue with tab autocompletion. Bash renders PS1
    # once and gives prepared static text to readline as a prompt.
    # That means that the exit code message will appear every time
    # readline redraws input prompt during autocompletion.
    # That is why we try to catch real inteactive command via DEBUG trap
    # and don't show the exit code message when there is no command.

    # print error exist status of previous command
    if [ "$exitcode" -ne 0 ] && [ -n "$PS1_COMMAND" ]; then
       local SIG="" MSG
       MSG="${COLOR_RED}Exit code: $exitcode"
       if [ "$exitcode" -eq 130 ]; then
           SIG="<Ctrl-C>"
       elif [ "$exitcode" -eq 127 ]; then
           SIG="command is not found"
       elif [ "$exitcode" -eq 126 ]; then
           SIG="command is not executable"
       elif [ "$exitcode" -gt 128 ] && SIG="$(builtin kill -l "$exitcode" 2>/dev/null)"; then
           SIG="SIG$SIG"
       elif [ "$exitcode" -ge 64 ] && [ "$exitcode" -le 78 ] && SIG="$(echo ':64:USAGE:65:DATAERR:66:NOINPUT:67:NOUSER:68:NOHOST:69:UNAVAILABLE:70:SOFTWARE:71:OSERR:72:OSFILE:73:CANTCREAT:74:IOERR:75:TEMPFAIL:76:PROTOCOL:77:NOPERM:78:CONFIG:' | grep -o ":${exitcode}:[^:]*")"; then
           # https://man.freebsd.org/cgi/man.cgi?query=sysexits&manpath=FreeBSD+4.3-RELEASE
           SIG="EX_${SIG##*:}"
       fi
       [ -z "$SIG" ] || MSG="${MSG} [$SIG]"
       echo "$MSG${COLOR_DEFAULT}"
    fi

    if [ ! -d "$PWD" ]; then
        echo "${COLOR_RED}Warning: Current directory doesn't exist${COLOR_DEFAULT}"
    elif _check stat -c '%i' . && [ ! -L "$PWD" ] && [ "$(stat -c '%i' . 2>&1)" != "$(stat -c '%i' "$PWD")" ]; then
        # if inside of zombie directory
        echo "${COLOR_BROWN}Current directory is a zombie. Fixing it.${COLOR_DEFAULT}"
        cd ../"$(basename "$PWD")"
    fi

    if [ -n "$__KITTY_ID" ]; then
        [ -d "$IAM_HOME/kitty_sessions/$__KITTY_ID" ] || mkdir -p "$IAM_HOME/kitty_sessions/$__KITTY_ID"
        if _is tmux; then
            echo "$TMUX" > "$IAM_HOME/kitty_sessions/$__KITTY_ID/tmux"
        else
            echo "$PWD" > "$IAM_HOME/kitty_sessions/$__KITTY_ID/pwd"
        fi
    fi

    echo "$PWD" > "$IAM_HOME/jumplist_last_pwd"

    # update history file
    history -a

    if [ -d "$IAM_HOME"/shell.rc ]; then
        for i in "$IAM_HOME"/shell.rc/*; do
            ! _once "PS1 -> source $i" || source "$i"
        done
    fi

    unset _PS1_STATUS_LINE

    __aws_status
    __kubectl_status
    __git_status

    if [ -z "$_PS1_STATUS_LINE" ] && [ -n "$_PS1_TMUX_CURRENT_STATUS" ]; then
        tmux kill-pane -t "$_PS1_TMUX_CURRENT_STATUS"
        tmux set-hook -u -w -t "$TMUX_PANE" 'pane-exited[879]'
        unset _PS1_TMUX_CURRENT_STATUS
    fi

    if _is tmux && [ -n "$TMUX_PANE" ]; then
        # Forcing the window name to be updated, since we may have changed the working directory.
        # Run it in the background and silently ignore any errors.
        tmux set-hook -R -t "$TMUX_PANE" window-renamed >/dev/null 2>&1 &
        disown $!
    fi

    # Titlebar
    if _isnot tmux; then
        case ${TERM} in
            xterm*)
                # No username in tab title
                # PS1="${PS1}\[\033]0;\u@\h:\w\007\]"
                PS1="${PS1}\[\033]0;\h:\w\007\]"
            ;;
        esac
    fi

    PS1="${PS1}\[${COLOR_GRAY}${COLOR_BOLD}\][\[${COLOR_DEFAULT}\]"

    # User
    if [ ${UID} -eq 0 ] ; then
        if [ "${USER}" == "${LOGNAME}" ]; then
            if [[ ${SUDO_USER} ]]; then
                PS1="${PS1}\[${COLOR_RED}\]"
            else
                PS1="${PS1}\[${COLOR_LIGHTRED}\]"
            fi
        else
            PS1="${PS1}\[${COLOR_YELLOW}\]"
        fi
    else
        if [ ${USER} == ${LOGNAME} ]; then
            PS1="${PS1}\[${COLOR_GREEN}\]"
        else
            PS1="${PS1}\[${COLOR_BROWN}\]"
        fi
    fi

    # @
    PS1="${PS1}\u\[${COLOR_GRAY}\]@\[${COLOR_DEFAULT}\]"

    # Host
    PS1="${PS1}\[${COLOR_LIGHTBLUE}\]\h\[${COLOR_DEFAULT}\]"

    # WSL?
    if _is wsl; then
        PS1="${PS1}\[${COLOR_GRAY}\][\[${COLOR_DEFAULT}\]WSL\[${COLOR_GRAY}\]]\[${COLOR_DEFAULT}\]"
    fi

    # Docker?
    if [ -f /.dockerenv ]; then
        PS1="${PS1}\[${COLOR_GRAY}\][\[${COLOR_DEFAULT}\]docker\[${COLOR_GRAY}\]]\[${COLOR_DEFAULT}\]"
    fi

    # :
    PS1="${PS1}\[${COLOR_GRAY}${COLOR_BOLD}\]:\[${COLOR_DEFAULT}\]"

    # Working directory
    if [ -w "${PWD}" ]; then
        PS1="${PS1}\[${COLOR_GREEN}\]$(prompt_workingdir)"
    else
        PS1="${PS1}\[${COLOR_RED}\]$(prompt_workingdir)"
    fi

    PS1="${PS1}\[${COLOR_GRAY}${COLOR_BOLD}\]]\[${COLOR_DEFAULT}\]"

    # Backgrounded running jobs
    local BKGJBS=$(jobs -r | wc -l )
    if [ ${BKGJBS} -gt 2 ]; then
        PS1="${PS1}\[${COLOR_RED}\][bg:${BKGJBS}]\[${COLOR_DEFAULT}\]"
    elif [ ${BKGJBS} -gt 0 ]; then
        PS1="${PS1}\[${COLOR_YELLOW}\][bg:${BKGJBS}]\[${COLOR_DEFAULT}\]"
    fi

    # Stopped Jobs
    local STPJBS=$(jobs -s | wc -l )
    if [ ${STPJBS} -gt 2 ]; then
        PS1="${PS1}\[${COLOR_RED}\][stp:${STPJBS}]\[${COLOR_DEFAULT}\]"
    elif [ ${STPJBS} -gt 0 ]; then
        PS1="${PS1}\[${COLOR_YELLOW}\][stp:${STPJBS}]\[${COLOR_DEFAULT}\]"
    fi

    PS1="${PS1}\[${COLOR_SIGN}\]\\$\[${COLOR_DEFAULT}\] "

    unset PS1_COMMAND

}

# Trim working dir to 1/4 the screen width
function prompt_workingdir () {
  local MY_PWD newPWD
  if [ "x$COLUMNS" = "x" ]; then
      local pwdmaxlen=20
  else
      local pwdmaxlen=$(( COLUMNS / 4 ))
  fi
  local trunc_symbol="..."
  if [ -z "$1" ]; then
      MY_PWD="$PWD"
  else
      MY_PWD="$1"
  fi
  if [[ $MY_PWD == $HOME* ]]; then
    newPWD="~${MY_PWD#$HOME}"
  else
    newPWD="$MY_PWD"
  fi
  if [ ${#newPWD} -gt $pwdmaxlen ]; then
    local pwdoffset=$(( ${#newPWD} - $pwdmaxlen + 3 ))
    newPWD="${trunc_symbol}${newPWD:$pwdoffset:$pwdmaxlen}"
  fi
  echo $newPWD
}

__debug_trap() {
    : $BASH_COMMAND
    [ "$1" != "on"  ] || { unset __BASH_DEBUG_TRAP_IGNORE; return ${2-0}; }
    [ "$1" != "off" ] || { __BASH_DEBUG_TRAP_IGNORE=1; return ${2-0}; }
    # ignore itself
    [ "${BASH_COMMAND%% *}" != "__debug_trap" ] || return
    # ignore when ignore
    [ -z "$__BASH_DEBUG_TRAP_IGNORE" ] || return

    : echo "PRE> PS1_COMMAND = '$BASH_COMMAND'"
    # ignore if we are in subshell
    [ "$BASH_SUBSHELL" -eq 0 ] || return
    # ignore if we are in completer
    [ -z "$COMP_LINE" ] || return
    # we have already set the variable
    [ -z "$PS1_COMMAND" ] || return
    PS1_COMMAND="$BASH_COMMAND"
    : echo "> PS1_COMMAND = $PS1_COMMAND '$IN_PS_COMMAND'"
}

#PROMPT_COMMAND="promptcmd \$?"
#PROMPT_COMMAND="__debug_trap off \$? && __EC=0 || __EC=\$?; promptcmd \$__EC; unset __EC; __debug_trap on"
PROMPT_COMMAND="{ __debug_trap off \$? && __EC=0 || __EC=\$?; promptcmd \$__EC; unset __EC; __debug_trap on; } 2>/dev/null"
#trap __debug_trap DEBUG
trap '{ __debug_trap; } 2>/dev/null' DEBUG

# Fixes for specific OS

if _is hpux; then
    # added support for ctrl-C / ctrl-U / ctrl-Z
    stty intr '^C' kill '^U' susp '^Z'
elif _is macos; then
    # Disable warning for zsh migration on Catalina
    # https://support.apple.com/en-us/102360
    BASH_SILENCE_DEPRECATION_WARNING=1
    export BASH_SILENCE_DEPRECATION_WARNING
elif _is windows; then
    # Ignore case for filenames
    shopt -s nocaseglob
    bind "set completion-ignore-case on"

    # Strip '.exe' suffix for completions
    shopt -s completion_strip_exe

    # Make Bash 8bit clean
    bind "set meta-flag on"
    bind "set convert-meta off"
    bind "set output-meta on"

    # KUBECONFIG should be compatible with native kubectl
    KUBECONFIG=$(cygpath -m "$KUBECONFIG")
    export KUBECONFIG

    # use GKE plugin for GCP
    USE_GKE_GCLOUD_AUTH_PLUGIN=True
    export USE_GKE_GCLOUD_AUTH_PLUGIN

    # Initialize environment variables
    # http://web.archive.org/web/20211130094904/http://www.smithii.com/node/44
    if [ "$SSH_TTY" ]; then
        # special var
        PROGRAMFILESX86="$(cmd.exe /C "echo %ProgramFiles(x86)%" | tr -d '\r')"
        set -- \
            /proc/registry/HKEY_CURRENT_USER/Volatile\ Environment/* \
            /proc/registry/HKEY_CURRENT_USER/Environment/* \
            /proc/registry/HKEY_LOCAL_MACHINE/SYSTEM/CurrentControlSet/Control/Session\ Manager/Environment/*
        for fn; do
            [ -f "$fn" ] || continue
            __var="${fn##*/}"
            __var="${__var^^}"
             [ -z "${!__var}" ] || continue
            IFS= read -d $'\0' -r __val < "$fn"
            __val="${__val/\%SystemRoot\%/$SYSTEMROOT}"
            __val="${__val/\%ProgramFiles\%/$PROGRAMFILES}"
            __val="${__val/\%USERPROFILE\%/$USERPROFILE}"
            __val="${__val/\%ProgramFiles(x86)\%/$PROGRAMFILESX86}"
            __val="${__val/\%HomeDrive\%\%HomePath\%/$USERPROFILE}"
            echo "Adding environment variable '${__var}'"
            if [ "${__val/\%/}" != "$__val" ]; then
                echo "Warning! Percent in environment variable '${__var}': '${__val}'"
            fi
            export $__var="$__val" >/dev/null 2>&1
        done
        unset fn __var __val
    fi
fi

if [ -f ~/.${IAM}_customrc ]; then
    . ~/.${IAM}_customrc
fi

for VAR in LD_LIBRARY_PATH LIBPATH SHLIB_PATH DYLD_LIBRARY_PATH LD_PRELOAD LD_RUN_PATH; do
    if [ ! -z "${!VAR}" ]; then
        FOUND=1
        echo "${COLOR_GRAY}[${COLOR_LIGHTRED}Warning${COLOR_GRAY}]${COLOR_DEFAULT} $VAR ${COLOR_GRAY}=${COLOR_DEFAULT} ${!VAR}"
    fi
done; unset VAR

if [ ! -z "$FOUND" ]; then
    echo ""
    unset FOUND
fi

# ---------------

EFAG=()

# Add known locations for temporary installations first
if _is windows; then
    EFAG[${#EFAG[@]}]="c:/Program Files/Electric Cloud/ElectricCommander/bin"
    EFAG[${#EFAG[@]}]="c:/Program Files/CloudBees/Software Delivery Automation/bin"
else
    EFAG[${#EFAG[@]}]="/opt/electriccloud/electriccommander/bin"
    EFAG[${#EFAG[@]}]="/opt/cloudbees/sda/bin"
fi

if _is linux; then
    if _has ps; then
        if _check command ps --version; then
            # if we have GNU ps, but not busybox ps
            while IFS= read -r line; do
                # workaround for old bash: https://unix.stackexchange.com/questions/64427/bash-3-0-not-supporting-lists
                EFAG[${#EFAG[@]}]="$line"
            done < <(ps -o args= -C ecmdrAgent | grep -oP '^.*(?=/ecmdrAgent)')
            unset line
        else
            # busybox version
            while IFS= read -r line; do
                # workaround for old bash: https://unix.stackexchange.com/questions/64427/bash-3-0-not-supporting-lists
                EFAG[${#EFAG[@]}]="$line"
            done < <(ps -o args= | grep '^[^[:space:]]*/ecmdrAgent' | sed 's#/ecmdrAgent.*$##')
            unset line
        fi
    fi
elif _is windows; then
    while IFS= read -r line; do
        if [ "${line%%=*}" = "ExecutablePath" ]; then
            line="${line#*=}"
            line="${line%\\*}"
            # workaround for old bash: https://unix.stackexchange.com/questions/64427/bash-3-0-not-supporting-lists
            EFAG[${#EFAG[@]}]="$line"
        fi
    done < <(wmic process where "name='ecmdrAgent.exe'" get ExecutablePath /FORMAT:LIST 2>/dev/null)
    unset line
fi

# Try to detect and add path to tools-only install
if _is windows; then
    EFAG[${#EFAG[@]}]="c:/Artemis/install/bin"
else
    EFAG[${#EFAG[@]}]="/opt/_cbcd-tools/bin"
    EFAG[${#EFAG[@]}]="/opt/chronic/install/bin"
fi

for (( idx=0; $idx < ${#EFAG[@]}; idx++ )); do
    [ -d "${EFAG[idx]}" ] || continue
    _is windows && _addpath "$(cygpath -u "${EFAG[idx]}")" || _addpath "${EFAG[idx]}"
done
unset idx
unset EFAG

if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
elif [ -f /etc/profile.d/bash_completion.sh ]; then
    . /etc/profile.d/bash_completion.sh
elif [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
elif [ -f /usr/local/etc/bash_completion ]; then
    . /usr/local/etc/bash_completion
fi
# files from /etc/bash_completion.d/* will be loaded automatically by the above

# show warning if docker group exists, but current user is not in the group
if getent group docker >/dev/null 2>&1; then
    if ! id -nG | grep -qw "docker"; then
        echo "${COLOR_RED}Current user is not in docker group. Run: sudo usermod -a -G docker $(id --user --name)${COLOR_DEFAULT}"
        echo ""
    fi
fi

if [ "$TERM" != "xterm-256color" ] && [ "$TERM" != "tmux-256color" ]; then
    # unset custom TERMINFO since we don't have definitions for this terminal
    unset TERMINFO
    echo "${COLOR_RED}Unexpected TERM type: '$TERM'${COLOR_DEFAULT}"
    echo ""
elif [ ! -e "$IAM_HOME/terminfo"/*/xterm-256color ]; then
    echo "${COLOR_RED}Terminfo file '$IAM_HOME/terminfo/*/xterm-256color' not found. Perhaps the 'tic' command doesn't exist in the environment.${COLOR_DEFAULT}"
    echo ""
    unset TERMINFO
fi

if ! type _init_completion >/dev/null 2>&1; then
    echo "${COLOR_RED}The original bash completion package is not installed on this machine. Some of the completions may not be available.${COLOR_DEFAULT}"
    echo ""
fi

if [ -d "$IAM_HOME/tools/bash_completion" ]; then

    if [ ! -f "$IAM_HOME/tools/bash_completion/kubectl.completion.bash" ] && type -t _init_completion >/dev/null 2>&1 && _has kubectl; then
        echo "Generating bash completions for kubectl..."
        kubectl completion bash >"$IAM_HOME/tools/bash_completion/kubectl.completion.bash" 2>/dev/null
    fi

    if [ ! -f "$IAM_HOME/tools/bash_completion/eksctl.completion.bash" ] && type -t _init_completion >/dev/null 2>&1 && _has eksctl; then
        echo "Generating bash completions for eksctl..."
        eksctl completion bash >"$IAM_HOME/tools/bash_completion/eksctl.completion.bash" 2>/dev/null
    fi

    if [ ! -f "$IAM_HOME/tools/bash_completion/helm.completion.bash" ] && type -t _init_completion >/dev/null 2>&1 && _has helm; then
        echo "Generating bash completions for helm..."
        helm completion bash >"$IAM_HOME/tools/bash_completion/helm.completion.bash" 2>/dev/null
    fi

    if [ ! -f "$IAM_HOME/tools/bash_completion/oc.completion.bash" ] && type -t _init_completion >/dev/null 2>&1 && _has oc; then
        echo "Generating bash completions for OpenShift..."
        oc completion bash >"$IAM_HOME/tools/bash_completion/oc.completion.bash" 2>/dev/null
    fi

    if [ ! -f "$IAM_HOME/tools/bash_completion/upkg.bash" ] && _has upkg && upkg supported silent; then
        echo "Generating bash completions for upkg..."
        upkg generate bash-completion >"$IAM_HOME/tools/bash_completion/upkg.bash" 2>/dev/null
    fi

    for i in "$IAM_HOME/tools/bash_completion"/*.bash; do
        source $i
    done

fi

if _has git && _vercomp 1.7.9 '>' "$__GIT_VERSION"; then
    echo "${COLOR_RED}WARNING:${COLOR_DEFAULT} git v$__GIT_VERSION is too old and doesn't support signatures, v1.7.9 or higher is required."
    echo ""
fi

if [ -f ~/gcloud/google-cloud-sdk/completion.bash.inc ]; then
    . ~/gcloud/google-cloud-sdk/completion.bash.inc
elif [ -f /usr/lib/google-cloud-sdk/completion.bash.inc ]; then
    . /usr/lib/google-cloud-sdk/completion.bash.inc
fi

if ! _is dockerenv; then
    SSH_PUB_KEY_ONLY="`echo $SSH_PUB_KEY | awk '{print $2}'`"
    if [ -z "$SSH_PUB_KEY_ONLY" ]; then
        echo "${COLOR_RED}SSH key is not defined${COLOR_DEFAULT}"
        echo ""
    else
        if [ ! -d ~/.ssh ]; then
            mkdir ~/.ssh
            chmod 0700 ~/.ssh
        fi
        if [ ! -f ~/.ssh/authorized_keys ]; then
            echo "$SSH_PUB_KEY" > ~/.ssh/authorized_keys
            chmod 0600 ~/.ssh/authorized_keys
            echo "${COLOR_GREEN}SSH key installed${COLOR_DEFAULT}"
            echo ""
        # 'grep -q' is not supported on some ancient environments (solaris/solaris x86)
        elif ! grep "$SSH_PUB_KEY_ONLY" ~/.ssh/authorized_keys >/dev/null 2>&1; then
            echo "$SSH_PUB_KEY" >> ~/.ssh/authorized_keys
            echo "${COLOR_GREEN}SSH key installed${COLOR_DEFAULT}"
            echo ""
        fi
    fi
    unset SSH_PUB_KEY_ONLY
fi

if [ ! -x "$IAM_HOME/tools/bin/geturl" ]; then
    [ -d "$IAM_HOME/tools/bin" ] || mkdir -p "$IAM_HOME/tools/bin"
    {
        echo '#!/usr/bin/env bash'
        declare -f _hash _check _has _catch _get_url
        echo '_get_url "$@"'
    } > "$IAM_HOME/tools/bin/geturl"
    chmod +x "$IAM_HOME/tools/bin/geturl"
fi

tools() {

    local CMD="$1"
    local PARAM="$2"
    local PARAM_EX="$3"
    local LINE
    local I_DESC I_URL I_FILE I_SIZE I_FILTER I_ON_UPDATE
    local SIZE
    local CHECK_STATE
    local IS_ERROR
    local IDX
    local TOOLS_FILE="$IAM_HOME/local_tools"
    local TOOLS_URL="https://raw.githubusercontent.com/chpock/dotfiles/master/tools.list"

    if [ "lock" = "$CMD" ]; then
        touch "$IAM_HOME/local_tools.locked"
        echo "Tools are locked now."
        return
    fi

    if [ "unlock" = "$CMD" ]; then
        rm -f "$IAM_HOME/local_tools.locked"
        echo "Tools are unlocked now."
        return
    fi

    if [ "locked" = "$CMD" ]; then
        [ -e "$IAM_HOME/local_tools.locked" ] && return 0 || return 1
    fi

    if [ "update" = "$CMD" ]; then
        if tools locked; then
            echo "${COLOR_BROWN}WARNING:${COLOR_DEFAULT} Tools are locked now and will not be updated."
            return
        fi
        if ! _get_url -check; then
            echo "${COLOR_RED}ERROR:${COLOR_DEFAULT} Could not update tools: curl/wget command not found"
            return 1
        fi
        if [ "$PARAM" = "background" ]; then
            tools update background-real >/dev/null 2>&1 &
            disown $!
            return
        fi
    fi

    local files=() recs=() recs_check=() TOOLS_EXISTS=1

    if [ ! -f "$TOOLS_FILE" -o "$(_get_size "$TOOLS_FILE")" != "$LOCAL_TOOLS_FILE_SIZE" ]; then
        local TMP="$(mktemp)"
        if ! _get_url "$TOOLS_URL" >"$TMP" 2>/dev/null; then
            rm -f "$TMP"
            unset TOOLS_EXISTS
            CHECK_STATE=1
        else
            mv -f "$TMP" "$TOOLS_FILE"
        fi
    fi

    if [ -n "$TOOLS_EXISTS" ]; then
        while IFS= read -r LINE; do
            if [ -z "$LINE" ]; then
                unset I_DESC I_URL I_FILE I_SIZE I_FILTER I_ON_UPDATE
            elif [ -z "$I_DESC" ]; then
                I_DESC="$LINE"
            elif [ -z "$I_URL" ]; then
                I_URL="$LINE"
            elif [ -z "$I_FILE" ]; then
                printf -v LINE '%q' "$LINE"; # quote string
                eval "I_FILE=\"${LINE//\\\$/\$}\""; # enable $VAR
            elif [ -z "$I_SIZE" ]; then
                local P1="${LINE%:*}"
                if [ "$P1" = "$LINE" ]; then
                    I_SIZE="$LINE"
                else
                    if [ "$P1" = "filter" ]; then
                        I_FILTER="${LINE#*: }"
                    elif [ "$P1" = "on update" ]; then
                        I_ON_UPDATE="${LINE#*: }"
                    else
                        echo "ERROR: unexpected line in tools list: $LINE"
                    fi
                fi
            else
                echo "ERROR: unexpected line in tools list: $LINE"
            fi
            # continue the loop if a tool record is incomplete
            [ -n "$I_SIZE" ] || continue
            if [ -n "$I_FILTER" ] && ! _is "$I_FILTER"; then continue; fi
            if [ -e "$I_FILE" ]; then
                recs_check+=("$I_DESC" "$I_URL" "$I_FILE" "$I_SIZE" "$I_ON_UPDATE")
                files+=("$I_FILE")
            else
                recs+=("$I_DESC" "$I_URL" "$I_FILE" "$I_SIZE" "$I_ON_UPDATE" 0)
            fi
            unset I_DESC I_URL I_FILE I_SIZE I_FILTER I_ON_UPDATE
        done < "$TOOLS_FILE"
    fi

    if [ "${#files[@]}" -gt 0 ]; then
        IDX=0
        while read -r SIZE; do
            recs+=("${recs_check[@]:$(( 5 * IDX++)):5}" "$SIZE")
        done < <(_get_size "${files[@]}")
    fi

    # do something with a tool record
    IDX=0
    while [ $IDX -lt ${#recs[@]} ]; do
        I_DESC="${recs[IDX++]}"
        I_URL="${recs[IDX++]}"
        I_FILE="${recs[IDX++]}"
        I_SIZE="${recs[IDX++]}"
        I_ON_UPDATE="${recs[IDX++]}"
        SIZE="${recs[IDX++]}"
        if [ "check" = "$CMD" ]; then
            if [ "$SIZE" -eq 0 ]; then
                LINE="${COLOR_LIGHTRED}NOT FOUND${COLOR_GRAY}${COLOR_DEFAULT}"
                SIZE="undef"
                [ -n "$CHECK_STATE" ] || CHECK_STATE=1
            else
                if [ "$I_SIZE" != "$SIZE" ]; then
                    LINE="${COLOR_BROWN}OUTDATED ${COLOR_GRAY}${COLOR_DEFAULT}"
                    CHECK_STATE=2
                else
                    LINE="${COLOR_GREEN}OK       ${COLOR_GRAY}${COLOR_DEFAULT}"
                fi
            fi
            if [ "quick" != "$PARAM" ]; then
                printf "%s ${COLOR_GRAY}[${COLOR_DEFAULT}Size current: %6s ${COLOR_GRAY}/${COLOR_DEFAULT} expected: %6s${COLOR_GRAY}]${COLOR_DEFAULT} %s\n" "$LINE" "$SIZE" "$I_SIZE" "${I_FILE/$HOME/\~}"
            fi
        elif [ "update" = "$CMD" ]; then
            [ "$PARAM" != "force" ] && [ "$SIZE" -eq "$I_SIZE" ] && continue || true
            printf "Download: %s '%s'..." "$I_DESC" "${I_FILE##*/}"
            mkdir -p "${I_FILE%/*}"
            IS_ERROR=0
            local TMP="$(mktemp)"
            _get_url "$I_URL" > "$TMP" || IS_ERROR=$?
            if [ "$IS_ERROR" -ne 0 ]; then
                echo " ${COLOR_LIGHTRED}ERROR${COLOR_DEFAULT}"
                rm -f "$TMP"
            else
                echo " ${COLOR_GREEN}OK${COLOR_DEFAULT}"
                mv -f "$TMP" "$I_FILE"
                # +x for /bin/ scripts or files
                [ -n "${I_FILE##*/bin/*}" ] || chmod +x "$I_FILE"
                [ -z "$I_ON_UPDATE" ] || eval "$I_ON_UPDATE"
            fi
        fi
    done

    if [ "check" = "$CMD" ] && [ "quick" = "$PARAM" ] && [ -n "$CHECK_STATE" ]; then
        if [ "$PARAM_EX" = "update" ]; then
            if [ "$CHECK_STATE" -eq 1 ]; then
                echo "${COLOR_BROWN}Some or all local tools are not exist and will be updated in background.${COLOR_DEFAULT}"
                echo ""
            elif [ "$CHECK_STATE" -eq 2 ]; then
                echo "${COLOR_BROWN}Some or all local tools are outdated and will be updated in background.${COLOR_DEFAULT}"
                echo ""
            fi
            tools update background
        else
            if [ "$CHECK_STATE" -eq 1 ]; then
                echo "${COLOR_RED}Some or all local tools are not exist. Run the 'tools update' command.${COLOR_DEFAULT}"
                echo ""
            elif [ "$CHECK_STATE" -eq 2 ]; then
                echo "${COLOR_BROWN}Some or all local tools are outdated. Run the 'tools update' command.${COLOR_DEFAULT}"
                echo ""
            fi
        fi
    fi

}


complete -W "check update lock unlock" tools

j() {

    local JUMP_FILE="$IAM_HOME/jumplist.txt"
    local JUMP_FILE_TEMP="${JUMP_FILE}.tmp"
    local NAME
    local DIR

    if [ -n "$COMP_CWORD" ]; then
        local CURRENT="${COMP_WORDS[COMP_CWORD]}"
        COMPREPLY=()
        if [ "$COMP_CWORD" -eq 1 ]; then
            case "$CURRENT" in
                -*)
                    COMPREPLY=($(compgen -W "-add -del -list -help -rename -last" -- "$CURRENT"))
                    return
                    ;;
            esac
        else
            # no completions for -add / -list / -help
            case "$3" in
                -add|-list|-help)
                    return
                    ;;
            esac
            compopt -o nospace -o filenames
            if [ -e "$JUMP_FILE" ]; then
                while IFS=$'\t' read -r NAME DIR; do
                    [ "$NAME" != "${COMP_WORDS[1]}" ] || break
                    unset DIR
                done < "$JUMP_FILE"
            fi
            [ -n "$DIR" ] || return
            local LINE
            while IFS=$'\n' read -r LINE; do
                # strip base jump dir
                LINE="${LINE:${#DIR}+1}"
                # tralling / for existing dir will be added by readline
                [ ! -d "$LINE" ] && [ "${LINE:${#LINE}-1}" != "/" ] && LINE+="/" || :
                COMPREPLY+=("$LINE")
            done < <(compgen -d -- "${DIR}/$CURRENT")
            return
        fi
        # don't provide completions for 2nd argument for -rename
        if [ "${COMP_WORDS[1]}" = "-rename" ] && [ $COMP_CWORD -gt 2 ]; then
            return
        fi
        COMPREPLY=($(COMP_CWORD= j -complete "$CURRENT"))
        return
    fi

    rm -f "$JUMP_FILE_TEMP"

    if [ "X$1" = "X-last" ]; then
        if [ -e "$IAM_HOME/jumplist_last_pwd" ]; then
            cd "$(cat "$IAM_HOME/jumplist_last_pwd")"
        else
            echo "JumpList: last directory is unknown"
        fi
        return
    fi

    if [ "X$1" = "X-add" ]; then
        DIR="$(pwd)"
        NAME="$2"
        [ -z "$NAME" ] && NAME="$(basename "$DIR")" || true
        printf '%s\t%s\n' "$NAME" "$DIR" >>"$JUMP_FILE"
        echo "JumpList: added '$NAME' for '$DIR'"
        return
    fi

    if [ "X$1" = "X-del" ]; then
        if [ -z "$2" ]; then
            echo "JumpList: ERROR: The name is not specified."
            echo "Usage: j -del <name>"
            return 1
        fi
        local FOUND
        if [ -e "$JUMP_FILE" ]; then
            while IFS=$'\t' read -r NAME DIR; do
                if [ "X$NAME" != "X$2" ]; then
                    printf '%s\t%s\n' "$NAME" "$DIR" >>"$JUMP_FILE_TEMP"
                else
                    FOUND=1
                fi
            done < "$JUMP_FILE"
        fi
        if [ -z "$FOUND" ]; then
            echo "JumpList: the name was not found: '$2'"
            rm -f "$JUMP_FILE_TEMP"
            return 1
        fi
        echo "JumpList: the name '$2' was removed."
        [ -e "$JUMP_FILE_TEMP" ] && mv -f "$JUMP_FILE_TEMP" "$JUMP_FILE" || rm -f "$JUMP_FILE"
        return
    fi

    if [ "X$1" = "X-rename" ]; then
        if [ -z "$2" ] || [ -z "$3" ]; then
            if [ -z "$2" ]; then
                echo "JumpList: ERROR: The original name is not specified."
            else
                echo "JumpList: ERROR: The new name is not specified."
            fi
            echo "Usage: j -rename <name> <new name>"
            return 1
        fi
        local FOUND
        if [ -e "$JUMP_FILE" ]; then
            while IFS=$'\t' read -r NAME DIR; do
                if [ "X$NAME" != "X$2" ]; then
                    printf '%s\t%s\n' "$NAME" "$DIR" >>"$JUMP_FILE_TEMP"
                else
                    printf '%s\t%s\n' "$3" "$DIR" >>"$JUMP_FILE_TEMP"
                    FOUND=1
                fi
            done < "$JUMP_FILE"
        fi
        if [ -z "$FOUND" ]; then
            echo "JumpList: the name was not found: '$2'"
            rm -f "$JUMP_FILE_TEMP"
            return 1
        fi
        echo "JumpList: renamed '$2' -> '$3'"
        [ -e "$JUMP_FILE_TEMP" ] && mv -f "$JUMP_FILE_TEMP" "$JUMP_FILE" || rm -f "$JUMP_FILE"
        return
    fi

    if [ "X$1" = "X-list" ] || [ "X$1" = "X" ]; then
        if [ -e "$JUMP_FILE" ]; then
            local COUNTER=1
            while IFS=$'\t' read -r NAME DIR; do
                printf "[%2i] %-20s %s\n" "$COUNTER" "$NAME" "$DIR"
                COUNTER="$(expr 1 + "$COUNTER")"
            done < "$JUMP_FILE"
        else
            echo "JumpList: no directories"
        fi
        return
    fi

    if [ "X$1" = "X-complete" ]; then
        if [ -e "$JUMP_FILE" ]; then
            while IFS=$'\t' read -r NAME DIR; do
                case "$NAME" in $2*) echo "$NAME" ;; esac
            done < "$JUMP_FILE"
        fi
        return
    fi

    if [ "X$1" = "X-prompt" ]; then
        if [ -e "$JUMP_FILE" ]; then
            local NAME_LIST
            while IFS=$'\t' read -r NAME DIR; do
                if [ -z "$NAME_LIST" ]; then
                    NAME_LIST="$NAME"
                else
                    NAME_LIST="$NAME_LIST${COLOR_GRAY}, ${COLOR_DEFAULT}$NAME"
                fi
            done < "$JUMP_FILE"
            echo "${COLOR_GRAY}[${COLOR_CYAN}JumpList${COLOR_GRAY}] ${COLOR_DEFAULT}$NAME_LIST"
        fi
        return
    fi

    if [ "X$1" = "X-help" ]; then
        echo "JumpList: Usage:"
        echo "  j -add [<name>]"
        echo "  j -del <name>"
        echo "  j -rename <name> <new name>"
        echo "  j -list"
        echo "  j -help"
        return
    fi

    local JUMP

    if [ -e "$JUMP_FILE" ]; then
        while IFS=$'\t' read -r NAME DIR; do
            if [ "X$NAME" = "X$1" ]; then
                JUMP="$DIR"
            fi
        done < "$JUMP_FILE"
    fi

    if [ -z "$JUMP" ]; then
        echo "JumpList: there is no directory '$1'"
        return 1
    fi

    cd "$JUMP/$2"

}

complete -F j j

if _isnot tmux; then

    # don't check for tools update and don't print saved directories in new tmux window
    tools check quick update
    j -prompt

    # Restore PWD for session, but not in tmux
    if [ -n "$__KITTY_ID" ] && [ -e "$IAM_HOME/kitty_sessions/$__KITTY_ID/pwd" ]; then
        # Remove a session older than 259200 seconds ( 60*60*24*3 ) or 3 days
        if [ "$(expr $(date +"%s") - $(date -r "$IAM_HOME/kitty_sessions/$__KITTY_ID/pwd" +"%s"))" -gt 259200 ]; then
            rm -rf "$IAM_HOME/kitty_sessions/$__KITTY_ID"
        else
            cd "$(cat "$IAM_HOME/kitty_sessions/$__KITTY_ID/pwd")"
            [ -e "$IAM_HOME/kitty_sessions/$__KITTY_ID/vim" ] && vim || true
        fi
    fi

    if _has tmux && tmux list-sessions -F '#{session_attached}' 2>/dev/null | grep --silent --fixed-strings '0'; then
        echo "${COLOR_GRAY}[${COLOR_CYAN}TMUX${COLOR_GRAY}] ${COLOR_DEFAULT}Current environment has the following unattached tmux sessions: \"$(tmux list-sessions -F '#{session_attached} #{session_name}' | grep '^0' | sed -E 's/^[[:digit:]][[:space:]]+//' | sed ':a;N;$!ba; s/\n/", "/g')\""
        echo "${COLOR_GRAY}[${COLOR_CYAN}TMUX${COLOR_GRAY}] ${COLOR_DEFAULT}Type to attach: tmux attach-session -t <session name>"
    fi

fi

