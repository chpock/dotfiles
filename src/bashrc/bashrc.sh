#!/bin/bash

declare -A -r __CPRINTF_COLORS=(
    [fw]=$'\e[37m' [fW]=$'\e[97m'
    [fk]=$'\e[30m' [fK]=$'\e[90m'
    [fr]=$'\e[31m' [fR]=$'\e[91m'
    [fg]=$'\e[32m' [fG]=$'\e[92m'
    [fy]=$'\e[33m' [fY]=$'\e[93m'
    [fb]=$'\e[34m' [fB]=$'\e[94m'
    [fm]=$'\e[35m' [fM]=$'\e[95m'
    [fc]=$'\e[36m' [fC]=$'\e[96m'
    [bw]=$'\e[47m' [bW]=$'\e[107m'
    [bk]=$'\e[40m' [bK]=$'\e[100m'
    [br]=$'\e[41m' [bR]=$'\e[101m'
    [bg]=$'\e[42m' [bG]=$'\e[102m'
    [by]=$'\e[43m' [bY]=$'\e[103m'
    [bb]=$'\e[44m' [bB]=$'\e[104m'
    [bm]=$'\e[45m' [bM]=$'\e[105m'
    [bc]=$'\e[46m' [bC]=$'\e[106m'
    [d]=$'\e[0m'
)

cprintf() {
    # disable messages during -x
    {
        # Set C locale to avoid processing strings as Unicode. This will
        # improve performance.
        local LC_ALL=C LC_TYPE=C
        local __CPRINTF_VAR_NAME __CPRINTF_APPEND __CPRINTF_NEW_LINE=1 __CPRINTF_CLEAR=1 __CPRINTF_QUOTE __CPRINTF_QUOTE_SKIP
        local __CPRINTF_RESULT __CPRINTF_PROCESS __CPRINTF_PART __CPRINTF_HAS_COLOR __CPRINTF_HAS_BG
        local -a __CPRINTF_PARTS
        case "$1" in
            -a) __CPRINTF_VAR_NAME="$2"; __CPRINTF_APPEND=1; shift 2;;
            -A) __CPRINTF_VAR_NAME="$2"; __CPRINTF_APPEND=2; shift 2;;
            -v) __CPRINTF_VAR_NAME="$2"; shift 2;;
            -n) unset __CPRINTF_NEW_LINE; shift;;
        esac
        [ "$1" != "-c" ] || { unset __CPRINTF_CLEAR; shift; }
        [ "$1" != "--" ] || { shift; }
        IFS='~' read -ra __CPRINTF_PARTS <<< "$1"
        shift
        # Special quoting for PS1 variable
        [ "$__CPRINTF_VAR_NAME" != "PS1" ] || __CPRINTF_QUOTE=1
        for __CPRINTF_PART in "${__CPRINTF_PARTS[@]}"; do
            if [ "$__CPRINTF_PROCESS" ]; then
                case "$__CPRINTF_PART" in
                    d)
                        __CPRINTF_PART=${__CPRINTF_COLORS["$__CPRINTF_PART"]}
                        unset __CPRINTF_HAS_COLOR __CPRINTF_HAS_BG
                        ;;
                    [wWkKrRgGyYbBmMcC])
                        __CPRINTF_PART=${__CPRINTF_COLORS["f$__CPRINTF_PART"]}
                        if [ -n "$__CPRINTF_HAS_BG" ]; then
                            __CPRINTF_PART="${__CPRINTF_COLORS['d']}$__CPRINTF_PART"
                            unset __CPRINTF_HAS_BG
                        fi
                        __CPRINTF_HAS_COLOR=1
                        ;;
                    [wWkKrRgGyYbBmMcC][wWkKrRgGyYbBmMcC])
                        __CPRINTF_PART="${__CPRINTF_COLORS["f${__CPRINTF_PART:0:1}"]}${__CPRINTF_COLORS["b${__CPRINTF_PART:1:1}"]}"
                        __CPRINTF_HAS_COLOR=1
                        __CPRINTF_HAS_BG=1
                        ;;
                    [0-9]|[0-9][0-9]|[0-9][0-9][0-9])
                        __CPRINTF_PART=$'\e[38;5;'"${__CPRINTF_PART}m"
                        if [ -n "$__CPRINTF_HAS_BG" ]; then
                            __CPRINTF_PART="${__CPRINTF_COLORS['d']}$__CPRINTF_PART"
                            unset __CPRINTF_HAS_BG
                        fi
                        __CPRINTF_HAS_COLOR=1
                        ;;
                    *)
                        # It is quite difficult to match a case with "<1-3 digits> <1-3 digits>" using
                        # the case construct. For proper operation, extglob is required.
                        # Here we will use regular expressions, as such matching should be very rare.
                        if [[ "$__CPRINTF_PART" =~ ^[0-9]{1,3}\ [0-9]{1,3}$ ]]; then
                            __CPRINTF_PART=$'\e[38;5;'"${__CPRINTF_PART% *}m"$'\e[48;5;'"${__CPRINTF_PART#* }m"
                            __CPRINTF_HAS_COLOR=1
                            __CPRINTF_HAS_BG=1
                        else
                            __CPRINTF_PART="~${__CPRINTF_PART}~"
                            __CPRINTF_QUOTE_SKIP=1
                        fi
                        ;;
                esac
                if [ -n "$__CPRINTF_QUOTE" ]; then
                    # Special quoting for PS1 variable
                    [ -n "$__CPRINTF_QUOTE_SKIP" ] \
                        && unset __CPRINTF_QUOTE_SKIP \
                        || __CPRINTF_PART="\\[${__CPRINTF_PART}\\]"
                fi
                unset __CPRINTF_PROCESS
            else
                __CPRINTF_PROCESS=1
            fi
            __CPRINTF_RESULT+=$__CPRINTF_PART
        done
        if [[ "$__CPRINTF_CLEAR" ]] && [[ "$__CPRINTF_HAS_COLOR" ]]; then
            if [ -n "$__CPRINTF_QUOTE" ]; then
                __CPRINTF_RESULT+="\\[${__CPRINTF_COLORS['d']}\\]"
            else
                __CPRINTF_RESULT+=${__CPRINTF_COLORS['d']}
            fi
        fi
        if [[ "$__CPRINTF_VAR_NAME" ]]; then
            if [[ "$__CPRINTF_APPEND" ]] && [[ "${!__CPRINTF_VAR_NAME}" ]]; then
                printf -v __CPRINTF_RESULT "$__CPRINTF_RESULT" "$@" 2>&3
                if [ "$__CPRINTF_APPEND" -eq 1 ]; then
                    printf -v "$__CPRINTF_VAR_NAME" '%s%s' "${!__CPRINTF_VAR_NAME}" "$__CPRINTF_RESULT"
                else
                    printf -v "$__CPRINTF_VAR_NAME" '%s %s' "${!__CPRINTF_VAR_NAME}" "$__CPRINTF_RESULT"
                fi
            else
                printf -v "$__CPRINTF_VAR_NAME" "$__CPRINTF_RESULT" "$@" 2>&3
            fi
        else
            if [[ "$__CPRINTF_NEW_LINE" ]]; then
                __CPRINTF_RESULT+='\n'
            fi
            printf "$__CPRINTF_RESULT" "$@" 2>&3
        fi
    } 3>&2 2>/dev/null
}

_warn() { cprintf "~y~WARNING~K~:~d~ $1" "${@:2}"; }
_err() { cprintf "~r~ERROR~K~:~d~ $1" "${@:2}"; }
_info() { cprintf "~g~Info~K~:~d~ $1" "${@:2}"; }
_dbg() { cprintf "~K~Debug:~d~ $1" "${@:2}"; }

_trim() {
    local __TRIM_VAR __TRIM_WHAT='[:space:]' __TRIM_L=1 __TRIM_R=1
    [ "$1" != "-r" ] || { unset __TRIM_L; shift; }
    [ "$1" != "-l" ] || { unset __TRIM_R; shift; }
    [ "$1" != "-v" ] || { __TRIM_VAR="$2"; shift 2; }
    [ "$1" != "--" ] || { shift; }
    # Set C locale to avoid processing strings as Unicode. This will
    # improve performance. Set it only if we are trimming default
    # characters (spaces).
    [ -n "$2" ] && __TRIM_WHAT="$2" || local LC_ALL=C LC_TYPE=C
    local __TRIM_OUT="$1"
    # remove leading characters
    [ -z "$__TRIM_L" ] || __TRIM_OUT=${__TRIM_OUT#"${__TRIM_OUT%%[!${__TRIM_WHAT}]*}"}
    # remove trailing characters
    [ -z "$__TRIM_R" ] || __TRIM_OUT=${__TRIM_OUT%"${__TRIM_OUT##*[!${__TRIM_WHAT}]}"}
    [ -z "$__TRIM_VAR" ] && echo "$__TRIM_OUT" || printf -v "$__TRIM_VAR" '%s' "$__TRIM_OUT"
}

_dirname() {
    local __DIRNAME_VAR
    [ "$1" != "-v" ] || { __DIRNAME_VAR="$2"; shift 2; }
    [ "$1" != "--" ] || { shift; }
    local __DIRNAME_OUT=${1%/*}
    [ "$__DIRNAME_OUT" != "$1" ] || __DIRNAME_OUT="."
    [ -z "$__DIRNAME_VAR" ] && echo "$__DIRNAME_OUT" || printf -v "$__DIRNAME_VAR" '%s' "$__DIRNAME_OUT"
}
_basename() {
    local __BASENAME_VAR
    [ "$1" != "-v" ] || { __BASENAME_VAR="$2"; shift 2; }
    [ "$1" != "--" ] || { shift; }
    local __BASENAME_OUT
    if [ -n "$1" ]; then
        # Trim possible trailing slashes
        _trim -r -v __BASENAME_OUT "$1" "/"
        [ -z "__BASENAME_OUT" ] && __BASENAME_OUT="/" || __BASENAME_OUT="${__BASENAME_OUT##*/}"
    fi
    [ -z "$__BASENAME_VAR" ] && echo "$__BASENAME_OUT" || printf -v "$__BASENAME_VAR" '%s' "$__BASENAME_OUT"
}

_hash_file() {
    local SOURCE_FILE="$1" SOURCE_BASENAME="${1##*/}" SOURCE_PATH="${1%/*}"
    # If variables SOURCE_BASENAME and SOURCE_PATH are equivalent, it means
    # that SOURCE_FILE doesn't contain filesystem separator ("/"), i.e. it was
    # specified without directories. In this case we will use the current
    # directory as SOURCE_PATH.
    #
    # In addition, this function will work, not completely correct when
    # the input file name was indicated as a relative path. However, I don't
    # plan to use it with relative path. In the future, it may be necessary
    # to detect that the input file was specified as a relative path and
    # convert it to an absolute path.
    [ "$SOURCE_BASENAME" != "$SOURCE_PATH" ] || SOURCE_PATH="$PWD"
    local HASH_CACHE_PATH="$IAM_HOME/.cache/hash_file"
    _hash "$SOURCE_PATH"
    local HASH_FILE="$HASH_CACHE_PATH/${SOURCE_BASENAME}.${_HASH}.hash"
    if [ -f "$HASH_FILE" ] && [ "$HASH_FILE" -nt "$SOURCE_FILE" ]; then
        _HASH="$(<"$HASH_FILE")"
    else
        _hash < "$SOURCE_FILE"
        [ -d "$HASH_CACHE_PATH" ] || mkdir -p "$HASH_CACHE_PATH"
        printf '%s' "$_HASH" > "$HASH_FILE"
    fi
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
_get_hash() {
    while [ $# -gt 0 ]; do
        _hash_file "$1"
        echo "$_HASH"
        shift
    done
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
        set -- --fail --silent --show-error -k -L "$URL"
        _isnot need_proxy || set -- --proxy "http://127.0.0.1:52011" "$@"
        curl "$@"
    elif _has wget; then
        set -- -q -O - "$URL"
        isnot need_proxy || set -- -e "use_proxy=on" -e "https_proxy=http://127.0.0.1:52011" "$@"
        wget "$@"
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
_has_local() {
    [ -n "$__INSTALL_FUNCTIONS_AVAILABLE" ] || return 1
    local EXECUTABLE="$IAM_HOME/tools/bin/$1"
    _isnot windows || EXECUTABLE="${EXECUTABLE}.exe"
    [ -x "$EXECUTABLE" ] && return 0 || return 1
}
_has_executable() { builtin type -P "$1" >/dev/null && return 0 || return 1; }
_has_function() { declare -f -F "$1" >/dev/null && return 0 || return 1; }
_maybe_local() {
    if [ -n "$__INSTALL_FUNCTIONS_AVAILABLE" ] && _check _is_install_available "$1"; then
        if _has_local "$1" || ! _has_executable "$1"; then
            ,install -executable "$1" || :
        fi
    fi
}
_has_potentially() {
    _hasnot "$1" || return 0
    [ -n "$__INSTALL_FUNCTIONS_AVAILABLE" ] && _check _is_install_available "$1" && return 0 || return 1
}
_hasnot_potentially() { _has_potentially "$1" && return 1 || return 0; }

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

_random() {
    local chars="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local V=""
    if [ "$1" = "-v" ]; then
        V="$2"
        shift 2
    fi
    local count="${1:-8}"
    local result=""
    while [ "$count" -ne 0 ]; do
        result="$result${chars:$(( RANDOM % ${#chars} )):1}"
        count=$(( count - 1 ))
    done
    [ -n "$V" ] && printf -v "$V" "$result" || echo "$result"
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
    # We want to check conditions that include the "-" character, but the shell
    # variable cannot contain this symbol. The right thing to do is to use
    # the _hash function to modify the condition and then build a cache variable
    # using the calculated hash. However, this function needs to be as fast
    # as possible, and calculating the hash will slow it down a bit.
    # Thus, there is a compromise - replace "-" with "_". It is not quite
    # correct because the conditions "linux_x64" and "linux-x64" will be
    # treated as the same.
    local CONDITION="${1//-/_}"
    local V="__CACHE_IS_$CONDITION"
    [ -z "${!V}" ] || return "${!V}"
    local R=0 TMPVAL
    case "$CONDITION" in
        # Architecture
        x86_64|aarch64_be|aarch64|armv8b|armv8l)
            _cache __uname_machine
            [ "$_CACHE" = "$CONDITION" ] || R=1
            ;;
        x64)   _is x86_64 || R=1 ;;
        arm64) ! _is aarch64_be && ! _is aarch64 && ! _is armv8b && ! _is armv8l && R=1 || : ;;
        # OS
        hpux|aix|sunos|macos|linux|cygwin|msys|mingw)
            _cache __uname_kernel_name
            case "$CONDITION" in
                hpux)   [ "$_CACHE" = "HP-UX" ]  || R=1 ;;
                aix)    [ "$_CACHE" = "AIX" ]    || R=1 ;;
                sunos)  [ "$_CACHE" = "SunOS" ]  || R=1 ;;
                macos)  [ "$_CACHE" = "Darwin" ] || R=1 ;;
                linux)  [ "$_CACHE" = "Linux" ]  || R=1 ;;
                cygwin) [ "$_CACHE" = ${_CACHE#CYGWIN_NT*} ] && R=1 || : ;;
                msys)   [ "$_CACHE" = ${_CACHE#MSYS_NT*} ]   && R=1 || : ;;
                mingw)  [ "$_CACHE" = ${_CACHE#MINGW*} ]     && R=1 || : ;;
            esac
            ;;
        wsl)
            _is in-container && R=1 || {
                _cache __uname_kernel_release
                [ -z ${_CACHE%%*-WSL2} ] || R=1
            }
            ;;
        windows)     ! _is cygwin && ! _is mingw && ! _is msys && R=1 || : ;;
        unix)        ! _is windows || R=1 ;;
        # OS + Architecture
        linux_x64)   _is linux && _is x64   || R=1 ;;
        windows_x64) _is windows && _is x64 || R=1 ;;
        macos_x64)   _is macos && _is x64   || R=1 ;;
        # Other
        root)        [ "$(id -u 2>/dev/null)" = "0" ] || R=1 ;;
        in_container)
            # Let's assume that by default this is not a container
            R=1
            # As for now, we detect containers only on Linux
            if _is linux; then
                # Check for /proc/1/sched file. It is possible that procfs
                # is not installed in the current environment. But it's quite
                # hard to imagine a normal Linux environment without procfs.
                # Therefore, we assume that this is a container environment,
                # but not a normal environment when /proc does not exist.
                # The same for PID #1. A normal environment should have
                # a process with PID #1 that is started by the kernel.
                # Let's assume a containerized environment if there is no
                # process with PID #1.
                if [ ! -f /proc/1/sched ]; then
                    R=0
                else
                    # Read the first word from the first line of /proc/1/sched
                    read -d ' ' -r TMPVAL < /proc/1/sched
                    # It is expected that the first line in a normal environment
                    # will be something like:
                    #     init (1, #threads: 1)
                    # or
                    #     systemd (1, #threads: 1)
                    # The first word is the executable file of the init process,
                    # and it is usually 'init' or 'systemd'. Everything else
                    # except the allowed values will indicate a container
                    # environment.
                    [ "$TMPVAL" != "init" ] && [ "$TMPVAL" != "systemd" ] && R=0 || R=1
                fi
            fi
            ;;
        in_docker)   _is in_container && [ -f /.dockerenv ] || R=1 ;;
        sudo)        [ -n "$SUDO_USER" ] || R=1 ;;
        tmux)        [ -n "$TMUX" ] || R=1 ;;
        # Clouds
        aws)         _is cloud && curl -s -I http://169.254.169.254 | grep -qF 'Server: EC2ws' || R=1 ;;
        aws_metadata_available)
            _is aws && TMPVAL="$(_aws_metadata instance-id)" && [ -n "$TMPVAL" ] || R=1
            ;;
        cloud)
            # We have only one stable way to detect if the current machine
            # is in the cloud, and that is to try to query the metadata URL http://169.254.169.254.
            # This method is ugly because we must wait some amount of time for
            # network connection. Also, it is impossible to use bash built-in
            # TCP connection here because bash has no ability to specify timeout
            # and attempt to make a connection in non-cloud environment leads
            # to hang-up. Thus here we first try to check if curl is available.
            # If it is not, then cloud detection will return false. After that,
            # we try to make a request with 100 millisecond timeout.
            # Unfortunatelly, this will lead to 100 millisecond delay in
            # non-cloud environments.
            _has curl && curl -s -I --connect-timeout 0.1 -o /dev/null http://169.254.169.254 || R=1
            ;;
        need_proxy)
            # If /proc/net/tcp doesn't exists, then we don't need proxy
            [ -r /proc/net/tcp ] && {
                # Try to detect port listener. We expect out proxy to be
                # listening 127.0.0.1:52011. Here is:
                #   0100007F      - 127.0.0.1
                #   CB2B          - 52011
                #   00000000:0000 - remote address, 0.0.0.0:0 in our case
                # If there is any error, consider that we don't need the proxy.
                grep -qF ': 0100007F:CB2B 00000000:0000 ' /proc/net/tcp 2>/dev/null || R=1
            } || R=1
            ;;
        *)
            echo "bashrc error: unknown _is '$CONDITION'" >&2
            R=1
            ;;
    esac
    printf -v "$V" '%s' "$R"
    return "${!V}"
}

_isnot() { _is "$1" && return 1 || return 0; }

_unexport() {
    local TMPVAL TMPVAR
    for TMPVAR; do
        TMPVAL="${!TMPVAR}"
        unset "$TMPVAR"
        printf -v "$TMPVAR" '%s' "$TMPVAL"
    done
}

mkdir -p "$IAM_HOME/tools/bin"
_addpath -start "$IAM_HOME/tools/bin"
_addpath "/usr/local/bin"

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
    # Insert path to ports for MacOS
    _addpath -start "/opt/local/bin"
    # Use curl from brew if available
    #[ ! -x /usr/local/opt/curl/bin/curl ] || _addpath -start "/usr/local/opt/curl/bin"
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
elif _is wsl; then
    if [ -d /usr/bin/windows/System32 ]; then
        _addpath -start "/usr/bin/windows" "/usr/bin/windows/System32"
    fi
fi

# GCP
if [ -f ~/gcloud/google-cloud-sdk/path.bash.inc ]; then
    . ~/gcloud/google-cloud-sdk/path.bash.inc
fi

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

# In some cases, it is possible that we do not have the 'vi/vim' commands,
# but vim exists as a binary file vim.basic. E.g. it is possible in docker
# containers from distroless docker images, and when vim is installed by
# simply unpacking its package in filesystem. Let's create an alias for this
# case.
if
    ! command -v vi >/dev/null 2>&1 && \
    ! command -v vim >/dev/null 2>&1 && \
    [ ! -e "$IAM_HOME/tools/bin/vim" ] && \
    [ -x /usr/bin/vim.basic ]
then
    ln -sf /usr/bin/vim.basic "$IAM_HOME/tools/bin/vim"
fi

# try to use en_US.UTF-8 locale if available
if [ "$LANG" != "en_US.UTF-8" ] && _has locale && [ "$(LANG=en_US.UTF-8 locale charmap 2>/dev/null)" = "UTF-8" ]; then
    LANG="en_US.UTF-8"
    export LANG
fi

#if _hasnot curl && [ ! -e "$IAM_HOME/tools/bin/curl-portable" ] && _has sha256sum && _is linux-x64; then
#    printf 'Download curl-portable ...'
#    HASH="354bbcb8cd73f1deafff9f82743e9396b27a8aece2893e8477156e23cca5ca30"
#    URL_HOST="dotfiles.chpock.tk"
#    URL_PORT="80"
#    URL_PATH="/curl-portable.8.13.0.${HASH}.linux.x86_64"
#    # This IP is from github manual:
#    # https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site
#    # As for now, there are 4 IPs:
#    #   185.199.108.153
#    #   185.199.109.153
#    #   185.199.110.153
#    #   185.199.111.153
#    URL_IP="185.199.111.153"
#    mkdir -p "$IAM_HOME/tools/bin"
#    exec 3<>"/dev/tcp/$URL_IP/$URL_PORT"
#    printf 'GET %s HTTP/1.1\r\nHost: %s\r\nConnection: close\r\n\r\n' "$URL_PATH" "$URL_HOST" >&3
#    while IFS= read -r line <&3; do
#        [[ "$line" == $'\r' || "$line" == "" ]] && break
#    done
#    cat <&3 >"$IAM_HOME/tools/bin/curl-portable"
#    exec 3<&-
#    exec 3>&-
#    HASH_CALC="$(sha256sum "$IAM_HOME/tools/bin/curl-portable" | awk '{print $1}')"
#    if [ "$HASH_CALC" = "$HASH" ]; then
#        chmod +x "$IAM_HOME/tools/bin/curl-portable"
#    else
#        rm -f "$IAM_HOME/tools/bin/curl-portable"
#    fi
#    unset HASH HASH_CALC URL_HOST URL_PORT URL_PATH
#fi

# Remove outdated files/directories

[ -e "$IAM_HOME/tmux_sessions/sessions-backup-ids" ] \
    && TMUX_TMPDIR="$IAM_HOME/tmux_sessions" tmux kill-server >/dev/null 2>&1 || true

[ -z "$IAM_HOME" ] || {
    rm -rf \
        "$IAM_HOME/kitty_sessions" \
        "$IAM_HOME/shell_sessions" \
        "$IAM_HOME/tmux_sessions"
    # Remove outdated bash completions if they exist
    rm -f \
    "$IAM_HOME/tools/bash_completion"/ecconfigure.completion.bash \
    "$IAM_HOME/tools/bash_completion"/ectool.completion.bash \
    "$IAM_HOME/tools/bash_completion"/electricflow.completion.bash
}

if [ -n "$__KITTY_ID" ]; then
    _TERM_SESSION_ID="$__KITTY_ID"
    unset __KITTY_ID
    #_dbg "_TERM_SESSION_ID=%s (from __KITTY_ID)" "$_TERM_SESSION_ID"
#else
    #_dbg "__KITTY_ID is not defined"
fi

if [ -n "$_TERM_SESSION_ID" ]; then
    #_dbg "_TERM_SESSION_ID=%s" "$_TERM_SESSION_ID"
    _unexport _TERM_SESSION_ID
    _TERM_SESSION_DIR="$IAM_HOME/session/term/id-$_TERM_SESSION_ID"
    mkdir -p "$_TERM_SESSION_DIR"
#else
    #_dbg "_TERM_SESSION_ID is not defined"
fi

tools() {

    local CMD="$1"
    local PARAM="$2"
    local PARAM_EX="$3"
    local LINE
    local I_DESC I_URL I_FILE I_SIZE I_FILTER I_ON_UPDATE
    local SIZE HASH
    local CHECK_STATE
    local IS_ERROR
    local IDX
    local TOOLS_FILE="$IAM_HOME/local_tools"
    local TOOLS_URL="https://raw.githubusercontent.com/chpock/dotfiles/master/tools.list"
    # This banner will be shown in case of 'update important' to be aware that
    # we are interacting with something remote and may potentially get stuck.
    # We need to understand why we are stuck in this case. After the update,
    # we no longer need this message. It should be removed to avoid unnecessary
    # noise. To achieve this, it will be shown without a newline character,
    # and after 'important update' completion, cursor will return to
    # the beginning of the line.
    local UPDATE_IMPORTANT_BANNER="Updating important tools..."
    local UPDATE_IMPORTANT_BANNEX="                           "

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
            _warn 'Tools are locked now and will not be updated.'
            return
        fi
        if ! _get_url -check; then
            [ "$PARAM" = "important" ] || _err "Could not update tools: curl/wget command not found"
            return 1
        fi
        if [ "$PARAM" = "background" ]; then
            tools update background-real >/dev/null 2>&1 &
            disown $!
            return
        fi
    fi

    local recs=() TOOLS_EXISTS=
    local files_by_size=() checks_by_size=()
    local files_by_hash=() checks_by_hash=()

    if [ -f "$TOOLS_FILE" ]; then
        _hash_file "$TOOLS_FILE"
        [ "$_HASH" != "$LOCAL_TOOLS_FILE_HASH" ] || TOOLS_EXISTS=1
    fi

    if [ -z "$TOOLS_EXISTS" ]; then
        local TMP="$(mktemp)"
        if [ "$PARAM" = "important" ]; then
            printf '%s' "$UPDATE_IMPORTANT_BANNER"
            unset UPDATE_IMPORTANT_BANNER
        fi
        if ! _get_url "$TOOLS_URL" >"$TMP" 2>/dev/null; then
            rm -f "$TMP"
            CHECK_STATE=1
            [ "$PARAM" = "important" ] || _err "An unexpected error occurred while updating the list of tools."
        else
            _hash < "$TMP"
            if [ "$_HASH" != "$LOCAL_TOOLS_FILE_HASH" ]; then
                rm -f "$TMP"
                [ "$PARAM" = "important" ] || _warn "The list of tools is not properly updated. The downloaded file hash %s doesn't match the expected hash %s." "$_HASH" "$LOCAL_TOOLS_FILE_HASH"
            else
                mv -f "$TMP" "$TOOLS_FILE"
                TOOLS_EXISTS=1
            fi
        fi
    fi

    if [ -n "$TOOLS_EXISTS" ]; then
        while IFS= read -r LINE || [ -n "$LINE" ]; do
            if [ "${LINE:0:5}" = "tool:" ]; then
                I_DESC="${LINE#*: }"
                unset I_URL I_FILE I_SIZE I_HASH I_FILTER_IS I_FILTER_HAS I_IMPORTANT I_ON_UPDATE
            elif [ -z "$I_URL" ]; then
                I_URL="$LINE"
            elif [ -z "$I_FILE" ]; then
                printf -v LINE '%q' "$LINE"; # quote string
                eval "I_FILE=\"${LINE//\\\$/\$}\""; # enable $VAR
            elif [ -z "$I_SIZE" ]; then
                local P1="${LINE%:*}"
                if [ "$P1" = "$LINE" ]; then
                    [ "${LINE:0:1}" = "#" ] && I_HASH="${LINE:1}" || I_SIZE="$LINE"
                else
                    if [ "$P1" = "is" ]; then
                        I_FILTER_IS="${LINE#*: }"
                    elif [ "$P1" = "has" ]; then
                        I_FILTER_HAS="${LINE#*: }"
                    elif [ "$P1" = "on update" ]; then
                        I_ON_UPDATE="${LINE#*: }"
                    elif [ "$P1" = "important" ]; then
                        I_IMPORTANT="${LINE#*: }"
                        # tolower
                        I_IMPORTANT="${I_IMPORTANT,,}"
                        # Allow only 1/yes/true. Unset for anything else that
                        # will mean 'false'.
                        [ "$I_IMPORTANT" != "1" ] && [ "$I_IMPORTANT" != "yes" ] && [ "$I_IMPORTANT" != "true" ] && unset I_IMPORTANT || :
                    else
                        echo "ERROR: unexpected line in tools list: $LINE"
                    fi
                fi
            else
                echo "ERROR: unexpected line in tools list: $LINE"
            fi
            # continue the loop if a tool record is incomplete
            [ -n "$I_SIZE$I_HASH" ] || continue
            [ "$PARAM" = "important" ] && [ -z "$I_IMPORTANT" ] && continue || :
            [ -n "$I_FILTER_IS" ] && ! _is "$I_FILTER_IS" && continue || :
            [ -n "$I_FILTER_HAS" ] && ! _has "$I_FILTER_HAS" && continue || :
            if [ -e "$I_FILE" ]; then
                if [ -n "$I_SIZE" ]; then
                    files_by_size+=("$I_FILE")
                    checks_by_size+=("$I_DESC" "$I_URL" "$I_FILE" "$I_ON_UPDATE" "$I_SIZE" "$I_HASH")
                else
                    files_by_hash+=("$I_FILE")
                    checks_by_hash+=("$I_DESC" "$I_URL" "$I_FILE" "$I_ON_UPDATE" "$I_SIZE" "$I_HASH")
                fi
            else
                recs+=("$I_DESC" "$I_URL" "$I_FILE" "$I_ON_UPDATE" "$I_SIZE" "$I_HASH" 0 0)
            fi
            unset I_DESC I_URL I_FILE I_SIZE I_HASH I_FILTER I_ON_UPDATE
        done < "$TOOLS_FILE"
    fi

    if [ "${#files_by_size[@]}" -gt 0 ]; then
        IDX=0
        while read -r SIZE; do
            recs+=("${checks_by_size[@]:$(( 6 * IDX++)):6}" "$SIZE" 0)
        done < <(_get_size "${files_by_size[@]}")
    fi

    if [ "${#files_by_hash[@]}" -gt 0 ]; then
        IDX=0
        while read -r HASH; do
            recs+=("${checks_by_hash[@]:$(( 6 * IDX++)):6}" 0 "$HASH")
        done < <(_get_hash "${files_by_hash[@]}")
    fi

    # do something with a tool record
    IDX=0
    while [ $IDX -lt ${#recs[@]} ]; do
        I_DESC="${recs[IDX++]}"
        I_URL="${recs[IDX++]}"
        I_FILE="${recs[IDX++]}"
        I_ON_UPDATE="${recs[IDX++]}"
        I_SIZE="${recs[IDX++]}"
        I_HASH="${recs[IDX++]}"
        SIZE="${recs[IDX++]}"
        HASH="${recs[IDX++]}"
        if [ "check" = "$CMD" ]; then
            if [ "$SIZE$HASH" = "00" ]; then
                LINE="~R~NOT FOUND"
                SIZE="undef"
                HASH="undef"
                [ -n "$CHECK_STATE" ] || CHECK_STATE=1
            else
                if [ -n "$I_HASH" ] && [ "$I_HASH" != "$HASH" ]; then
                    LINE="~y~OUTDATED "
                    CHECK_STATE=2
                elif [ -n "$I_SIZE" ] && [ "$I_SIZE" -ne "$SIZE" ]; then
                    LINE="~y~OUTDATED "
                    CHECK_STATE=2
                else
                    LINE="~g~OK       "
                fi
            fi
            if [ "quick" != "$PARAM" ]; then
                if [ -n "$I_SIZE" ]; then
                    cprintf "$LINE ~K~[~d~!Size current: %8s ~K~/~d~ expected: %8s~K~]~d~ %s" "$SIZE" "$I_SIZE" "${I_FILE/$HOME/\~}"
                else
                    cprintf "$LINE ~K~[~d~!Hash current: %8s ~K~/~d~ expected: %8s~K~]~d~ %s" "$HASH" "$I_HASH" "${I_FILE/$HOME/\~}"
                fi
            fi
        elif [ "update" = "$CMD" ]; then
            if [ "$PARAM" != "force" ]; then
                [ -n "$I_HASH" ] && [ "$HASH" = "$I_HASH" ] && continue || true
                [ -n "$I_SIZE" ] && [ "$SIZE" -eq "$I_SIZE" ] && continue || true
            fi
            IS_ERROR=0
            mkdir -p "${I_FILE%/*}"
            local TMP="$(mktemp)"
            if [ "$PARAM" = "important" ]; then
                if [ -n "$UPDATE_IMPORTANT_BANNER" ]; then
                    printf '%s' "$UPDATE_IMPORTANT_BANNER"
                    unset UPDATE_IMPORTANT_BANNER
                fi
                _get_url "$I_URL" >"$TMP" 2>/dev/null || IS_ERROR=$?
            else
                printf "Download: %s '%s'..." "$I_DESC" "${I_FILE##*/}"
                _get_url "$I_URL" >"$TMP" || IS_ERROR=$?
                if [ "$IS_ERROR" -ne 0 ]; then
                    cprintf " ~R~ERROR"
                else
                    cprintf " ~r~OK"
                fi
            fi
            if [ "$IS_ERROR" -ne 0 ]; then
                rm -f "$TMP"
            else
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
                cprintf "~y~Some or all local tools are not exist and will be updated in background.\n"
            elif [ "$CHECK_STATE" -eq 2 ]; then
                cprintf "~y~Some or all local tools are outdated and will be updated in background.\n"
            fi
            tools update background
        else
            if [ "$CHECK_STATE" -eq 1 ]; then
                cprintf "~r~Some or all local tools are not exist. Run the 'tools update' command.\n"
            elif [ "$CHECK_STATE" -eq 2 ]; then
                cprintf "~y~Some or all local tools are outdated. Run the 'tools update' command.\n"
            fi
        fi
    elif [ "update" = "$CMD" ] && [ "important" = "$PARAM" ] && [ -z "$UPDATE_IMPORTANT_BANNER" ]; then
        printf '\r%s\r' "$UPDATE_IMPORTANT_BANNEX"
    fi

}

complete -W "check update lock unlock" tools

tools update important

# Load shell.rc scripts now as other scripts may depend on functions defined there
for SCRIPT in "$IAM_HOME"/shell.rc/*; do
    [ -e "$SCRIPT" ] || continue
    ! _once "PS1 -> source $SCRIPT" || source "$SCRIPT"
done
unset SCRIPT

if _has tmux; then

    [ ! -n "$__TMUX_FUNCTIONS_AVAILABLE" ] || _tmux_generate_conf

    # don't store session sockets in /tmp because they can be
    # cleared by anyone at any time
    TMUX_TMPDIR="$IAM_HOME/session/tmux"
    export TMUX_TMPDIR
    [ -e "$TMUX_TMPDIR" ] || mkdir -p "$TMUX_TMPDIR"

    if _is tmux; then
        if [ -n "$_TMUX_SESSION_ID" ]; then
            #_dbg "_TMUX_SESSION_ID=%s (from tmux env)" "$_TMUX_SESSION_ID"
            _unexport _TMUX_SESSION_ID
        else
            _random -v _TMUX_SESSION_ID
            #_dbg "_TMUX_SESSION_ID=%s (random)" "$_TMUX_SESSION_ID"
            command tmux set-env _TMUX_SESSION_ID "$_TMUX_SESSION_ID"
        fi
        _TMUX_SESSION_DIR="$TMUX_TMPDIR/id-$_TMUX_SESSION_ID"
        mkdir -p "$_TMUX_SESSION_DIR"
        [ -e "$_TMUX_SESSION_DIR/sid" ] || command tmux display-message -p '#{session_id}' > "$_TMUX_SESSION_DIR/sid"

        if _TMUX_WINDOW_ID="$(tmux show -w -t "$TMUX_PANE" -v '@persistent-id' 2>/dev/null)"; then
            #_dbg "_TMUX_WINDOW_ID=%s (from tmux options)" "$_TMUX_WINDOW_ID"
            : no-op
        elif [ -e "$_TMUX_SESSION_DIR/mode-restore" ]; then
            #_dbg "this tmux session is in restore mode. Getting _TMUX_WINDOW_ID from tmux options ..."
            while ! _TMUX_WINDOW_ID="$(tmux show -w -t "$TMUX_PANE" -v '@persistent-id' 2>/dev/null)"; do
                #_dbg "_TMUX_WINDOW_ID is not yet defined"
                sleep 1
            done
            #_dbg "_TMUX_WINDOW_ID=%s (from tmux options)" "$_TMUX_WINDOW_ID"
        else
            _random -v _TMUX_WINDOW_ID
            command tmux set -w -t "$TMUX_PANE" '@persistent-id' "$_TMUX_WINDOW_ID"
            #_dbg "_TMUX_WINDOW_ID=%s (random)" "$_TMUX_WINDOW_ID"
        fi
        _TMUX_WINDOW_DIR="$_TMUX_SESSION_DIR/wid-$_TMUX_WINDOW_ID"
        mkdir -p "$_TMUX_WINDOW_DIR"
    fi

    if _isnot tmux; then

        tmux() {
            local _TMUX_SESSION_ID
            local TMUX_CONFIG="$IAM_HOME/tmux.conf"
            if [ -z "$1" ]; then
                local _TMUX_SESSION_ID TMUX_SESSION
                if ! TMUX_SESSION="$(
                    export SSH_PUB_KEY _GIT_USER_EMAIL _GIT_USER_NAME
                    command tmux -f "$TMUX_CONFIG" new-session -d -P -F '#{session_id}'
                )"
                then
                    _err 'failed to create a new tmux session: %s' "$TMUX_SESSION"
                    return 1
                fi
                # Wait for the new tmux session to set its _TMUX_SESSION_ID
                local COUNT=1 MAX_COUNT=10
                while ! _TMUX_SESSION_ID="$(command tmux show-env -t "$TMUX_SESSION" _TMUX_SESSION_ID 2>/dev/null)"; do
                    echo "[$COUNT/$MAX_COUNT] wait for the new tmux session to set its _TMUX_SESSION_ID"
                    sleep 1
                done
                # Strip variable name
                _TMUX_SESSION_ID="${_TMUX_SESSION_ID#*=}"
                set -- attach-session -t "$TMUX_SESSION"
            fi
            if [ "$1" = "attach-session" ] || [ "$1" = "attach" ]; then
                if [ -n "$_TERM_SESSION_DIR" ]; then
                    if [ -z "$_TMUX_SESSION_ID" ]; then
                        local ARG PREV_ARG
                        for ARG; do
                            if [ "$PREV_ARG" != "-t" ]; then
                                PREV_ARG="$ARG"
                                continue
                            fi
                            if ! _TMUX_SESSION_ID="$(command tmux show-env -t "$ARG" _TMUX_SESSION_ID 2>/dev/null)"; then
                                unset _TMUX_SESSION_ID
                            else
                                # Strip variable name
                                _TMUX_SESSION_ID="${_TMUX_SESSION_ID#*=}"
                            fi
                            break
                        done
                    fi
                    if [ -n "$_TMUX_SESSION_ID" ]; then
                        echo "$_TMUX_SESSION_ID" > "$_TERM_SESSION_DIR/tmux_session_id"
                    fi
                fi
                exec tmux -f "$TMUX_CONFIG" "$@"
            fi
            command tmux -f "$TMUX_CONFIG" "$@"
        }

        # The 'tmux' function should be available the moment we call ',tmux restore'. We execute 'tmux'
        # with the correct tmux configuration file in the scope of this function.
        [ -z "$__TMUX_FUNCTIONS_AVAILABLE" ] || ,tmux restore

        # Restore tmux session for specific terminal. This should be done after restoring tmux sessions
        # with ',tmux restore'.
        if [ -n "$_TERM_SESSION_DIR" ] && [ -e "$_TERM_SESSION_DIR/tmux_session_id" ]; then
            _TMUX_SESSION_ID="$(< "$_TERM_SESSION_DIR/tmux_session_id")"
            _TMUX_SESSION_DIR="$TMUX_TMPDIR/id-$_TMUX_SESSION_ID"
            if [ ! -e "$_TMUX_SESSION_DIR/sid" ]; then
                _warn "this terminal session is associated with tmux session '%s', but its sid file does not exist: %s" \
                    "$_TMUX_SESSION_ID" "$_TMUX_SESSION_DIR/sid"
            else
                TMUX_SESSION="$(< "$_TMUX_SESSION_DIR/sid")"
                if ! command tmux has-session -t "$TMUX_SESSION" 2>/dev/null; then
                    _warn "this terminal session is associated with tmux session '%s' (%s), but currently tmux doesn't have such a session" \
                        "$_TMUX_SESSION_ID" "$TMUX_SESSION"
                else
                    exec tmux attach-session -t "$TMUX_SESSION"
                fi
                unset TMUX_SESSION
            fi
            unset _TMUX_SESSION_ID _TMUX_SESSION_DIR
        fi

    else
        alias tmux="tmux -f \"$IAM_HOME/tmux.conf\""
    fi

fi; # tmux

if [ -z "$_SHELL_SESSION_ID" ]; then
    if [ -n "$_TMUX_WINDOW_DIR" ] && [ -r "$_TMUX_WINDOW_DIR/shell_session_id" ]; then
        _SHELL_SESSION_ID="$(< "$_TMUX_WINDOW_DIR/shell_session_id")"
        #_dbg "_SHELL_SESSION_ID=%s (from _TMUX_WINDOW_ID)" "$_SHELL_SESSION_ID"
    elif [ -n "$_TERM_SESSION_DIR" ] && [ -r "$_TERM_SESSION_DIR/shell_session_id" ]; then
        _SHELL_SESSION_ID="$(< "$_TERM_SESSION_DIR/shell_session_id")"
        #_dbg "_SHELL_SESSION_ID=%s (from _TERM_SESSION_ID)" "$_SHELL_SESSION_ID"
    else
        _random -v _SHELL_SESSION_ID
        #_dbg "_SHELL_SESSION_ID=%s (random)" "$_SHELL_SESSION_ID"
    fi
else
    # If _SHELL_SESSION_ID exists here, then we might want to preserve it.
    # But now we need to remove it from the export to avoid unwanted inheritance.
    _unexport _SHELL_SESSION_ID
    #_dbg "_SHELL_SESSION_ID=%s (already defined)" "$_SHELL_SESSION_ID"
fi

_SHELL_SESSION_DIR="$IAM_HOME/session/shell/id-$_SHELL_SESSION_ID"
mkdir -p "$_SHELL_SESSION_DIR"

if [ -n "$_TMUX_WINDOW_DIR" ]; then
    echo "$_SHELL_SESSION_ID" > "$_TMUX_WINDOW_DIR/shell_session_id"
    #_dbg "Assign shell session '%s' to tmux window '%s'" "$_SHELL_SESSION_ID" "$_TMUX_WINDOW_ID"
elif [ -n "$_TERM_SESSION_DIR" ]; then
    echo "$_SHELL_SESSION_ID" > "$_TERM_SESSION_DIR/shell_session_id"
    #_dbg "Assign shell session '%s' to term '%s'" "$_SHELL_SESSION_ID" "$_TERM_SESSION_ID"
fi

# Here we create a file where timestamp is the time when this shell instance
# was last active. It will later be used in PROMPT_COMMAND to detect when
# shell.rc functions have been updated and need to be reloaded. It will also
# be used to clean up orphaned shell sessions. We use 'echo' instead of
# 'touch' because 'echo' is a built-in bash command and is much faster.
_SHELL_SESSION_STAMP="$_SHELL_SESSION_DIR/stamp"
echo > "$_SHELL_SESSION_STAMP"

_isnot "aws" || _aws_metadata() {

    local METADATA_URL="http://169.254.169.254/latest"

    # When detecting the metadata access type, we use a connection timeout of
    # 100 milliseconds. This will allow an error to be returned without delay
    # if there are problems accessing metadata.
    #
    # Other curl requests use 1 a connection timeout of 1 second. Since we
    # already know that the metadata can be accessed, we use a larger timeout
    # to avoid failures due to CPU/network overload.

    # Check AWS metadata access type

    if [ -z "$_AWS_METADATA_ACCESS_TYPE" ]; then
        local STATUS_CODE="$(command curl -s -f --connect-timeout 0.1 -o /dev/null -I -w "%{http_code}" "$METADATA_URL/meta-data/instance-id")"
        if [ "$STATUS_CODE" = "200" ]; then
            _AWS_METADATA_ACCESS_TYPE="plain"
        elif [ "$STATUS_CODE" = "401" ]; then
            _AWS_METADATA_ACCESS_TYPE="token"
        else
            _AWS_METADATA_ACCESS_TYPE="no"
        fi
    fi
    [ "$_AWS_METADATA_ACCESS_TYPE" != "no" ] || return 1

    set -- command curl -s -f --connect-timeout 1 "$METADATA_URL/meta-data/$1"

    # Get access token if it is required

    if [ "$_AWS_METADATA_ACCESS_TYPE" = "token" ]; then
        # returns 'error' if the previous attempt to return the metadata token
        # failed with an error
        [ "$_AWS_METADATA_TOKEN" != "error" ] || return 1
        local CURRENT_TIMESTAMP="$(date +%s)" DURATION_HOURS_LEFT=0
        # If _AWS_METADATA_TOKEN_TIMESTAMP exists, then compute current session
        # duration as "6 hours + <old timestamp> - <current timestamp>".
        # If _AWS_METADATA_TOKEN_TIMESTAMP does not exist, DURATION_HOURS_LEFT
        # will have an initial value of '0'.
        #
        # 21600 - 6 hours, 3600 - 1 hour
        [ -z "$_AWS_METADATA_TOKEN_TIMESTAMP" ] || DURATION_HOURS_LEFT=$(( ( 21600 + _AWS_METADATA_TOKEN_TIMESTAMP - CURRENT_TIMESTAMP ) / 3600 ))
        if [ "$DURATION_HOURS_LEFT" -le 0 ]; then
            # Try to get a token. If the curl command fails or an empty response is
            # received, return 'error'.
            # 21600 - 6 hours
            if ! _AWS_METADATA_TOKEN="$(command curl -s -f --connect-timeout 1 -X PUT \
                -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" \
                "$METADATA_URL/api/token")" || [ -z "$_AWS_METADATA_TOKEN" ]
            then
                _AWS_METADATA_TOKEN="error"
                return 1
            fi
            # Remember the token's timestamp
            _AWS_METADATA_TOKEN_TIMESTAMP="$CURRENT_TIMESTAMP"
        fi
        set -- "$@" -H "X-aws-ec2-metadata-token: $_AWS_METADATA_TOKEN"
    fi

    # Run curl

    "$@"

}

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

    sep() {
        local WIDTH=79
        [ -z "$1" ] || WIDTH=$(( WIDTH - ${#1} - 6 ))
        local BAR
        printf -v BAR "%${WIDTH}s"
        BAR="${BAR// /-}"
        cprintf -v BAR '~K~%s' "$BAR"
        [ -z "$1" ] || cprintf -a BAR '~K~[ ~d~%s ~K~]--' "$1"
        echo "$BAR"
    }

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
            # Linux standard base, grep&sed in the box.
            # This detection should be used before /etc/debian_version,
            # as Ubuntu also contains /etc/debian_version, but /etc/lsb-release
            # provides more accurate information.
            # * Ubuntu
            UNAME_RELEASE="$(grep DISTRIB_DESCRIPTION= /etc/lsb-release | sed 's/DISTRIB_DESCRIPTION\s*=\s*"//' | sed 's/""*$//')"
        elif [ -f /etc/debian_version ]; then
            # Debian
            UNAME_RELEASE="Debian $(cat /etc/debian_version)"
        elif [ -e /etc/amazon-linux-release ]; then
            # Amazon Linux
            UNAME_RELEASE="$(cat /etc/amazon-linux-release)"
        elif [ -f /usr/lib/system-release ]; then
            # Some common location for linux distribution name
            UNAME_RELEASE="$(cat /usr/lib/system-release)"
        elif [ -f /etc/system-release ]; then
            # Some common location for linux distribution name
            UNAME_RELEASE="$(cat /etc/system-release)"
        else
            # Linux, unknown distribution name
            UNAME_RELEASE="Linux, unknown distribution"
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

    sep
    printf -- "Hostname  : %s\n" "$HOSTNAME"
    printf -- "Kernel    : %s\n" "$UNAME_ALL"
    printf -- "Machine   : %s\n" "$UNAME_MACHINE"
    cprintf -- "Release   : ~c~%s" "$UNAME_RELEASE"

    if _is need_proxy; then
        cprintf -- "Proxy     : ~g~%s" "Enabled"
    fi

    sep "OS"

    if ! _is in-container && ! _is sudo; then
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

                sep "Network"
            fi
        fi
    fi

    if ! _is in-container && ! _is sudo && _is aws_metadata_available; then
        printf -- "Instance  : %s (%s)\n" "$(_aws_metadata instance-type)" "$(_aws_metadata instance-id)"
        printf -- "Region    : %s (%s)\n" "$(_aws_metadata placement/region)" "$(_aws_metadata placement/availability-zone)"
        sep "Cloud: AWS"
    fi

    _showfeature() {

        local line
        local width=15

        for f in "$@"; do
            local color
            local feature="${f%:*}"
            local state="${f#*:}"

            # state:
            # 0 - exists and is not local
            # 1 - doesn't exist and is not available to install
            # 2 - exists and is local
            # 3 - doesn't exist, but is available to install
            if [ "$state" != "1" ] && [ "$state" != "0" ]; then
                if _has_executable "$state"; then
                    _has_local "$state" && state=2 || state=0
                else
                    _has_potentially "$state" && state=3 || state=1
                fi
            fi

            case "$state" in
                0) color="~g~" ;;
                1) color="~d~" ;;
                2) color="~G~" ;;
                3) color="~b~" ;;
                *) color="~r~" ;;
            esac

            cprintf -A line "~K~[${color} %-${width}s~K~ ]" "$feature"
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

        local prc=$(( 100 - 100 * (total - free) / total ))

        local color
        if [ $prc -gt 19 ]; then
            color="~g~"
        elif [ $prc -gt 9 ]; then
            color="~Y~"
        else
            color="~R~"
        fi

        local bar=$(( prc / 4 ))
        printf -v bar "%${bar}s"
        bar="${bar// /=}"

        if [ "$prc" != '100' ]; then
            printf -v prc '%02d' "$prc"
        fi

        local units="MB"
        if [ "$total" -gt 1022976 ]; then
            total="$(( 100 * total / 1024 / 1024 ))e-2"
            free="$(( 100 * free / 1024 / 1024 ))e-2"
            units="TB"
        elif [ "$total" -gt 999 ]; then
            total="$(( 100 * total / 1024 ))e-2"
            free="$(( 100 * free / 1024 ))e-2"
            units="GB"
        else
            total="$(( 100 * total ))e-2"
            free="$(( 100 * free ))e-2"
        fi

        printf -v total '%.2f %s' "$total" "$units"
        printf -v free '%.2f %s' "$free" "$units"

        local msg

        cprintf -v msg "%-9s : Free ${color}%9s~d~ of %9s ~K~[~b~%-25s~K~] ${color}%3s%%" "$infoType" "$free" "$total" "$bar" "$prc"

        if [ -n "$add" ]; then
            cprintf -A msg '~W~%s' "$add"
        fi

        if [ -n "$add2" ]; then
            cprintf -A msg '~K~%s' "$add2"
        fi

        echo "$msg"

    }

    if ! _is in-container && ! _is sudo; then

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

            MEM_TOTAL=$(( _memTotal / 1024 ))
            MEM_FREE=$(( (_memFree + _buffers + _cached) / 1024 ))
            SWAP_TOTAL=$(( _swapTotal / 1024 ))
            SWAP_FREE=$(( _swapFree / 1024 ))

        elif _has vm_stat; then

            read SWAP_TOTAL SWAP_FREE <<< $(sysctl vm.swapusage | awk '{ print $4 "\n" $10 }')
            SWAP_TOTAL="${SWAP_TOTAL%%.*}"
            SWAP_FREE="${SWAP_FREE%%.*}"

            MEM_TOTAL=$(sysctl hw.memsize | awk '{ print $NF }')
            MEM_TOTAL=$(( MEM_TOTAL / 1024 / 1024 ))

            MEM_FREE=0
            while IFS=$':\r\n' read a b; do
                if [ "$a" = "Pages free" ] || [ "$a" = "Pages inactive" ] || [ "$a" = "Pages speculative" ]; then
                    b="${b// /}"
                    b="${b//./}"
                    MEM_FREE=$(( MEM_FREE + $b ))
                fi
            done < <(vm_stat)
            MEM_FREE=$(( MEM_FREE * 4096 / 1024 / 1024 ))

        fi

        if [ -n "$MEM_TOTAL" ]; then
            _showinfo "RAM" "$MEM_TOTAL" "$MEM_FREE"
            if [ $SWAP_TOTAL -eq 0 ]; then
                cprintf -- "Swap      : ~y~%s" "Not installed"
            else
                _showinfo "Swap" "$SWAP_TOTAL" "$SWAP_FREE"
            fi
            sep "Memory"
        fi

    fi

    if ! _is in-container && ! _is sudo; then
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
                [ "${f:0:6}" = "/snap/" ] && continue
                [ "$f" = "/usr/lib/modules" ]         && continue
                [ "${f:0:17}" = "/usr/lib/modules/" ] && continue

                # hide WSL volumes
                if _is wsl; then
                    [ "$f" = "/init" ]                && continue
                    [ "$f" = "/wslg" ]                && continue
                    [ "$f" = "/wsl" ]                 && continue
                    [ "${f:0:6}" = "/wslg/" ]         && continue
                    [ "${f:0:13}" = "/usr/lib/wsl/" ] && continue
                fi

                if [ "$a" = "${a%:*}" ]; then
                    unset a
                else
                    a="(nfs: $a)"
                fi

                _showinfo "Mount" "$b" "$d" "$f" "$a"

            done < <(df -m -P 2>/dev/null | tail -n +2 | grep -v '^/dev/loop')
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

                b=$(( b / 1024 ))
                d=$(( d / 1024 ))
                _showinfo "Mount" "$b" "$d" "$f"

            done < <(df -k -t | tail -n +2 | grep -v -E ' +0 +0 +0 +0%')
        elif _is hpux; then
            while IFS=$' \t\r\n' read a b c d e f; do

                b=$(( b / 1024 ))
                d=$(( d / 1024 ))
                _showinfo "Mount" "$b" "$d" "$f"

            done < <(df -P -k | tail -n +2)
        elif _is aix; then
            while IFS=$' \t\r\n' read a b c d e f; do

                _showinfo "Mount" "$b" "$d" "$f"

            done < <(df -m -P | tail -n +2 | grep -v -E ' +- +- +0 +-')
        elif _is windows; then
            while IFS=$' ,\t\r\n' read a b c d; do

                [ -z "$c" ] && continue

                b=$(( b / 1024 / 1024 ))
                c=$(( c / 1024 / 1024 ))

                _showinfo "Mount" "$c" "$b" "$a"

            done < <(wmic logicaldisk get Caption,FreeSpace,Size | tail -n +2)
        fi
        unset a b c d e f g h i
        sep "Filesystem"
    fi

    # long parameters such as '--user' and '--name' are not supported on some platforms
    printf -- "Username  : %s\n" "$(id --user --name 2>/dev/null || id -u -n)"
    printf -- "Shell     : %s\n" "$MSHELL"
    sep "User"

    local DOCKER_COMPOSE_V2=1
    # The first version to detect if docker compose v2 was available was to use
    # the 'docker compose version' command. But it turned out that getting
    # the docker compose plugin version could be a long call, which caused
    # delays in shell bootstrap. So now we are simply checking the existence
    # of file /usr/libexec/docker/cli-plugins/docker-compose
    if _has docker && [ -x "/usr/libexec/docker/cli-plugins/docker-compose" ]; then
        DOCKER_COMPOSE_V2=0
    fi

    _showfeature "AWS CLI:aws" "localstack" "gcloud CLI:gcloud"
    _showfeature "docker" "docker-comp.V1:docker-compose" "docker-comp.V2:$DOCKER_COMPOSE_V2"
    _showfeature "kubectl" "eksctl" "OpenShift CLI:oc"
    _showfeature "vim" "git" "curl" "wget"
    _showfeature "gpg" "tmux"

    if _has sudo; then
        local SUDO_STATUS SUDO_AVAIL=1 SUDO_NOPASS=1
        if SUDO_STATUS="$(printf '' | LC_ALL=C sudo -l -S 2>&1)"; then
            ! _glob_match "* may run *" "$SUDO_STATUS" || SUDO_AVAIL=0
            ! _glob_match "* NOPASSWD: ALL*" "$SUDO_STATUS" || SUDO_NOPASS=0
        fi
        _showfeature \
            "sudo avail:$SUDO_AVAIL" \
            "sudo nopass:$SUDO_NOPASS"
    fi

    sep "Features"

}

_is tmux || hostinfo

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

mkdir -p "$IAM_HOME/tools/bash_completion"

if _has_function _init_completion; then

    if _has kubectl && [ ! -f "$IAM_HOME/tools/bash_completion/kubectl.completion.bash" ]; then
        _info "Generating bash completions for kubectl..."
        kubectl completion bash >"$IAM_HOME/tools/bash_completion/kubectl.completion.bash" 2>/dev/null
    fi

    if _has eksctl && [ ! -f "$IAM_HOME/tools/bash_completion/eksctl.completion.bash" ]; then
        _info "Generating bash completions for eksctl..."
        eksctl completion bash >"$IAM_HOME/tools/bash_completion/eksctl.completion.bash" 2>/dev/null
    fi

    if _has helm && [ ! -f "$IAM_HOME/tools/bash_completion/helm.completion.bash" ]; then
        _info "Generating bash completions for helm..."
        helm completion bash >"$IAM_HOME/tools/bash_completion/helm.completion.bash" 2>/dev/null
    fi

    if _has oc && [ ! -f "$IAM_HOME/tools/bash_completion/oc.completion.bash" ]; then
        _info "Generating bash completions for OpenShift..."
        oc completion bash >"$IAM_HOME/tools/bash_completion/oc.completion.bash" 2>/dev/null
    fi

else
    _warn 'The original bash completion package is not installed on this machine. Some of the completions may not be available.\n'
fi

if _has kpexec && [ ! -f "$IAM_HOME/tools/bash_completion/kpexec.completion.bash" ];  then
    _info "Generating bash completions for kpexec..."
    if kpexec --completion bash >"$IAM_HOME/tools/bash_completion/kpexec.completion.bash" 2>/dev/null; then
        echo '
            if [ $(type -t compopt) = "builtin" ]; then
                complete -o default -F __start_kpexec ,kpexec
            else
                complete -o default -o nospace -F __start_kpexec ,kpexec
            fi
        ' >>"$IAM_HOME/tools/bash_completion/kpexec.completion.bash"
    fi
fi

if [ ! -f "$IAM_HOME/tools/bash_completion/pip.completion.bash" ]; then
    # Remove '\r' here, as Python can be compiled for Windows, and pip in
    # this case creates scripts with CRLF new lines.
    if _has pip3; then
        _info "Generating bash completions for pip3..."
        # pip3 adds completions only for 'pip3' command, but we have 'pip' alias for it.
        # Let's add it, but only if 'pip3 completion --bash' was successful.
        pip3 completion --bash | tr -d '\r' >"$IAM_HOME/tools/bash_completion/pip.completion.bash" 2>/dev/null && \
            echo 'complete -o default -F _pip_completion pip' >>"$IAM_HOME/tools/bash_completion/pip.completion.bash"
    elif _has pip; then
        _info "Generating bash completions for pip..."
        pip completion --bash | tr -d '\r' >"$IAM_HOME/tools/bash_completion/pip.completion.bash" 2>/dev/null
    fi
fi

if _has upkg && [ ! -f "$IAM_HOME/tools/bash_completion/upkg.bash" ] && upkg supported silent; then
    _info "Generating bash completions for upkg..."
    upkg generate bash-completion >"$IAM_HOME/tools/bash_completion/upkg.bash" 2>/dev/null
fi

for i in "$IAM_HOME/tools/bash_completion"/*.bash; do
    source "$i"
done
unset i

if [ -f ~/gcloud/google-cloud-sdk/completion.bash.inc ]; then
    . ~/gcloud/google-cloud-sdk/completion.bash.inc
elif [ -f /usr/lib/google-cloud-sdk/completion.bash.inc ]; then
    . /usr/lib/google-cloud-sdk/completion.bash.inc
fi

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

if ! _is in-container && _is aws_metadata_available; then
    AWS_DEFAULT_REGION="$(_aws_metadata placement/region)" && export AWS_DEFAULT_REGION || unset AWS_DEFAULT_REGION
fi

_unexport SSH_PUB_KEY _GIT_USER_EMAIL _GIT_USER_NAME

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
        # don't use '--directory' parameter here as it is not suppurted by busybox
        local TEMP_DIR="$(mktemp -d)"
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
    _warn 'vi/vim not found\n'
fi
export EDITOR

alias vi=vim
vim() {
    _maybe_local "vim"
    local VIM_SESSION_FILE="$_TERM_SESSION_DIR/vim"
    [ -z "$_TERM_SESSION_DIR" ] || {
        if [ -e "$VIM_SESSION_FILE" ]; then
            set -- $(< "$VIM_SESSION_FILE")
        else
            printf '%q ' "$@" > "$VIM_SESSION_FILE"
        fi
    }
    command vim -u "$IAM_HOME/vimrc" -i "$IAM_HOME/viminfo" "$@"
    [ -z "$_TERM_SESSION_DIR" ] || rm -f "$VIM_SESSION_FILE"
}

mkdir -p "$IAM_HOME/vim_swap"
mkdir -p "$IAM_HOME/vim_runtime"

_has apt-get && apt-get() {
    if [ "$(id -u)" -ne 0 ]; then
        cprintf "~r~The 'sudo' prefix was added automatically for the 'apt-get' comman" >&2
        sudo apt-get "$@"
    else
        command apt-get "$@"
    fi
}

_has apt && apt() {
    if [ "$(id -u)" -ne 0 ]; then
        case "$1" in
            install|remove|purge|autoremove|update|upgrade|full-upgrade|edit-sources)
                cprintf "~r~The 'sudo' prefix was added automatically for the 'apt' command" >&2
                sudo apt "$@"
            ;;
            *) command apt "$@"
            ;;
        esac
    else
        command apt "$@"
    fi
}

clear() {
    # Due to unknown reason, clear command doesn't know how to clear scollback
    # buffer when TERM=tmux-256color. Let's use 'TERM=tmux' as a workaround in
    # this case. This will allow to clear tmux's scrollback buffer by this
    # command.
    [ "$TERM" != "tmux-256color" ] || set -- -T tmux "$@"
    command clear "$@"
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

,myip() { _get_url "https://checkip.amazonaws.com"; }

,hostname() {
    local FN="$IAM_HOME/hostname"
    [ -z "$1" ] || { [ "$1" = "-" ] && rm -f "$FN" || echo "$1" > "$FN"; }
    [ -f "$FN" ] && echo "Set hostname: $(cat "$FN")" || echo "Hostname is not set"
}

,retry() {
    local R
    while true; do
        "$@" && R=0 || R=$?
        echo "Exit code: $R; Retry in 5 seconds ..."
        sleep 5
    done
}

_comp_,retry() {
    # Here we first try to use _comp_command_offset if it exists. This is a new
    # function that is intended to replace _command_offset. However, it only
    # exists in bash-completion v2.12. Also, the _command_offset function
    # is marked as deprecated in this version of the package.
    if _has_function _comp_command_offset; then
        _comp_command_offset 1
    elif _has_function _command_offset; then
        # The _command_offset function expects a list of words in the 'words'
        # variable. This we initialize this variable in local scope.
        local cur prev words cword split
        _init_completion -s || return
        _command_offset 1
    fi
}

complete -F _comp_,retry ,retry

#magic

__magic_ssh() {
    # disable messages during -x
    {
        printf '%s\n' \
            "IAM=\"$IAM\" && export IAM" \
            "[ -n \"\$HOME\" ] || { HOME=\"/tmp\"; export HOME; }" \
            "IAM_HOME=\"\$HOME/.${IAM}_home\" && export IAM_HOME" \
            "SSH_PUB_KEY=\"$SSH_PUB_KEY\" && export SSH_PUB_KEY" \
            "_GIT_USER_NAME=\"$_GIT_USER_NAME\" && export _GIT_USER_NAME" \
            "_GIT_USER_EMAIL=\"$_GIT_USER_EMAIL\" && export _GIT_USER_EMAIL" \
            "[ -d \"\$IAM_HOME/terminfo\" ] || mkdir -p \"\$IAM_HOME/terminfo\"" \
            "cat >\"\$IAM_HOME/terminfo/.terminfo\" <<'EOF'" "$(cat "$IAM_HOME/terminfo/.terminfo")" "EOF" \
            "if [ \"\$TERM\" = 'xterm' ]; then TERM='xterm-256color'; export TERM; fi" \
            "if [ \"\$TERM\" = 'xterm-256color' -o \"\$TERM\" = 'tmux-256color' ] && command -v tic >/dev/null 2>&1; then" \
            "TERMINFO=\"\$IAM_HOME/terminfo\"" \
            "export TERMINFO" \
            "tic \"\$IAM_HOME/terminfo/.terminfo\" >/dev/null 2>&1 || true" \
            "fi" \
            "cat >\"\$IAM_HOME/vimrc\" <<'EOF'" "$(cat "$IAM_HOME/vimrc")" "EOF" \
            "cat >\"\$IAM_HOME/bashrc\" <<'EOF'" "$(cat "$IAM_HOME/bashrc")" "EOF" \
            "cat >\"\$IAM_HOME/shellrc\" <<'EOF'" "$(cat "$IAM_HOME/shellrc")" "EOF" \
            "cat >\"\$IAM_HOME/local_tools\" <<'EOF'" "$(cat "$IAM_HOME/local_tools" 2>/dev/null || :)" "EOF" \
            "cat >\"\$HOME/.tclshrc\" <<'EOF'" "$(cat "$HOME/.tclshrc")" "EOF" \
            "chmod +x \"\$IAM_HOME/shellrc\"" \
            "exec \"\$IAM_HOME/shellrc\""
    } 2>/dev/null
}

reload() {
    if _is tmux && [ "$1" != "current" ]; then
        local current_wid wid cmd
        current_wid="$(command tmux display-message -p -t $TMUX_PANE '#{window_id}')"
        for wid in $(command tmux list-windows -F '#{window_id}'); do
            [ "$wid" != "$current_wid" ] || continue
            cmd="$(command tmux display-message -p -t "$wid" '#{pane_current_command}')"
            if [ "$cmd" != "bash" ]; then
                echo "Error: can't reload window '$(command tmux display-message -p -t "$wid" '#{window_index}:#{window_name}')' as its command '$cmd' is not 'bash'."
                return 1
            fi
        done
        "$IAM_HOME/tools/bin/tmux-helper" reset-options-to-default >/dev/null 2>&1 || true
        command tmux source-file "$IAM_HOME/tmux.conf"
        for wid in $(command tmux list-windows -F '#{window_id}'); do
            [ "$wid" != "$current_wid" ] || continue
            command tmux send-keys -t $wid 'reload current' C-m
        done
    fi
    # Reloaded shell should be with the same _SHELL_SESSION_ID.
    # It will be removed from exports by launched shell instance.
    export _SHELL_SESSION_ID _TERM_SESSION_ID _TMUX_SESSION_ID
    export SSH_PUB_KEY _GIT_USER_EMAIL _GIT_USER_NAME
    exec bash --rcfile "$IAM_HOME/bashrc" -i
}
,ssh() {
    local ARG
    for ARG in "$@"; do :; done
    _glob_match "*@*" "$ARG" || _warn "the remote user is not provided. Current user '%s' will be used on the remove machine." "$USER"
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
    $sudo_cmd -H bash -ci "$(__magic_ssh)"
}
_hasnot_potentially kpexec || ,kpexec() {
    _maybe_local "kpexec"
    # kpexec uses 'kubectl attach' to attach to the spawned pod&container.
    # Due to an unknown bug in the k8s that is out there at this point in time,
    # it may randomly hang. The command 'sleep ...' command somehow gets around
    # this error. And the longer the delay, the less likely the error will be
    # reproduced. One second is not enough, the error stops reproducing at 3x
    # or more seconds.
    command kpexec -ti -T "$@" -- bash -ci "sleep 3; $(__magic_ssh)"

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
              if [ ! -d \"\$IAM_HOME/terminfo\" ]; then mkdir \"\$IAM_HOME/terminfo\"; fi && \
              echo \"$(cat ${IAM_HOME}/terminfo/.terminfo | sed 's/\([$"\`\\]\)/\\\1/g')\">\"\$IAM_HOME/terminfo/.terminfo\" &&
              TERMINFO=\"\$IAM_HOME/terminfo\" && \
              export TERMINFO && \
              tic \"\$IAM_HOME/terminfo/.terminfo\" && \
              echo \"$(cat ${IAM_HOME}/vimrc | sed 's/\([$"\`\\]\)/\\\1/g')\">\"\$IAM_HOME/vimrc\" && \
              echo \"$(cat ${IAM_HOME}/local_tools | sed 's/\([$"\`\\]\)/\\\1/g')\">\"\$IAM_HOME/local_tools\" && \
              echo \"$(cat ${HOME}/.tclshrc | sed 's/\([$"\`\\]\)/\\\1/g')\">\"\$HOME/.tclshrc\" && \
              echo \"$(cat ${IAM_HOME}/bashrc | sed 's/\([$"\`\\]\)/\\\1/g')\">\"\$IAM_HOME/bashrc\"" \
        | wsl -d Ubuntu

        wsl -d Ubuntu /bin/bash -ci "IAM=\"$IAM\" && export IAM && \
              SSH_PUB_KEY=\"$SSH_PUB_KEY\" && export SSH_PUB_KEY && \
              IAM_HOME=\"\$HOME/.${IAM}_home\" && export IAM_HOME && \
              _GIT_USER_NAME=\"$_GIT_USER_NAME\" && export _GIT_USER_NAME && \
              _GIT_USER_EMAIL=\"$_GIT_USER_EMAIL\" && export _GIT_USER_EMAIL && \
              if [ ! -d \"\\\$IAM_HOME/terminfo\" ]; then mkdir \"\\\$IAM_HOME/terminfo\"; fi && \
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

_hasnot moar || export PAGER="moar -quit-if-one-screen"
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
# Ignore standard commands
HISTIGNORE="&:[bf]g:exit:history:history *:reset:clear"
# Ignore our custom commands. They are useless for history.
# reload - is my function to reload current shell
HISTIGNORE="$HISTIGNORE:reload:reload current:mkcdtmp"

if _is in-container; then
    # In Docker, we don't want to do anything complicated with the shell command history.
    HISTFILE="$IAM_HOME/bash_history"
else
    HISTFILE_GLOBAL="$IAM_HOME/bash_history"
    HISTFILE="$_SHELL_SESSION_DIR/bash_history"

    # Read global history file
    history -cr "$HISTFILE_GLOBAL"

    # Session history file will be read automatically
fi

_homify() {
    local __HOMIFY_VAR __HOMIFY_DIR __HOMIFY_WIDTH=20 __HOMIFY_TRUNC='...'
    [ "$1" != "-v" ] || { __HOMIFY_VAR="$2"; shift 2; }
    # Trim path to 1/4 the screen width if COLUMNS variable exists
    [ -z "$COLUMNS" ] || __HOMIFY_WIDTH=$(( COLUMNS / 4 ))
    [ -n "$1" ] && __HOMIFY_DIR="$1" || __HOMIFY_DIR="$PWD"
    if [ "$__HOMIFY_DIR" = "$HOME" ] || _glob_match "$HOME/*" "$__HOMIFY_DIR"; then
        __HOMIFY_DIR="~${__HOMIFY_DIR#$HOME}"
    fi
    if [ ${#__HOMIFY_DIR} -gt $__HOMIFY_WIDTH ]; then
        __HOMIFY_DIR="$__HOMIFY_TRUNC${__HOMIFY_DIR:$(( ${#__HOMIFY_DIR} - __HOMIFY_WIDTH + ${#__HOMIFY_TRUNC} ))}"
    fi
    [ -n "$__HOMIFY_VAR" ] && printf -v "$__HOMIFY_VAR" '%s' "$__HOMIFY_DIR" || echo "$__HOMIFY_DIR"
}

__kubectl_status() {

    if ! _has kubectl || [ ! -e "$IAM_HOME/state/on_kube" ]; then
        return 0
    fi

    local CONFIG CONFIG_MSG MSG STDERR

    if [ -z "$KUBECONFIG" ]; then
        CONFIG="$HOME/.kube/config"
    else
        CONFIG="$KUBECONFIG"
    fi
    _homify -v CONFIG_MSG "$CONFIG"

    cprintf -v MSG '~K~[~W~K8S~K~: ~c~%s' "$CONFIG_MSG"

    if [ ! -e "$CONFIG" ]; then
        cprintf -A MSG "- ~r~DOESN'T EXIST"
    else

        cprintf -a MSG '~K~; ~d~cluster~K~:'

        local CONTEXT
        if ! _catch CONTEXT STDERR \
            command kubectl config view --minify \
                -o=jsonpath="{.contexts[0].name}|{.contexts[0].context.namespace}"
        then
            # convert from:
            #   error: current-context is not set
            # to:
            #   current-context is not set
            STDERR="${STDERR#* }"
            cprintf -A MSG '~R~%s' "$STDERR"
        elif [ -n "$STDERR" ]; then
            cprintf -A MSG '~R~%s' "$STDERR"
        else
            local NAMESPACE="${CONTEXT#*|}"
            CONTEXT="${CONTEXT%|*}"
            [ -n "$NAMESPACE" ] || NAMESPACE="default"

            cprintf -A MSG '~m~%s~K~; ~d~namespace~K~: ~B~%s' "$CONTEXT" "$NAMESPACE"
        fi

    fi

    cprintf -a MSG '~K~]'

    _ps1_show_status "$MSG"

}

__aws_status() {

    # Don't show AWS status if AWS CLI is not installed
    _has aws || return 0

    # Try to detect if current environment is AWS EC2 environment with bound role
    if [ -z "$__AWS_INSTANCE_HAS_ROLE" ]; then
        local USERID
        # Here we use '_is aws' that depends on curl. This means that we will not
        # be able to detect an instance with a role if curl doesn't exist.
        # UserId for EC2 instance with a role is expected as something like: AROAWQUOZYGS15BHRR5OU:i-07cd2351dacb99d17
        _is aws \
            && USERID="$(aws sts get-caller-identity --query 'UserId' --output text 2>&1)" \
            && _glob_match "*:i-*" "$USERID" \
            && __AWS_INSTANCE_HAS_ROLE=1 \
            || __AWS_INSTANCE_HAS_ROLE=0
    fi

    # If we are in AWS instance with a role, then we always show AWS status.
    # If AWS-related environment variables exist, then we always show AWS status.
    # If they doesn't exist, then AWS status is controlled by the flag.
    [ "$__AWS_INSTANCE_HAS_ROLE" -eq 0 ] \
        && [ -z "$AWS_ACCESS_KEY_ID$AWS_SECRET_ACCESS_KEY$AWS_SESSION_TOKEN$AWS_PROFILE" ] \
        && [ ! -e "$IAM_HOME/state/on_aws" ] \
        && return 0 \
        || true

    # If we have AWS_PROFILE and other AWS variables, then mark the profile as inactive
    if [ -n "$AWS_ACCESS_KEY_ID$AWS_SECRET_ACCESS_KEY$AWS_SESSION_TOKEN" ] && [ -n "$AWS_PROFILE" ]; then
        AWS_PROFILE_INACTIVE="$AWS_PROFILE"
        unset AWS_PROFILE
    fi

    local MSG

    cprintf -v MSG '~K~[~W~AWS~K~:'

    if [ -e "$IAM_HOME/state/on_aws_localstack" ]; then

        cprintf -A MSG 'localstack~K~:'

        if ! _has curl; then
            cprintf -A MSG "~y~unknown (curl doesn't exist)"
        elif curl --silent --fail -o /dev/null http://localhost:4566; then
            cprintf -A MSG "~g~running"
        else
            cprintf -A MSG "~r~not running"
        fi

        cprintf -a MSG '~K~]'
        _ps1_show_status "$MSG"
        return 0

    fi

    if [ -n "$AWS_PROFILE" ]; then
        cprintf -A MSG 'profile~K~: ~m~%s' "$AWS_PROFILE"
    elif [ -z "$AWS_ACCESS_KEY_ID$AWS_SECRET_ACCESS_KEY$AWS_SESSION_TOKEN" ] && [ "$__AWS_INSTANCE_HAS_ROLE" -eq 1 ]; then
        # If we do not have AWS credentials in the environment variables, but
        # the current instance has an attached profile/role, then show only this
        # to avoid unnecessary information.
        cprintf -A MSG 'instance-profile~K~: ~g~Y'
    else

        local KEY SECRET SESSION

        [ -z "$AWS_ACCESS_KEY_ID" ]     && KEY="~r~N"     || KEY="~g~Y"
        [ -z "$AWS_SECRET_ACCESS_KEY" ] && SECRET="~r~N"  || SECRET="~g~Y"
        [ -z "$AWS_SESSION_TOKEN" ]     && SESSION="~r~N" || SESSION="~g~Y"

        cprintf -A MSG "key~K~: $KEY~K~; ~d~secret~K~: $SECRET~K~; ~d~session~K~: $SESSION"

        [ -z "$AWS_PROFILE_INACTIVE" ] \
            || cprintf -a MSG '~K~; ~y~inactive-profile~K~: ~g~%s' "$AWS_PROFILE_INACTIVE"

    fi

    cprintf -a MSG '~K~; ~d~region~K~:'

    local REGION
    if [ -n "$AWS_PROFILE" ] && [ -z "$AWS_DEFAULT_REGION" ]; then
        REGION="$(command aws configure list 2>/dev/null | awk '$1 == "region" { print $2 }')"
        [ "$REGION" != "<not" ] || unset REGION
    fi

    if [ -z "$REGION" ] && [ -n "$AWS_DEFAULT_REGION" ]; then
        REGION="$AWS_DEFAULT_REGION"
    fi

    [ -n "$REGION" ] \
        && cprintf -A MSG '~c~%s' "$REGION" \
        || cprintf -A MSG '~r~%s' "N"

    cprintf -a MSG '~K~; ~d~indentity~K~:'
    local INDENTITY
    if ! INDENTITY="$(aws sts get-caller-identity --query 'Arn' --output text 2>&1)"; then
        # Strip possible new lines from the error message
        INDENTITY="${INDENTITY//$'\n'/}"
        # convert from:
        #   An error occurred (InvalidClientTokenId) when calling the GetCallerIdentity operation: The security token included in the request is invalid.
        # to
        #   The security token included in the request is invalid.
        INDENTITY="${INDENTITY#*:}"
        # Trim possible leading/tralling spaces
        _trim -v INDENTITY -- "$INDENTITY"
        cprintf -A MSG '~R~%s' "$INDENTITY"
    else
        cprintf -A MSG '~g~%s' "$INDENTITY"
    fi

    cprintf -a MSG '~K~]'

    _ps1_show_status "$MSG"

}

# based on: https://github.com/magicmonty/bash-git-prompt
__git_status() {

    _has git || return 0

    local GIT_STATUS
    # Check if current directory is a git repository
    if _check _vercomp 1.8.0 '<' "$__GIT_VERSION"; then
        GIT_STATUS="$(LC_ALL=C command git status --porcelain 2>/dev/null)" || return 0
    else
        GIT_STATUS="$(LC_ALL=C command git status --porcelain --branch 2>/dev/null)" || return 0
    fi

    # run only once per session
    _check _git-config-check

    # check configuration only once per session
    if _once "git check core.autocrlf in $PWD"; then
        if [ "$(LC_ALL=C command git config --get core.autocrlf)" != "false" ]; then
            command git config core.autocrlf false
        fi
    fi

    local MSG TMP_VAL

    local GIT_REPO_ROOT="$(command git rev-parse --git-dir 2>/dev/null)"

    if [ "$GIT_REPO_ROOT" = ".git" ]; then
        GIT_REPO_ROOT="$PWD"
    else
        _dirname -v GIT_REPO_ROOT -- "$GIT_REPO_ROOT"
    fi

    local GIT_BRANCH="!ERROR!" GIT_NUM_STAGED=0 GIT_NUM_CHANGED=0 GIT_NUM_CONFLICT=0 GIT_NUM_UNTRACKED=0

    local line status
    while IFS='' read -r line || [ -n "$line" ]; do
        status="${line:0:2}"
        while [ -n "$status" ]; do
            case "$status" in
                \#\#) GIT_BRANCH="${line/\.\.\./^}"; break ;;
                \?\?) ((GIT_NUM_UNTRACKED++)); break ;;
                U?) ((GIT_NUM_CONFLICT++)); break;;
                ?U) ((GIT_NUM_CONFLICT++)); break;;
                DD) ((GIT_NUM_CONFLICT++)); break;;
                AA) ((GIT_NUM_CONFLICT++)); break;;
                ?M) ((GIT_NUM_CHANGED++)) ;;
                ?D) ((GIT_NUM_CHANGED++)) ;;
                ?\ ) ;;
                U) ((GIT_NUM_CONFLICT++)) ;;
                \ ) ;;
                *) ((GIT_NUM_STAGED++)) ;;
            esac
            status=${status:0:(${#status}-1)}
        done
    done <<< "$GIT_STATUS"

    if [ "$GIT_BRANCH" = "!ERROR!" ]; then
        if TMP_VAL="$(command git rev-parse --abbrev-ref HEAD 2>/dev/null)"; then
            GIT_BRANCH="$TMP_VAL"
        fi
    fi

    local GIT_BRANCH_FIELDS
    IFS="^" read -ra GIT_BRANCH_FIELDS <<< "${GIT_BRANCH/\#\# }"
    GIT_BRANCH="${GIT_BRANCH_FIELDS[0]}"

    _homify -v GIT_REPO_ROOT "$GIT_REPO_ROOT"
    cprintf -v MSG '~K~[~W~GIT~K~: ~c~%s' "$GIT_REPO_ROOT"

    local IS_IN_SUBMODULE
    # try to detect if we are inside submodule. This command may fail
    # on old git version.
    if TMP_VAL="$(command git rev-parse --show-superproject-working-tree 2>/dev/null)"; then
        # the command didn't fail
        [ -z "$TMP_VAL" ] || IS_IN_SUBMODULE=1
    else
        # try another method
        [ "${GIT_REPO_ROOT%*/.git/modules}" == "$GIT_REPO_ROOT" ] || IS_IN_SUBMODULE=1
    fi

    [ -z "$IS_IN_SUBMODULE" ] \
        || cprintf -A MSG '~K~(~d~submodule~K~)'

    cprintf -a MSG '~K~; ~d~branch~K~: ~m~%s' "$GIT_BRANCH"

    if [ "$GIT_BRANCH" != "HEAD" ]; then
        if ! command git show-ref --verify "refs/remotes/origin/$GIT_BRANCH" >/dev/null 2>&1; then
            cprintf -A MSG '~K~(~y~local only~K~)'
        elif ! TMP_VAL="$(command git rev-list --count "${GIT_BRANCH}..origin/${GIT_BRANCH}" 2>&1)"; then
            cprintf -A MSG '~K~(~R~ERROR~K~: ~d~%s~K~)' "$TMP_VAL"
        elif [ "$TMP_VAL" != "0" ]; then
            cprintf -A MSG '~K~(~r~needs push force~K~)'
        elif ! TMP_VAL="$(command git rev-list --count "origin/${GIT_BRANCH}..${GIT_BRANCH}" 2>&1)"; then
            cprintf -A MSG '~K~(~R~ERROR~K~: ~d~%s~K~)' "$TMP_VAL"
        elif [ "$TMP_VAL" = "1" ]; then
            cprintf -A MSG '~K~(~y~%s commit ahead remote~K~)' "$TMP_VAL"
        elif [ "$TMP_VAL" != "0" ]; then
            cprintf -A MSG '~K~(~y~%s commits ahead remote~K~)' "$TMP_VAL"
        fi
    fi

    local GIT_TAG
    if GIT_TAG="$(command git describe --exact-match --tags $(command git rev-parse HEAD) 2>/dev/null)"; then
        cprintf -a MSG '~K~; ~d~tag~K~: ~m~%s' "$GIT_TAG"
    fi

    [ "$GIT_NUM_CONFLICT" -eq 0 ] \
        || cprintf -a MSG '~K~; ~R~conflict~K~: ~d~%i' "$GIT_NUM_CONFLICT"

    [ "$GIT_NUM_STAGED" -eq 0 ] \
        || cprintf -a MSG '~K~; ~g~staged~K~: ~d~%i' "$GIT_NUM_STAGED"

    [ "$GIT_NUM_CHANGED" -eq 0 ] \
        || cprintf -a MSG '~K~; ~y~changed~K~: ~d~%i' "$GIT_NUM_CHANGED"

    [ "$GIT_NUM_UNTRACKED" -eq 0 ] \
        || cprintf -a MSG '~K~; ~d~untracked~K~: ~R~%i' "$GIT_NUM_UNTRACKED"

    cprintf -a MSG '~K~]'

    # other options

    cprintf -A MSG '~K~[~d~sign~K~:'

    local GIT_SIGN
    if TMP_VAL="$(command git config --local --get commit.gpgsign 2>/dev/null)"; then
        if [ "$TMP_VAL" = "true" ]; then
            cprintf -a MSG '~g~true'
            GIT_SIGN=1
        else
            cprintf -a MSG '~r~%s' "$TMP_VAL"
        fi
    elif ! TMP_VAL="$(command git config --get commit.gpgsign 2>/dev/null)"; then
        cprintf -a MSG '~R~undef'
    elif [ "$TMP_VAL" = "true" ]; then
        cprintf -a MSG '~g~true~K~(~d~G~K~)'
        GIT_SIGN=1
    else
        cprintf -a MSG '~r~%s~K~(~d~G~K~)' "$TMP_VAL"
    fi

    local GIT_AUTHOR_EMAIL

    # don't check for author in submodules
    if [ -z "$IS_IN_SUBMODULE" ]; then

        cprintf -a MSG '~K~; ~d~author~K~:'

        if TMP_VAL="$(LC_ALL=C command git config --local --get user.email 2>/dev/null)"; then
            GIT_AUTHOR_EMAIL="$TMP_VAL"
            if [ "$GIT_AUTHOR_EMAIL" = "$_GIT_USER_EMAIL" ]; then
                cprintf -a MSG '~g~ON'
            else
                cprintf -a MSG '~y~%s' "$GIT_AUTHOR_EMAIL"
            fi
        elif ! TMP_VAL="$(LC_ALL=C command git config --get user.email 2>/dev/null)"; then
            cprintf -a MSG '~R~undef'
        else
            GIT_AUTHOR_EMAIL="$TMP_VAL"
            if [ "$GIT_AUTHOR_EMAIL" = "$_GIT_USER_EMAIL" ]; then
                cprintf -a MSG '~g~ON'
            else
                cprintf -a MSG '~y~%s' "$GIT_AUTHOR_EMAIL"
            fi
            cprintf -a MSG '~K~(~d~G~K~)'
        fi

    fi

    local GIT_SIGN_KEY

    if [ -n "$GIT_SIGN" ] && [ -n "$GIT_AUTHOR_EMAIL" ]; then

        cprintf -a MSG '~K~; ~d~gpg~K~:'

        if ! _has gpg; then
            cprintf -a MSG '~R~unavailable'
        else
            if TMP_VAL="$(LC_ALL=C command git config --local --get user.signingkey 2>/dev/null)"; then
                GIT_SIGN_KEY="$TMP_VAL"
            elif TMP_VAL="$(LC_ALL=C command git config --get user.signingkey 2>/dev/null)"; then
                GIT_SIGN_KEY="$TMP_VAL"
            fi

            if [ -z "$GIT_SIGN_KEY" ]; then
                cprintf -a MSG '~R~not set'
            elif ! TMP_VAL="$(LC_ALL=C command gpg --list-secret-keys "$GIT_SIGN_KEY" 2>/dev/null)"; then
                cprintf -a MSG "~r~no key '%s'" "$GIT_SIGN_KEY"
            else
                if ! TMP_VAL="$(LC_ALL=C command gpg --with-colons --list-secret-keys "$GIT_AUTHOR_EMAIL" 2>/dev/null | cut -d: -f5 | head -n 1)"; then
                    cprintf -a MSG "~r~wrong key, no key for '%s'" "$GIT_AUTHOR_EMAIL"
                elif [ "$TMP_VAL" != "$GIT_SIGN_KEY" ]; then
                    cprintf -a MSG "~r~wrong key, set: %s; expected: '%s'" "$GIT_SIGN_KEY" "$TMP_VAL"
                else
                    cprintf -a MSG "~g~ON"
                fi
            fi
        fi

    fi

    cprintf -a MSG "~K~]"

    _ps1_show_status "$MSG"

}

_ps1_show_status() {
    if _isnot tmux; then
        echo "$1"
        return
    fi
    [ -n "$_PS1_TMUX_CURRENT_WINDOW" ] || _PS1_TMUX_CURRENT_WINDOW="$(command tmux display-message -p -t "$TMUX_PANE" '#{window_id}')"
    if [ -z "$_PS1_TMUX_CURRENT_STATUS" ]; then
        # we may have a status pane and lost its ID after reload.
        # #{pane_dead} doesn't work in tmux 3.0a. Status pane is not marked as dead.
        # However, #{pane_pid} works everywhere. Empty pane has 0 pane_pid.
        _PS1_TMUX_CURRENT_STATUS="$(command tmux list-panes -t "$_PS1_TMUX_CURRENT_WINDOW" -F '#{pane_pid} #{pane_id}' | grep '^0 ' | awk '{print $2}' | tail -n 1)"
        # no panes, create one
        [ -n "$_PS1_TMUX_CURRENT_STATUS" ] || _PS1_TMUX_CURRENT_STATUS="$(command tmux split-window -d -l 1 -v -t "$TMUX_PANE" -P -F '#{pane_id}' '')"
        #command tmux select-pane -t "$_PS1_TMUX_CURRENT_STATUS" -P 'bg=colour236'
        #command tmux select-pane -t "$TMUX_PANE"
        # defaults are:
        # pane-border-style bg=colour235,fg=colour238
        # pane-active-border-style bg=colour236,fg=colour51
        command tmux set -p -t "$TMUX_PANE" pane-border-style 'bg=default,fg=colour238'
        command tmux set -p -t "$TMUX_PANE" pane-active-border-style 'bg=default,fg=colour238'
        command tmux set -p -t "$_PS1_TMUX_CURRENT_STATUS" pane-border-style 'bg=default,fg=colour238'
        command tmux set -p -t "$_PS1_TMUX_CURRENT_STATUS" pane-active-border-style 'bg=default,fg=colour238'
    fi
    [ -z "${_PS1_STATUS_LINE}" ] && _PS1_STATUS_LINE=1 || _PS1_STATUS_LINE=$(( _PS1_STATUS_LINE + 1 ))
    command tmux resize-pane -y "$_PS1_STATUS_LINE" -t "$_PS1_TMUX_CURRENT_STATUS"
    # "\033[?7l" / "\033[?7h" - disables/enables word wrap in tmux
    # https://github.com/tmux/tmux/issues/969#issuecomment-307659989
    printf "\n\033[?7l%s\033[?7h" "$1" | command tmux display-message -t "$_PS1_TMUX_CURRENT_STATUS" -I
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
    [ ${CURPOS##*;} -eq 1 ] || cprintf '~Wr~%%'

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
       local SIG
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
       [ -z "$SIG" ] || SIG=" ~K~[~y~${SIG}~K~]"
       cprintf "~r~Exit code~K~: ~R~%i$SIG" "$exitcode"
    fi

    if [ ! -d "$PWD" ]; then
        _warn "Warning: Current directory doesn't exist"
    elif _check stat -c '%i' . && [ ! -L "$PWD" ] && [ "$(stat -c '%i' . 2>&1)" != "$(stat -c '%i' "$PWD")" ]; then
        # if inside of zombie directory
        cprintf '~y~Current directory is a zombie. Fixing it.'
        cd ../"${PWD##*/}"
    fi

    if [ -n "$_TERM_SESSION_DIR" ]; then
        echo "$PWD" > "$_TERM_SESSION_DIR/pwd"
    fi

    #if [ -n "$__KITTY_ID" ]; then
    #    [ -d "$IAM_HOME/kitty_sessions/$__KITTY_ID" ] || mkdir -p "$IAM_HOME/kitty_sessions/$__KITTY_ID"
    #    if _is tmux; then
    #        echo "$TMUX" > "$IAM_HOME/kitty_sessions/$__KITTY_ID/tmux"
    #    else
    #        echo "$PWD" > "$IAM_HOME/kitty_sessions/$__KITTY_ID/pwd"
    #    fi
    #    if [ ! -e "$IAM_HOME/kitty_sessions/$__KITTY_ID/shell_session_id" ] && [ -n "$_SHELL_SESSION_ID" ]; then
    #        echo "$_SHELL_SESSION_ID" > "$IAM_HOME/kitty_sessions/$__KITTY_ID/shell_session_id"
    #    fi
    #fi

    echo "$PWD" > "$IAM_HOME/jumplist_last_pwd"

    # update history file
    if [ -z "$HISTFILE_GLOBAL" ]; then
        history -a
    else
        # Update both global and session history files
        history -a /dev/stdout | tee -a "$HISTFILE_GLOBAL" >> "$HISTFILE"
    fi

    local SCRIPT
    for SCRIPT in "$IAM_HOME"/shell.rc/*; do
        [ -e "$SCRIPT" ] || continue
        ! _once "PS1 -> source $SCRIPT" && [ "$_SHELL_SESSION_STAMP" -nt "$SCRIPT" ] || source "$SCRIPT"
    done

    unset _PS1_STATUS_LINE

    if [ -z "$VIRTUAL_ENV" ]; then
        # If venv is inactive and we have a venv in PWD, then activate it
        if [ -f "$PWD/.venv/bin/activate" ]; then
            # At the moment, we are silently ignoring possible errors during
            # activation.
            source "$PWD/.venv/bin/activate" || true
        elif _is windows && [ -f "$PWD/.venv/Scripts/activate" ]; then
            source "$PWD/.venv/Scripts/activate" || true
        fi
    else
        # If venv is active, we want to deactivate it if we have exited its
        # directory tree or venv directory no longer exists.
        unset __VENV_DEACTIVATE
        if [ ! -d "$VIRTUAL_ENV" ]; then
            # Deactivate the venv if directory no longer exists
            __VENV_DEACTIVATE=1
        else
            # First we check if venv dir doesn't match PWD.
            __VENV_HOME="${VIRTUAL_ENV%/*}"
            if [ "$__VENV_HOME" != "$PWD" ]; then
                # If venv directory doesn't match PWD, then we check if we are
                # within venv directory tree.
                __VENV_HOME="$__VENV_HOME/"
                if [ "${PWD:0:${#__VENV_HOME}}" != "$__VENV_HOME" ]; then
                    # We are not in venv directory tree. Let's deactivate venv.
                    __VENV_DEACTIVATE=1
                fi
            fi
            unset __VENV_HOME
        fi
        if [ -n "$__VENV_DEACTIVATE" ]; then
            # Deactivate the venv. If deactivation failed for any reason,
            # just reset the variable for venv.
            deactivate || unset VIRTUAL_ENV
            unset __VENV_DEACTIVATE
        fi
    fi

    __aws_status
    __kubectl_status
    __git_status

    if [ -z "$_PS1_STATUS_LINE" ] && [ -n "$_PS1_TMUX_CURRENT_STATUS" ]; then
        command tmux kill-pane -t "$_PS1_TMUX_CURRENT_STATUS"
        command tmux set-hook -u -w -t "$TMUX_PANE" 'pane-exited[879]'
        unset _PS1_TMUX_CURRENT_STATUS
    fi

    if _is tmux && [ -n "$TMUX_PANE" ]; then
        # Forcing the window name to be updated, since we may have changed the working directory.
        # Run it in the background and silently ignore any errors.
        command tmux set-hook -R -t "$TMUX_PANE" window-renamed >/dev/null 2>&1 &
        disown $!
    fi

    local _HOSTNAME='\h'
    [ ! -f "$IAM_HOME/hostname" ] || _HOSTNAME="$(cat "$IAM_HOME/hostname")"

    # Here we initialize PS1. It should be initialized after everything related to
    # python virtual environment, since activating venv changes PS1.
    PS1=""

    # Titlebar
    if _isnot tmux; then
        case ${TERM} in
            xterm*)
                # No username in tab title
                # PS1="${PS1}\[\033]0;\u@\h:\w\007\]"
                PS1="${PS1}\[\033]0;${_HOSTNAME}:\w\007\]"
            ;;
        esac
    fi

    # User
    local USER_COLOR
    if [ "$UID" -eq 0 ] ; then
        if [ "$USER" = "$LOGNAME" ]; then
            [ -n "$SUDO_USER" ] \
                && USER_COLOR="~r~" \
                || USER_COLOR="~R~"
        else
            USER_COLOR="~Y~"
        fi
    else
        [ "$USER" = "$LOGNAME" ] \
            && USER_COLOR="~g~" \
            || USER_COLOR="~y~"
    fi

    cprintf -a PS1 "~K~[${USER_COLOR}%s~K~@~B~%s" '\u' "$_HOSTNAME"

    if _is wsl; then
        # WSL?
        cprintf -a PS1 '~K~[~d~WSL~K~]'
    elif _is in-docker; then
        # Docker?
        cprintf -a PS1 '~K~[~d~docker~K~]'
    elif _is in-container; then
        # Docker?
        cprintf -a PS1 '~K~[~d~container~K~]'
    elif _is aws; then
        # AWS instance?
        cprintf -a PS1 '~K~[~m~AWS~K~]'
    fi

    if [ -n "$VIRTUAL_ENV" ]; then
        # Python venv?
        cprintf -a PS1 '~K~[~y~VENV~K~]'
    fi

    # Working directory
    local PWD_MSG PWD_COLOR
    _homify -v PWD_MSG "$PWD"
    [ -w "$PWD" ] \
        && PWD_COLOR="~g~" \
        || PWD_COLOR="~r~"

    cprintf -a PS1 "~K~:${PWD_COLOR}%s~K~]" "$PWD_MSG"

    # This block is commented out as for now. In bash, it is impossible to get
    # information about whether any background jobs are running or stopped
    # without forking or spawning a subshell. Subshells are very time consuming
    # and slow down each prompt. On the other hand, background jobs are very
    # rarely used. Thus, there is no point in wasting time every time a prompt
    # is displayed because of them.

    # Backgrounded running jobs
    #local BKGJBS=$(jobs -r | wc -l )
    #if [ ${BKGJBS} -gt 2 ]; then
    #    PS1="${PS1}\[${COLOR_RED}\][bg:${BKGJBS}]\[${COLOR_DEFAULT}\]"
    #elif [ ${BKGJBS} -gt 0 ]; then
    #    PS1="${PS1}\[${COLOR_YELLOW}\][bg:${BKGJBS}]\[${COLOR_DEFAULT}\]"
    #fi

    # Stopped Jobs
    #local STPJBS=$(jobs -s | wc -l )
    #if [ ${STPJBS} -gt 2 ]; then
    #    PS1="${PS1}\[${COLOR_RED}\][stp:${STPJBS}]\[${COLOR_DEFAULT}\]"
    #elif [ ${STPJBS} -gt 0 ]; then
    #    PS1="${PS1}\[${COLOR_YELLOW}\][stp:${STPJBS}]\[${COLOR_DEFAULT}\]"
    #fi

    [ "$UID" -eq 0 ] \
        && cprintf -a PS1 '~r~# ~d~' \
        || cprintf -a PS1 '~136~$ ~d~'

    unset PS1_COMMAND

    if _is tmux && [ -n "$__TMUX_FUNCTIONS_AVAILABLE" ]; then
        ,tmux autosave
    fi

    # We use 'echo' instead of 'touch' because 'echo' is a built-in
    # bash command and is much faster.
    echo > "$_SHELL_SESSION_STAMP"

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

__cleanup_trap() {
    local RC=$?
    rm -rf "$_SHELL_SESSION_DIR"
    exit $RC
}

#PROMPT_COMMAND="promptcmd \$?"
#PROMPT_COMMAND="__debug_trap off \$? && __EC=0 || __EC=\$?; promptcmd \$__EC; unset __EC; __debug_trap on"
PROMPT_COMMAND="{ __debug_trap off \$? && __EC=0 || __EC=\$?; promptcmd \$__EC; unset __EC; __debug_trap on; } 2>/dev/null"

#trap __debug_trap DEBUG
trap '{ __debug_trap; } 2>/dev/null' DEBUG
trap '__cleanup_trap' EXIT

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
            if [ "${__var/ /}" != "$__var" ]; then
                echo "Warning! Space in environment variable name '${__var}'"
                continue
            fi
            [ -z "${!__var}" ] || continue
            # Skip TEMP/TMP variables. We don't want to use Windows temp locations in cygwin.
            if [ "$__var" = "TEMP" ] || [ "$__var" = "TMP" ]; then
                continue
            fi
            IFS= read -d $'\0' -r __val < "$fn"
            __val="${__val/\%SystemRoot\%/$SYSTEMROOT}"
            __val="${__val/\%ProgramFiles\%/$PROGRAMFILES}"
            __val="${__val/\%USERPROFILE\%/$USERPROFILE}"
            __val="${__val/\%ProgramFiles(x86)\%/$PROGRAMFILESX86}"
            __val="${__val/\%HomeDrive\%\%HomePath\%/$USERPROFILE}"
            echo "Added environment variable: $__var"
            if [ "${__val/\%/}" != "$__val" ]; then
                echo "Warning! Percent in environment variable '${__var}': '${__val}'"
            fi
            export $__var="$__val" >/dev/null 2>&1
        done
        unset fn __var __val
    fi
fi

# Add native Windows utilities to WSL. Don't run inside tmux to speed up reloads.
if _isnot tmux; then
    unset WARN
    if _is wsl; then
        for fn in gsudo gsudo.exe; do
            REAL_CMD="$(command -v "$fn" 2>/dev/null)"
            if [ -n "$REAL_CMD" ] && [ ! -x "$REAL_CMD" ]; then
            if ! chmod +x "$REAL_CMD" >/dev/null 2>&1; then
                [ -n "$WARN" ] || echo
                _warn "could not chmod +x '%s': Permission denied. Run it using gsudo or run WSL under elevated powershell." "$REAL_CMD"
                WARN=1
            fi
            fi
        done
        for fn in vagrant VBoxManage net sc notepad explorer reg; do
            REAL_CMD="$(command -v "${fn}.exe" 2>/dev/null)"
            if [ -n "$REAL_CMD" ]; then
                ln -sf "$REAL_CMD" "$IAM_HOME/tools/bin/$fn"
                if [ ! -x "$REAL_CMD" ]; then
                    if ! chmod +x "$REAL_CMD" >/dev/null 2>&1; then
                        [ -n "$WARN" ] || echo
                        _warn "could not chmod +x '%s': Permission denied. Run it using gsudo." "$REAL_CMD"
                        WARN=1
                    fi
                fi
            fi
        done
    fi
    [ -z "$WARN" ] || echo
    unset fn REAL_CMD WARN
fi

if [ -f ~/.${IAM}_customrc ]; then
    . ~/.${IAM}_customrc
fi

for VAR in LD_LIBRARY_PATH LIBPATH SHLIB_PATH DYLD_LIBRARY_PATH LD_PRELOAD LD_RUN_PATH; do
    if [ ! -z "${!VAR}" ]; then
        FOUND=1
        _warn 'environment variable defined: %s = "%s"' "$VAR" "${!VAR}"
    fi
done; unset VAR

if [ ! -z "$FOUND" ]; then
    echo ""
    unset FOUND
fi

if _has ssh && _isnot in-container; then
    if ! RESULT="$(ssh -G 127.0.0.1 2>&1)"; then
        _warn 'unknown error while checking SSH ServerAliveInterval\n'
    else
        if ! RESULT="$(echo "$RESULT" | grep '^serveraliveinterval ')"; then
            _warn 'could not find ServerAliveInterval in SSH output\n'
        else
            # $RESULT is expected to be like "serveraliveinterval 60"
            # Let's strip the first word
            RESULT="${RESULT#* }"
            case "$RESULT" in
            ''|*[!0-9]*)
                _warn 'SSH ServerAliveInterval is expected to be a number, but got: "%s"\n' "$RESULT"
                ;;
            *)
                if [ "$RESULT" -ne 60 ]; then
                    _info 'SSH ServerAliveInterval is "%s". Adding correct value (60) to ~/.ssh/config' "$RESULT"
                    if [ ! -d ~/.ssh ]; then
                        mkdir -p ~/.ssh
                        chmod 0700 ~/.ssh
                    fi
                    if [ -f ~/.ssh/config ]; then
                        TEMP_FILE="$(mktemp)"
                        echo 'ServerAliveInterval 60' > "$TEMP_FILE"
                        cat ~/.ssh/config >> "$TEMP_FILE"
                        cat "$TEMP_FILE" > ~/.ssh/config
                        rm -f "$TEMP_FILE"
                        unset TEMP_FILE
                    else
                        echo 'ServerAliveInterval 60' >> ~/.ssh/config
                        chmod 0600 ~/.ssh/config
                    fi
                    echo
                fi
                ;;
            esac
        fi
    fi
    unset RESULT
fi

# show warning if docker group exists, but current user is not in the group
if getent group docker >/dev/null 2>&1; then
    if ! id -nG | grep -qw "docker"; then
        _warn 'Current user is not in docker group. Run: ~c~sudo usermod -a -G docker %s\n' "$USER"
    fi
fi

if [ "$TERM" != "xterm-256color" ] && [ "$TERM" != "tmux-256color" ]; then
    # unset custom TERMINFO since we don't have definitions for this terminal
    unset TERMINFO
    _warn 'Unexpected TERM type: "%s"\n' "$TERM"
elif [ ! -e "$IAM_HOME/terminfo"/*/xterm-256color ]; then
    _warn 'Terminfo file "%s" not found. Perhaps the "tic" command does not exist in the environment.\n' "$IAM_HOME/terminfo/*/xterm-256color"
    unset TERMINFO
fi

if _has git && _vercomp 1.7.9 '>' "$__GIT_VERSION"; then
    _warn 'git v%s is too old and does not support signatures, v1.7.9 or higher is required.\n' "$__GIT_VERSION"
fi

if ! _is in-container; then
    SSH_PUB_KEY_ONLY="`echo $SSH_PUB_KEY | awk '{print $2}'`"
    if [ -z "$SSH_PUB_KEY_ONLY" ]; then
        _warn 'SSH key is not defined\n'
    else
        if [ ! -d ~/.ssh ]; then
            mkdir ~/.ssh
            chmod 0700 ~/.ssh
        fi
        if [ ! -f ~/.ssh/authorized_keys ]; then
            echo "$SSH_PUB_KEY" > ~/.ssh/authorized_keys
            chmod 0600 ~/.ssh/authorized_keys
            _info 'SSH key installed\n'
        # 'grep -q' is not supported on some ancient environments (solaris/solaris x86)
        elif ! grep "$SSH_PUB_KEY_ONLY" ~/.ssh/authorized_keys >/dev/null 2>&1; then
            echo "$SSH_PUB_KEY" >> ~/.ssh/authorized_keys
            _info 'SSH key installed\n'
        fi
    fi
    unset SSH_PUB_KEY_ONLY
fi

if [ ! -x "$IAM_HOME/tools/bin/geturl" ]; then
    [ -d "$IAM_HOME/tools/bin" ] || mkdir -p "$IAM_HOME/tools/bin"
    {
        echo '#!/usr/bin/env bash'
        declare -f _is _isnot _hash _hash_in _check _has _catch _get_url
        echo '_get_url "$@"'
    } > "$IAM_HOME/tools/bin/geturl"
    chmod +x "$IAM_HOME/tools/bin/geturl"
fi

if _isnot tmux; then

    if _is wsl; then
        # Check option=metadata in /etc/wsl.conf
        if [ ! -f /etc/wsl.conf ] || ! grep -q -E '^options\s*=.*metadata' /etc/wsl.conf; then
            _warn 'etc/wsl.conf does not contain "option=metadata" in the section "[autoconf]". This is necessary to preserve the linux permissions on the Windows file system.'
            echo "Launch 'sudo vi /etc/wsl.conf' and add the following under the section '[automount]':"
            echo "    options = \"metadata,umask=22,fmask=11,case=off\""
            echo "Restart WSL after that."
            echo
        fi

        # Check if Windows standard exes are available
        if [ ! -d /usr/bin/windows/System32 ]; then
            _warn "/usr/bin/windows/System32 is unavailable. Windows standard exes will not work. Do the following:"
            echo "\$ sudo mkdir -p /usr/bin/windows"
            echo "\$ sudo vi /etc/fstab"
            echo 'c:\\Windows /usr/bin/windows drvfs ro,noatime,metadata 0 0'
            echo "\$ sudo vi /etc/wsl.conf"
            echo "Make sure that 'mountFsTab = true' exists under the section '[automount]'"
            echo
        fi

        # Check for WSL-Pro service from Ubuntu. This is unknown and useless
        # thing that should be disabled.
        if __RESULT="$(systemctl is-enabled wsl-pro.service 2>&1)" && [ "$__RESULT" = "enabled" ]; then
            _warn '~B~%s~d~ is enabled. Run the following command to disable it: ~c~%s' \
                "wsl-pro.service" "sudo systemctl disable --now wsl-pro.service"
            echo
        fi
        unset __RESULT
    fi

    # Validate __magic_ssh. We use it as argument to "docker run ..."/"ssh ...".
    # It should be less than MAX_ARG_STRLEN (131072) to be compatible with Linux.
    # See: https://docs.opensvc.com/latest/_static/argmax.html

    { # disable messages duing +x
        V="$(__magic_ssh)"
    } 2>/dev/null
    if [ "${#V}" -ge 131072 ]; then
        _warn "__magic_ssh() returns a string of length %s, which exceeds the maximum allowed length of 131071.\n" "${#V}"
    fi
    unset V

    # if we are in cygwin, but not in ssh, then just create 3 detached sessions
    #if [ -z "$SSH_CLIENT" ]; then
    #    tmux -L local new-session -d
    #    tmux -L local new-session -d
    #    tmux -L local new-session -d
    #    exit 0
    #fi

    # don't check for tools update and don't print saved directories in new tmux window
    tools check quick update
    [ -z "$__JUMPLIST_FUNCTIONS_AVAILABLE" ] || j -prompt

    if _has tmux; then
        if command tmux list-sessions -F '#{session_attached}' 2>/dev/null | grep --silent --fixed-strings '0'; then
            cprintf "~K~[~c~TMUX~K~] ~d~Current environment has the following unattached tmux sessions: \"%s\"" \
                "$(tmux list-sessions -F '#{session_attached} #{session_name}' | grep '^0' | sed -E 's/^[[:digit:]][[:space:]]+//' | sed ':a;N;$!ba; s/\n/", "/g')"
            cprintf "~K~[~c~TMUX~K~] ~d~Type to attach: tmux attach-session -t <session name>"
        fi
    fi

    # Restore PWD for session, but not in tmux
    if [ -n "$_TERM_SESSION_DIR" ]; then
        if [ -r "$_TERM_SESSION_DIR/pwd" ]; then
            # Remove a session older than 259200 seconds ( 60*60*24*3 ) or 3 days
            if [ "$(expr $(date +"%s") - $(date -r "$_TERM_SESSION_DIR/pwd" +"%s"))" -gt 259200 ]; then
                rm -rf "$_TERM_SESSION_DIR/*"
            else
                NEW_PWD="$(< "$_TERM_SESSION_DIR/pwd")"
                if [ -d "$NEW_PWD" ]; then
                    cd "$NEW_PWD"
                else
                    _warn "previous PWD '%s' is not reachable" "$NEW_PWD"
                fi
                unset NEW_PWD
            fi
        fi
        [ ! -r "$_TERM_SESSION_DIR/vim" ] || vim
    fi

fi

