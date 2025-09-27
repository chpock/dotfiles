#!/bin/bash

__gpgconf_validate() {
    _has gpgconf || return
    # Run in subshell with disabled job control to avoid garbage in terminal
    (set +m; __background_gpgconf_validate &)
}

__background_gpgconf_validate() {
    # Set password cache to 2592000 seconds (30 days)
    local -A GPG_VALUES=(
        ["default-cache-ttl"]=2592000
        ["default-cache-ttl-ssh"]=2592000
        ["max-cache-ttl"]=2592000
        ["max-cache-ttl-ssh"]=2592000
    )
    local PARAM VALUE _ UPDATED=0
    while IFS=":" read -r PARAM _ _ _ _ _ _ _ _ VALUE; do
        if [[ -v 'GPG_VALUES[$PARAM]' ]] && [ "${GPG_VALUES["$PARAM"]}" != "$VALUE" ]; then
            echo "${PARAM}:3:${GPG_VALUES["$PARAM"]}" | gpgconf --change-options gpg-agent >/dev/null
            UPDATED=1
        fi
    done < <(gpgconf --list-options gpg-agent 2>/dev/null)
    if [ "$UPDATED" = "1" ]; then
        gpgconf --kill gpg-agent
    fi
}
