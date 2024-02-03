#!/bin/sh

if [ -x /bin/bash ]; then
    BASH_BIN=/bin/bash
elif [ -x /usr/bin/bash ]; then
    BASH_BIN=/usr/bin/bash
elif [ -x "$IAM_HOME/tools/bin/bash" ]; then
    BASH_BIN="$IAM_HOME/tools/bin/bash"
elif ! BASH_BIN="$(command -v bash 2>/dev/null)"; then
    unset BASH_BIN
    OS="$(uname -o):$(uname -m)"
    if [ "$OS" = "GNU/Linux:x86_64" -o "$OS" = "Linux:x86_64" ]; then
        [ -d "$IAM_HOME/tools/bin" ] || mkdir -p "$IAM_HOME/tools/bin"
        BASH_BIN="$IAM_HOME/tools/bin/bash"
        URL="https://github.com/chpock/dotfiles/releases/download/v0.0.0/bash-portable.5.2.21.linux.x86_64"
        if command -v curl >/dev/null 2>&1 && curl --silent -L "$URL" -o "$BASH_BIN" >/dev/null 2>&1; then
            SUCCESS=1
        elif command -v wget >/dev/null 2>&1 && wget -q -O "$BASH_BIN" "$URL" >/dev/null 2>&1; then
            SUCCESS=1
        elif [ -x /usr/lib/apt/apt-helper ] && /usr/lib/apt/apt-helper -oAcquire::https::Verify-Peer=false download-file "$URL" "$BASH_BIN" >/dev/null 2>&1; then
            SUCCESS=1
        fi
        if [ -z "$SUCCESS" ]; then
            rm -f "$BASH_BIN"
            unset BASH_BIN
        else
            chmod +x "$BASH_BIN"
            unset SUCCESS
        fi
    fi
fi

[ -z "$BASH_BIN" ] || exec "$BASH_BIN" --rcfile "$IAM_HOME/bashrc" -i

[ -z "$SHELL" ] || exec "$SHELL" -i

exec /bin/sh -i
