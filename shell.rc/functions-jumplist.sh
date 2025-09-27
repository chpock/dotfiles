#!/bin/bash

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
                    # Disable: Prefer mapfile or read -a to split command output (or quote to avoid splitting). [SC2207]
                    # shellcheck disable=SC2207
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
        if [ "${COMP_WORDS[1]}" = "-rename" ] && [ "$COMP_CWORD" -gt 2 ]; then
            return
        fi
        # Disable: Prefer mapfile or read -a to split command output (or quote to avoid splitting). [SC2207]
        # shellcheck disable=SC2207
        COMPREPLY=($(COMP_CWORD='' j -complete "$CURRENT"))
        return
    fi

    rm -f "$JUMP_FILE_TEMP"

    if [ "$1" = "-last" ]; then
        if [ -e "$IAM_HOME/jumplist_last_pwd" ]; then
            cd "$(cat "$IAM_HOME/jumplist_last_pwd")" || :
        else
            echo "JumpList: last directory is unknown"
        fi
        return
    fi

    if [ "$1" = "-add" ]; then
        DIR="$(pwd)"
        NAME="$2"
        [ -z "$NAME" ] && NAME="$(basename "$DIR")" || true
        printf '%s\t%s\n' "$NAME" "$DIR" >>"$JUMP_FILE"
        echo "JumpList: added '$NAME' for '$DIR'"
        return
    fi

    if [ "$1" = "-del" ]; then
        if [ -z "$2" ]; then
            echo "JumpList: ERROR: The name is not specified."
            echo "Usage: j -del <name>"
            return 1
        fi
        local FOUND
        if [ -e "$JUMP_FILE" ]; then
            while IFS=$'\t' read -r NAME DIR; do
                if [ "$NAME" != "$2" ]; then
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
        # Disable: Note that A && B || C is not if-then-else. C may run when A is true. [SC2015]
        # shellcheck disable=SC2015
        [ -e "$JUMP_FILE_TEMP" ] && mv -f "$JUMP_FILE_TEMP" "$JUMP_FILE" || rm -f "$JUMP_FILE"
        return
    fi

    if [ "$1" = "-rename" ]; then
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
                if [ "$NAME" != "$2" ]; then
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
        # Disable: Note that A && B || C is not if-then-else. C may run when A is true. [SC2015]
        # shellcheck disable=SC2015
        [ -e "$JUMP_FILE_TEMP" ] && mv -f "$JUMP_FILE_TEMP" "$JUMP_FILE" || rm -f "$JUMP_FILE"
        return
    fi

    if [ "$1" = "-list" ] || [ -z "$1" ]; then
        if [ -e "$JUMP_FILE" ]; then
            local COUNTER=1
            while IFS=$'\t' read -r NAME DIR; do
                printf "[%2i] %-20s %s\n" "$COUNTER" "$NAME" "$DIR"
                COUNTER="$(( 1 + COUNTER ))"
            done < "$JUMP_FILE"
        else
            echo "JumpList: no directories"
        fi
        return
    fi

    if [ "$1" = "-complete" ]; then
        if [ -e "$JUMP_FILE" ]; then
            while IFS=$'\t' read -r NAME DIR; do
                case "$NAME" in $2*) echo "$NAME" ;; esac
            done < "$JUMP_FILE"
        fi
        return
    fi

    if [ "$1" = "-prompt" ]; then
        if [ -e "$JUMP_FILE" ]; then
            local NAME_LIST
            while IFS=$'\t' read -r NAME DIR; do
                if [ -z "$NAME_LIST" ]; then
                    NAME_LIST="$NAME"
                else
                    cprintf -a NAME_LIST '~K~, ~d~%s' "$NAME"
                fi
            done < "$JUMP_FILE"
            cprintf '~K~[~c~JumpList~K~] ~d~%s' "$NAME_LIST"
        fi
        return
    fi

    if [ "$1" = "-help" ]; then
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
            if [ "$NAME" = "$1" ]; then
                JUMP="$DIR"
            fi
        done < "$JUMP_FILE"
    fi

    if [ -z "$JUMP" ]; then
        echo "JumpList: there is no directory '$1'"
        return 1
    fi

    cd "$JUMP/$2" || :

}

__JUMPLIST_FUNCTIONS_AVAILABLE=1

complete -F j j
