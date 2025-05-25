#!/bin/bash

_has docker || return

docker() {
    # Execute in subshell to suppress trace messages in this function, but leave
    # the default trace status in the original shell instance.
    (
        { set +x; } 2>/dev/null
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
    )
}

,docker() {
    local CMD="$1"
    shift

    case "$CMD" in
        exec)
            docker exec -ti "$@" /bin/sh -c "$(__magic_ssh)"
            ;;
        run)
            docker run -ti --entrypoint /bin/sh "$@" -c "$(__magic_ssh)"
            ;;
        *)
            echo "Unknown cmd: '$CMD'"
            return 1
            ;;
    esac
}

__,docker() {

    if [ "$1" = "--install-completion" ]; then
        complete -F __,docker ,docker
        return
    fi

    local CUR="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=()

    if [ $COMP_CWORD -eq 1 ]; then
        COMPREPLY=($(compgen -W "exec run" -- "$CUR"))
        return
    fi

    local CMD="${COMP_WORDS[1]}"
    local VAR

    if [ "$CMD" = "run" ]; then
        # This is a hack when we complete tag name. By default, completion also breaks the line by ':'.
        # E.g. "zookeeper:3.8." will be as:
        # COMP_CWORD - 3
        # COMP_WORDS - xdocker-run zookeeper : 3.8.
        if [ "${COMP_WORDS[COMP_CWORD-1]}" = ":" ]; then
            COMPREPLY=($(compgen -W "$(docker image ls --filter "dangling=false" --filter "reference=${COMP_WORDS[COMP_CWORD-2]}" --format '{{.Tag}}')" -- "$CUR"))
        else
            COMPREPLY=($(compgen -W "$(docker image ls --filter "dangling=false" --format '{{.Repository}}:{{.Tag}}')" -- "$CUR"))
        fi
    elif [ "$CMD" = "exec" ]; then
        if [ $COMP_CWORD -eq 2 ] && [ -z "$CUR" ]; then
            if VAR="$(docker ps --format '{{.Names}}' 2>&1)" && [ "$(echo "$VAR" | wc -l)" -eq 1 ]; then
                if [ -z "$VAR" ]; then
                    printf '\n%s' "There are no containers running"
                    COMPREPLY=('~=~=~=~=~=~' '=~=~=~=~=~=')
                else
                    COMPREPLY=("$VAR")
                fi
            else
                printf '\n%s' "$(docker ps)"
                COMPREPLY=('~=~=~=~=~=~' '=~=~=~=~=~=')
            fi
            return
        fi
        if [ $COMP_CWORD -gt 2 ]; then
            compopt -o default
            return
        fi
        if ! VAR="$(printf '%s\n%s' "$(docker ps --quiet 2>&1)" "$(docker ps --format '{{.Names}}' 2>&1)")"; then
            cprintf -n '\n~r~ERROR~K~: ~d~%s' "$VAR"
            COMPREPLY=('~=~=~=~=~=~' '=~=~=~=~=~=')
        else
            COMPREPLY=($(compgen -W "$VAR" -- "$CUR"))
        fi
    fi

}

__,docker --install-completion
