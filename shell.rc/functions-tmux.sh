#!/bin/bash

_has tmux || return

,tmux() {
    local CMD="$1"
    local SEP=$'\t'
    local SESSION_BACKUP_FILE="$TMUX_TMPDIR/backup"
    local session_name session_id session_persistent_id session_dir
    local window_name window_id window_persistent_id current_path
    local active_window_id active_window_persistent_id
    shift

    case "$CMD" in
        _get-id-from-backup)
            if [ -e "$BACKUP_FILE_IDS" ]; then
                local current_session_name
                current_session_name="$(tmux display-message -p '#S')"
                while IFS="$SEP" read -r session_name session_id; do
                    if [ "$session_name" = "$current_session_name" ]; then
                        echo "$session_id"
                        return 0
                    fi
                done < "$BACKUP_FILE_IDS"
            fi
            return 1
            ;;
        save)
            while IFS="$SEP" read -r session_name session_id session_persistent_id; do
                echo "${session_name}${SEP}${session_persistent_id}"
                session_dir="$TMUX_TMPDIR/id-$session_persistent_id"
                active_window_id="$(command tmux display-message -t "$session_id" -p -F '#{window_id}' 2>/dev/null)"
                rm -f "$session_dir/backup_active"
                while IFS="$SEP" read -r window_name window_id current_path; do
                    window_persistent_id="$(command tmux show -w -t "$window_id" -v '@persistent-id')"
                    echo "${window_name}${SEP}${window_persistent_id}${SEP}${current_path}"
                    if [ "$window_id" = "$active_window_id" ]; then
                        echo "$window_persistent_id" > "$session_dir/backup_active"
                    fi
                done \
                    < <(command tmux list-windows -t "$session_id" -F "#{window_name}${SEP}#{window_id}${SEP}#{pane_current_path}") \
                    > "$session_dir/backup"
            done \
                < <(command tmux list-sessions -F "#{session_name}${SEP}#{session_id}${SEP}#{_TMUX_SESSION_ID}") \
                > "$SESSION_BACKUP_FILE"
            ;;
        restore)
            [ -e "$SESSION_BACKUP_FILE" ] || return 0
            local tmp_session_id tmp_session_persistent_id
            local known_sessions
            local known_windows
            local restore_full_session session_sid_file
            local cols lines
            known_sessions="$(command tmux list-sessions -F "#{session_id}${SEP}#{_TMUX_SESSION_ID}" 2>/dev/null || true)"
            cols="$(tput cols 2>/dev/null)" || cols="-"
            lines="$(tput lines 2>/dev/null)" || lines="-"
            while IFS="$SEP" read -r session_name session_persistent_id; do
                # We don't use filter feature to find existing session as it is only available in tmux v3.3+.
                unset session_id restore_full_session known_windows
                session_dir="$TMUX_TMPDIR/id-$session_persistent_id"
                while IFS="$SEP" read -r tmp_session_id tmp_session_persistent_id; do
                    if [ "$tmp_session_persistent_id" = "$session_persistent_id" ]; then
                        session_id="$tmp_session_id"
                        break
                    fi
                done <<< "$known_sessions"
                if [ -z "$session_id" ]; then
                    restore_full_session=1
                    session_sid_file="$session_dir/sid"
                    rm -f "$session_sid_file"
                    echo "[TMUX] restore session: $session_name"
                    # We can use "tmux new-session -e _TMUX_SESSION_ID=XYZ ..." to set the environment
                    # variable in the session being restored. However, this feature is only available
                    # in tmux v3.1+. Thus, we will create a session with a dummy window and set
                    # the environment variable there. After that, we will create all other real windows.

                    # We should not use 'command tmux' here, as we want to use usual tmux function that
                    # will use proper tmux config file.
                    session_id="$(
                        SSH_PUB_KEY="$SSH_PUB_KEY" \
                        _GIT_USER_EMAIL="$_GIT_USER_EMAIL" \
                        _GIT_USER_NAME="$_GIT_USER_NAME" \
                        tmux new-session -d -x "$cols" -y "$lines" -s "$session_name" -P -F '#{session_id}' -n '__dummy__' 'sleep infinity' \
                    )"
                    command tmux set-env -t "$session_id" _TMUX_SESSION_ID "$session_persistent_id"
                fi
                if [ -e "$session_dir/backup" ]; then
                    while read -r window_id; do
                        if window_persistent_id="$(command tmux show -w -t "$window_id" -v '@persistent-id' 2>/dev/null)" && [ -n "$window_persistent_id" ]; then
                            known_windows+="${SEP}${window_persistent_id}"
                        fi
                    done < <(command tmux list-windows -t "$session_id" -F '#{window_id}')
                    known_windows+="${SEP}"
                    unset active_window_id
                    # Disable: Note that A && B || C is not if-then-else. C may run when A is true. [SC2015]
                    # shellcheck disable=SC2015
                    [ -e "$session_dir/backup_active" ] \
                        && active_window_persistent_id="$(< "$session_dir/backup_active")" \
                        || unset active_window_persistent_id
                    # It's a simple "touch", but using the built-in "echo" and without calling
                    # an external "touch" utility.
                    echo > "$session_dir/mode-restore"
                    while IFS="$SEP" read -r window_name window_persistent_id current_path; do
                        # Check if the current window is in the list of existing windows
                        [ "$known_windows" = "${known_windows#*"${SEP}$window_persistent_id${SEP}"}" ] || continue
                        if [ -z "$restore_full_session" ]; then
                            echo "[TMUX] restore window '$window_name' with path '$current_path' (session: $session_name)"
                        fi
                        if ! window_id="$(tmux new-window -d -t "$session_id" -n "$window_name" -c "$current_path" -P -F '#{window_id}')"; then
                            _warn "could not restore the window '%s' with current path '%s'" "$window_name" "$current_path"
                            continue
                        fi
                        command tmux set -w -t "$window_id" '@persistent-id' "$window_persistent_id"
                        [ "$window_persistent_id" != "$active_window_persistent_id" ] || active_window_id="$window_id"
                    done < "$session_dir/backup"
                    rm -f "$session_dir/mode-restore"
                    [ -z "$active_window_id" ] || command tmux select-window -t "${session_id}:${active_window_id}"
                fi
                if [ -n "$restore_full_session" ]; then
                    command tmux kill-window -t "${session_id}:__dummy__"
                    local counter=0
                    while [ ! -e "$session_sid_file" ]; do
                        [ "$counter" -eq 0 ] || printf '\r'
                        printf "[TMUX] waiting for sid file: %s (%s)" "$session_sid_file" "$counter"
                        sleep 0.05
                        counter=$(( counter + 1 ))
                    done
                    # clear current line
                    [ "$counter" -eq 0 ] || printf '\r\033[K'
                fi
            done < "$SESSION_BACKUP_FILE"
            #while IFS="$SEP" read session_name window_name current_path; do
            #    if tmux has-session -t "$session_name" 2>/dev/null; then
            #        # restore the windows if we need to restore this session
            #        if [ "$WANT_TO_RESTORE" = "$session_name" ]; then
            #            tmux new-window -d -t "${session_name}:" -n "$window_name" -c "$current_path"
            #        fi
            #    else
            #        echo "[TMUX] restore session: $session_name"
            #        (cd "$current_path" && tmux new-session -d -s "$session_name" -n "$window_name")
            #        # mark current session name as needed to be restored
            #        WANT_TO_RESTORE="$session_name"
            #    fi
            #done < "$BACKUP_FILE"
            ;;
        autosave)
            # Backup sessions every 10th invocation
            __TMUX_BACKUP_COUNTER=$(( __TMUX_BACKUP_COUNTER + 1 ))
            if [ $__TMUX_BACKUP_COUNTER -ge 10 ]; then
                ,tmux save
                __TMUX_BACKUP_COUNTER=0
            fi
            ;;
        memory)
            local MAX_LEN_SIZE MAX_LEN_SESSION
            # Find the longest number of bytes
            MAX_LEN_SIZE="$(tmux list-panes -a -F '#{history_bytes}' \
                | awk 'length > maxlen { maxlen = length } END { print maxlen }')"
            # Fin the longest session name
            MAX_LEN_SESSION="$(tmux list-sessions -F '#S' \
                | awk 'length > maxlen { maxlen = length } END { print maxlen }')"
            tmux list-panes -a -F \
                "#{p$(( MAX_LEN_SIZE + 1)):history_bytes} [#{p$(( MAX_LEN_SESSION + 1)):session_name}] Win: ###{window_index} (lines: #{history_size}/#{history_limit})" \
                | sort --numeric-sort --reverse
            ;;
        clean)
            local ID
            tmux list-panes -a -F '#{pane_id}' | while read -r ID; do
                tmux clear-history -t "$ID"
            done
            ;;
        *)
            echo "Unknown cmd: '$CMD'"
            return 1
            ;;
    esac
}

_tmux_generate_conf() {

    local TMUX_CONF_TEMPLATE="$IAM_HOME/tmux.conf.template"
    local TMUX_CONF="$IAM_HOME/tmux.conf"

    # return if there is no tmux.conf template
    [ -e "$TMUX_CONF_TEMPLATE" ] || return 0
    # return if tmux.conf exists and its timestamp is newer than the tmux.conf template
    [ -e "$TMUX_CONF" ] && [ "$TMUX_CONF" -nt "$TMUX_CONF_TEMPLATE" ] && return 0 || :

    # strip beta prefix for versions like '3.0a', '3.1c', etc.
    local ver
    ver="$(command tmux -V | sed -E -e 's/^.*[[:space:]][^[:digit:]]*//' -e 's/[^[:digit:]]*$//')"

    local min_ver max_ver line blank
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
        # Disable: Note that A && B || C is not if-then-else. C may run when A is true. [SC2015]
        # shellcheck disable=SC2015
        [ -z "$line" ] && blank=1 || unset blank
        echo "$line"
    done < "$TMUX_CONF_TEMPLATE" > "$TMUX_CONF"

}

__TMUX_FUNCTIONS_AVAILABLE=1

complete -W 'save restore memory clean' ,tmux
