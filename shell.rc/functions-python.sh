#!/bin/bash

_has python3 || _has python || return

if _has python3; then

    python() {
        if [ -n "$VIRTUAL_ENV" ]; then
            command python "$@"
        else
            command python3 "$@"
        fi
    }

    pip() {
        if [ -n "$VIRTUAL_ENV" ]; then
            command pip "$@"
        else
            command pip3 "$@"
        fi
    }

fi

,venv() {

    local CMD="$1"
    local RC
    local VENV_HOME

    case "$CMD" in
        "")
            if [ -n "$VIRTUAL_ENV" ]; then
                echo "Python venv already activated at: $VIRTUAL_ENV"
                return 0
            fi
            python -m venv .venv && RC=0 || RC=$?
            if [ "$RC" -eq 0 ] && [ -f "$PWD/requirements.txt" ]; then
                source "$PWD"/.venv/bin/activate && pip install -r "$PWD/requirements.txt" && RC=0 || RC=$?
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
