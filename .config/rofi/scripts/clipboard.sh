#!/bin/sh

PERSISTENT_DB_PATH="$XDG_CACHE_HOME/cliphist/persistent"

if [ -n "$ROFI_CLIPBOARD_PERSISTENT" ]; then
    CLIPHIST_DB_PATH="$PERSISTENT_DB_PATH"
    export CLIPHIST_DB_PATH
fi

send_paste() {
    [ -n "$XDG_STATE_HOME" ] || return 0
    mkdir -p "$XDG_STATE_HOME/rofi/scripts"
    printf '' > "$XDG_STATE_HOME/rofi/scripts/send-paste"
}

case "$ROFI_RETV" in
    0) # Initial call of script
        printf "\0use-hot-keys\x1ftrue\n"
        cliphist list | awk '{
            split($0, a, "\t")
            word=a[1]
            rest=substr($0, index($0, "\t")+1)
            printf "%s\0info\x1f%s", rest, word
            printf "\n"
        }'
        ;;
    1) # Selected an entry
        printf '%s' "$ROFI_INFO" | cliphist decode | wl-copy
        send_paste
        ;;
    2) # Selected a custom entry
        echo "$1"
        ;;
    3) # Deleted an entry
        printf '%s' "$ROFI_INFO" | cliphist delete
        ;;
    10) # Custom keybinding 1 (Shift-Enter)
        if [ -z "$ROFI_CLIPBOARD_PERSISTENT" ]; then
            # Move selection into persistent storage in clipboard mode
            printf '%s' "$ROFI_INFO" | cliphist decode | CLIPHIST_DB_PATH="$PERSISTENT_DB_PATH" cliphist store
        else
            # Paste selection in persistent mode
            printf '%s' "$ROFI_INFO" | cliphist decode | wl-copy
            send_paste
        fi
        ;;
    # 10-28: Custom keybinding 1-19
    *) # WTF??
        echo "Unknown ROFI_RETV: $ROFI_RETV"
        ;;
esac

