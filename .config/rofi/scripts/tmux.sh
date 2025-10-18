#!/bin/sh

set -e

TMUX_TMPDIR=~/.kk_home/session/tmux
export TMUX_TMPDIR

case "$ROFI_RETV" in
    0) # Initial call of script
        printf "\0markup-rows\x1ftrue\n"
        printf "\0no-custom\x1ftrue\n"
        tmux list-sessions -F '#{session_attached} #{session_id} #{session_name}' | while IFS= read -r LINE; do
            SESSION_ID="${LINE#* }"
            DISPLAY_ITEM="${SESSION_ID#* }"
            SESSION_ID="${SESSION_ID%% *}"
            if [ "${LINE%% *}" != "0" ]; then
                DISPLAY_ITEM="$DISPLAY_ITEM <span foreground=\"blue\"><small><i>(attached)</i></small></span>"
            fi
            printf "%s\0info\x1f%s\n" "$DISPLAY_ITEM" "$SESSION_ID"
        done
        ;;
    1) # Selected an entry
        if [ "$(tmux display-message -t "$ROFI_INFO" -p '#{session_attached}')" = "0" ]; then
            _MAGIC_TMUX="$ROFI_INFO" nohup sh -c "sleep 0.1; rofi-sensible-terminal" >/dev/null 2>&1 &
        else
            CLIENT_PID="$(tmux display-message -t "$ROFI_INFO" -p '#{client_pid}')"
            PARENT_PID="$(ps -o ppid= -p "$CLIENT_PID" | awk '{print $1}')"
            nohup sh -c "sleep 0.1; hyprctl dispatch focuswindow \"pid:$PARENT_PID\"" >/dev/null 2>&1 &
        fi
        ;;
    2) # Selected a custom entry
        : no-op
        ;;
    3) # Deleted an entry
        : no-op
        ;;
    # 10-28: Custom keybinding 1-19
    *) # WTF??
        echo "Unknown ROFI_RETV: $ROFI_RETV"
        ;;
esac
