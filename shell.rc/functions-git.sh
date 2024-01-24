#!/bin/bash

_has git || return

_git-config-check() {
    # Msys ALWAYS set +x permissions for files with shebang.
    # This can corrupt permissions in git repo. Disable the permissions to avoid that.
    # https://stackoverflow.com/questions/10915178/msys-shell-command-to-change-the-attributes-of-a-file
    if _is windows && [ "$(set +e; LC_ALL=C command git config --get core.fileMode)" != "false" ]; then
        command git config --global core.fileMode false
    fi
    # fast-forward only for pull
    if [ "$(set +e; LC_ALL=C command git config --get pull.ff)" != "only" ]; then
        command git config --global pull.ff only
    fi
    # never break files
    if [ "$(set +e; LC_ALL=C command git config --get core.autocrlf)" != "false" ]; then
        command git config --global core.autocrlf false
    fi
    # turn on colors
    if [ "$(set +e; LC_ALL=C command git config --get color.ui)" != "auto" ]; then
        command git config --global color.ui auto
    fi
}

git() {
    local REMORE_BRANCH
    local GIT_BIN="$(command -v git)"
    if [ "commit" = "$1" ]; then
        # don't do anything if we are in a merge conflict state
        # https://stackoverflow.com/a/55192451
        if ! "$GIT_BIN" rev-parse -q --verify MERGE_HEAD >/dev/null 2>&1; then
            # if we have upstream branch
            if REMORE_BRANCH=$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>&1); then
                echo "The remove branch has been detected: '$REMOTE_BRANCH'"
                (set -x; "$GIT_BIN" stash)
                (set -x; "$GIT_BIN" pull --ff-only -f)
                (set -x; "$GIT_BIN" stash pop --index --quiet)
            fi
        fi
    elif [ "pull" = "$1" ]; then
        if ! "$GIT_BIN" rev-parse --abbrev-ref --symbolic-full-name '@{u}' >/dev/null 2>&1; then
            echo "${COLOR_YELLOW}WARNING: ${COLOR_DEFAULT}There is no tracking information for the current branch. It will be set."
            local BRANCH
            BRANCH="$("$GIT_BIN" rev-parse --abbrev-ref HEAD)"
            (set -x; "$GIT_BIN" branch "--set-upstream-to=origin/$BRANCH" "$BRANCH")
        fi

    fi
    command git "$@"
}

git-config() {
    local GIT_BIN="$(which git)"
    local GIT_AUTHOR
    local SIGN_KEY
    if [ "$1" = "-local" ]; then
        GIT_AUTHOR="$2"
        set -- --local
    else
        GIT_AUTHOR="$1"
        set --
    fi
    if [ -z "$GIT_AUTHOR" ]; then
        GIT_AUTHOR="$_GIT_USER_EMAIL"
    fi
    (set -x; "$GIT_BIN" config "$@" user.name "$_GIT_USER_NAME")
    (set -x; "$GIT_BIN" config "$@" commit.gpgsign true)
    (set -x; "$GIT_BIN" config "$@" user.email "$GIT_AUTHOR")
    if ! SIGN_KEY="$(set +e; LC_ALL=C gpg --with-colons --list-secret-keys "$GIT_AUTHOR" 2>/dev/null | cut -d: -f5 | head -n 1)"; then
        echo "WARNING: gpg error: $SIGN_KEY"
    elif [ -z "$SIGN_KEY" ]; then
        echo "WARNING: gpg key for '$GIT_AUTHOR' not found!"
    else
        (set -x; "$GIT_BIN" config "$@" user.signingkey "$SIGN_KEY")

    fi
}

git-cleanup() {
    local TO_REMOVE
    local ASK

    # Update remote and cleanup branches that don't exist in remote
    echo "Fetching remote..."
    git fetch --all --prune

    echo "Checking branches..."
    while read -r BRANCH; do
        # skip branches: master, + (worktree), * (current)
        if [ "$BRANCH" = 'master' ] || [ "$BRANCH" = '+' ] || [ "$BRANCH" = '*' ]; then
            continue
        fi
        if [ -n "$(git ls-remote --heads origin "$BRANCH")" ]; then
            echo "KEEP: $BRANCH"
        else
            TO_REMOVE="$TO_REMOVE $BRANCH"
        fi
    done < <(git branch --list | awk '{print $1}')

    echo "Branches to delete:$TO_REMOVE"

    read -p "Do you wish to delete these branches [y/n]? " ASK

    case $ASK in
        [Yy]* )
            for BRANCH in $TO_REMOVE; do
                echo "git branch --delete --force '$BRANCH'"
                git branch --delete --force "$BRANCH"
            done
            ;;
    esac
}


