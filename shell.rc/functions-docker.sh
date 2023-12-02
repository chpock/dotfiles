#!/bin/bash

_has docker || return

docker() {
    local LINE
    # check if the first arg is "rmi" and the second arg has "*"
    if [ "$1" = "rmi" ] && [ "$2" != "${2%\**}" ]; then
        local MASK="$2"
        shift
        shift
        while IFS= read -r LINE; do
            case "$LINE" in
                *\<none\>*) continue ;;
                $MASK) set -- "$LINE" "$@" ;;
            esac
        done < <(command docker images --format '{{.Repository}}:{{.Tag}}')
        set -- "rmi" "$@"
    elif [ "$1" = "prune" ]; then
        shift
        set -- system prune --force --volumes
    elif [ "$1" = "run" ]; then
        # always add --rm to 'docker run' command if there is no '-d' argument
        local IS_DETACH="" i
        for i in "$@"; do
            if [ "$i" = "-d" ]; then
                IS_DETACH=1
                break
            elif [ "$i" = "--" ]; then
                break
            fi
        done
        [ -n "$IS_DETACH" ] || set -- "$1" "--rm" "${@:2}"
    fi
    command docker "$@"
}

xdocker-exec() {
   docker exec -ti "$1" /bin/bash -c "$(__magic_ssh)"
}

xdocker-run() {
   docker run -ti --entrypoint /bin/bash "$1" -c "$(__magic_ssh)"
}

__xdocker-exec_complete() {

    local __VAR

    COMPREPLY=()

    if [ $COMP_CWORD -eq 1 ] && [ -z "${COMP_WORDS[1]}" ]; then
        if __VAR="$(docker ps --format '{{.Names}}' 2>&1)" && [ "$(echo "$__VAR" | wc -l)" -eq 1 ]; then
            COMPREPLY=("$__VAR")
        else
            echo
            printf '%s' "$(docker ps)"
            COMPREPLY=('~=~=~=~=~=~' '=~=~=~=~=~=')
        fi
        return
    fi

    if [ $COMP_CWORD -gt 1 ]; then
        compopt -o default
        return
    fi

    if ! __VAR="$(printf '%s\n%s' "$(docker ps --quiet 2>&1)" "$(docker ps --format '{{.Names}}' 2>&1)")"; then
        echo
        printf '%s' "${COLOR_RED}ERROR${COLOR_GRAY}:$COLOR_DEFAULT $__VAR"
        COMPREPLY=('~=~=~=~=~=~' '=~=~=~=~=~=')
    else
        COMPREPLY=($(compgen -W "$__VAR" -- "${COMP_WORDS[1]}"))
    fi

}

complete -F __xdocker-exec_complete xdocker-exec

__xdocker-run_complete() {
    :
    : COMP_CWORD - $COMP_CWORD
    : COMP_WORDS - ${COMP_WORDS[@]}
    COMPREPLY=()
    if [ $COMP_CWORD -eq 1 ]; then
        COMPREPLY=($(compgen -W "$(docker image ls --filter "dangling=false" --format '{{.Repository}}:{{.Tag}}')" -- "${COMP_WORDS[1]}"))
    elif [ $COMP_CWORD -ge 2 ] && [ $COMP_CWORD -le 3 ] && [ "${COMP_WORDS[2]}" = ":" ]; then
        # This is a hack when we complete tag name. By default, completion also breaks the line by ':'.
        # E.g. "zookeeper:3.8." will be as:
        # COMP_CWORD - 3
        # COMP_WORDS - xdocker-run zookeeper : 3.8.
        COMPREPLY=($(compgen -W "$(docker image ls --filter "dangling=false" --filter "reference=${COMP_WORDS[1]}" --format '{{.Tag}}')" -- "${COMP_WORDS[3]}"))
    fi
}

complete -F __xdocker-run_complete xdocker-run

