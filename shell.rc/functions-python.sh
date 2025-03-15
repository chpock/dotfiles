#!/bin/bash

_has python3 || _has python || return

_hasnot python3 || python() {
    if [ -n "$VIRTUAL_ENV" ]; then
        command python "$@"
    else
        command python3 "$@"
    fi
}

_hasnot pip3 || pip() {
    if [ -n "$VIRTUAL_ENV" ]; then
        command pip "$@"
    else
        command pip3 "$@"
    fi
}

,venv() {

    local CMD="$1"
    local RC
    local VENV_HOME
    local FN

    case "$CMD" in
        "")
            if [ -n "$VIRTUAL_ENV" ]; then
                echo "Python venv already activated at: $VIRTUAL_ENV"
                return 0
            fi
            printf "Creating python virtual environment in %s ..." "$PWD"
            python -m venv .venv && RC=0 || RC=$?
            if [ "$RC" -eq 0 ]; then
                printf '\b\b\b\b: OK\n'
                for FN in requirements.txt requirements-dev.txt dev-requirements.txt; do
                    if [ -f "$PWD/$FN" ]; then
                        echo "Installing requirements: $FN ..."
                        (source "$PWD"/.venv/bin/activate && pip install -r "$PWD/$FN") && RC=0 || RC=$?
                    fi
                    [ $RC -eq 0 ] || break
                done
            else
                echo
                echo "Error: something wrong happened."
            fi
            return $RC
            ;;
        "destroy")
            if [ -n "$VIRTUAL_ENV" ]; then
                VENV_HOME="$VIRTUAL_ENV"
                deactivate
            elif [ -d "$PWD/.venv" ]; then
                VENV_HOME="$PWD/.venv"
            else
                echo "Error: there is no python virtual environment in $PWD"
                return 1
            fi
            rm -rf "$VENV_HOME"
            return 0
            ;;
        *)
            echo "Unknown cmd: '$CMD'"
            return 1
            ;;
    esac

}

complete -W 'destroy' ,venv

