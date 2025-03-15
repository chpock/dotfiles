#!/bin/bash

_has tmux || return

,tmux() {
    local CMD="$1"
    local SEP=$'\t'
    local BACKUP_FILE="$TMUX_TMPDIR/sessions-backup"
    local BACKUP_FILE_IDS="$TMUX_TMPDIR/sessions-backup-ids"
    local WANT_TO_RESTORE
    local session_name window_name current_path session_id
    shift

    case "$CMD" in
        _get-id-from-backup)
            if [ -e "$BACKUP_FILE_IDS" ]; then
                local current_session_name="$(tmux display-message -p '#S')"
                while IFS="$SEP" read session_name session_id; do
                    if [ "$session_name" = "$current_session_name" ]; then
                        echo "$session_id"
                        return 0
                    fi
                done < "$BACKUP_FILE_IDS"
            fi
            return 1
            ;;
        save)
            tmux list-windows -a -F "#S${SEP}#W${SEP}#{pane_current_path}" >"$BACKUP_FILE"
            tmux list-sessions -F "#S${SEP}#{_TMUX_SESSION_ID}" >"$BACKUP_FILE_IDS"
            ;;
        restore)
            [ -e "$BACKUP_FILE" ] || return 0
            while IFS="$SEP" read session_name window_name current_path; do
                if tmux has-session -t "$session_name" 2>/dev/null; then
                    # restore the windows if we need to restore this session
                    if [ "$WANT_TO_RESTORE" = "$session_name" ]; then
                        tmux new-window -d -t "${session_name}:" -n "$window_name" -c "$current_path"
                    fi
                else
                    echo "[TMUX] restore session: $session_name"
                    (cd "$current_path" && tmux new-session -d -s "$session_name" -n "$window_name")
                    # mark current session name as needed to be restored
                    WANT_TO_RESTORE="$session_name"
                fi
            done < "$BACKUP_FILE"
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
            # Find the longest number of bytes
            local MAX_LEN_SIZE="$(tmux list-panes -a -F '#{history_bytes}' \
                | awk 'length > maxlen { maxlen = length } END { print maxlen }')"
            # Fin the longest session name
            local MAX_LEN_SESSION="$(tmux list-sessions -F '#S' \
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

__TMUX_FUNCTIONS_AVAILABLE=1

complete -W 'save restore memory clean' ,tmux
