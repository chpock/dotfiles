#!/bin/bash

_has curl || return

,share() {
    local EXPIRES=24 FILE
    while [ $# -gt 0 ]; do
        case "$1" in
            -expires)
                EXPIRES="$2"
                shift
                ;;
            *)
                if [ -n "$FILE" ]; then
                    _err "unknown argument: '%s'" "$1"
                    return 1
                fi
                FILE="$1"
                ;;
        esac
        shift
    done
    if [ -z "$FILE" ]; then
        echo "Usage: ,share [-expires <hours>] <file>"
        return
    elif [ ! -r "$FILE" ]; then
        _err "specified path '%s' is not a file or is not readable" "$FILE"
        return 1
    fi
    set -- curl --fail-with-body --silent --show-error \
        -H "User-Agent: dotfiles/1.0 (https://github.com/chpock/dotfiles/blob/master/shell.rc/functions-share.sh)" \
        -Ffile="@$FILE" -Fsecret=
    if [ -z "$EXPIRES" ] || [ "$EXPIRES" = "0" ] || [ "$EXPIRES" = "-" ]; then
        _info "Upload file '%s' without an expiration date..." "$FILE"
    else
        _info "Upload file '%s' that will be expired in %i hours ..." "$FILE" "$EXPIRES"
        set -- "$@" -Fexpires="$EXPIRES"
    fi
    set -- "$@" "https://0x0.st"
    local URL
    if ! URL="$("$@")"; then
        _err "%s" "$URL"
        return 1
    fi
    local BASENAME
    _basename -v BASENAME "$FILE"
    _info "URL: %s" "$URL/$BASENAME"
}

_comp,share() {

    local cur="${COMP_WORDS[COMP_CWORD]}"

    if [ "$COMP_CWORD" -ge 2 ]; then
        if [ "${COMP_WORDS[COMP_CWORD-1]}" == "-expires" ]; then
            COMPREPLY=( $(compgen -W "0 1 6 24 168 720 -" -- "$cur") )
            return
        fi
    fi

    case "$cur" in
        -*)
            COMPREPLY=($(compgen -W "-expires" -- "$cur"))
            ;;
        *)
            # complete file paths by default
            COMPREPLY=( $(compgen -f -- "$cur") )
            ;;
    esac

}

complete -F _comp,share ,share
