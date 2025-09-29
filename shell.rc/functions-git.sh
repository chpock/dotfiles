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

_is_yadm() {
    # Return false if yadm is not installed or yadm git repo is not found
    _has yadm && [ -d "$HOME"/.local/share/yadm/repo.git ] || return 1
    # yadm is active only in $HOME, ~/.config and ~/.local
    case "$PWD" in
        "$HOME") :;;
        "$HOME"/.config|"$HOME"/.config/*) :;;
        "$HOME"/.local|"$HOME"/.local/*) :;;
        *) return 1;;
    esac
    return 0
}

git() {

    if _is_yadm; then
        yadm "$@"
        return $?
    fi

    GIT_BIN="$(which git)"
    if [ "commit" = "$1" ]; then
        # don't do anything if we are in a merge conflict state
        # https://stackoverflow.com/a/55192451
        if ! command git rev-parse -q --verify MERGE_HEAD >/dev/null 2>&1; then
            local REMOTE_BRANCH
            # if we have upstream branch
            if REMOTE_BRANCH=$(command git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>&1); then
                echo "The remove branch has been detected: '$REMOTE_BRANCH'"
                # When we run "git stash", the current directory may be new,
                # and the files in it may be in the list of changes.
                # In this case, it will be deleted and later restored
                # by "git stash pop". However, 'git pull ...' will fail as
                # the current directory doesn't exist. To avoid this, we will
                # change the current directory to the git repository root.
                # We will run commands in subshell to automatically restore
                # the current directory.
                local SAFE_PWD
                SAFE_PWD="$(command git rev-parse --show-toplevel 2>/dev/null)"
                (
                    SAFE_PWD="$(command git rev-parse --show-toplevel 2>/dev/null)" && cd "$SAFE_PWD"
                    set -x
                    "$GIT_BIN" stash && "$GIT_BIN" pull --ff-only -f && "$GIT_BIN" stash pop --index --quiet
                ) || return $?
                # Refresh the current directory, as it may be deleted and
                # restored. In this case, we are currently in a zombie
                # directory.
                cd "$PWD" || :
            fi
        fi
    elif [ "pull" = "$1" ]; then
        if ! command git rev-parse --abbrev-ref --symbolic-full-name '@{u}' >/dev/null 2>&1; then
            _warn 'There is no tracking information for the current branch. It will be set.'
            local BRANCH
            BRANCH="$(command git rev-parse --abbrev-ref HEAD)"
            (set -x; "$GIT_BIN" branch "--set-upstream-to=origin/$BRANCH" "$BRANCH")
        fi
    fi
    command git "$@"
}

,git() {
    case "$1" in
        config)
            local GIT_BIN GIT_AUTHOR SIGN_KEY
            GIT_BIN="$(which git)"
            if [ "$2" = "-global" ]; then
                GIT_AUTHOR="$3"
                set -- "$GIT_BIN" config
            else
                GIT_AUTHOR="$2"
                if _is_yadm; then
                    set -- yadm config
                else
                    set -- "$GIT_BIN" config --local
                fi
            fi
            if [ -z "$GIT_AUTHOR" ]; then
                GIT_AUTHOR="$_GIT_USER_EMAIL"
            fi
            # always enable: git commit -v
            (set -x; "$@" commit.verbose true)
            # sort branches by commit date
            (set -x; "$@" branch.sort -committerdate)
            # sort tags by version (the most recent tags are listed first)
            (set -x; "$@" tag.sort -version:refname)
            # use better diff algorithm by default
            (set -x; "$@" diff.algorithm histogram)
            #  no more 'git push origin HEAD', 'git push' will work everywhere!
            (set -x; "$@" push.autoSetupRemote true)
            # enable automatic repository maintenance in background
            (set -x; "$@" maintenance.auto true)
            (set -x; "$@" maintenance.strategy incremental)
            # set author
            (set -x; "$@" user.name "$_GIT_USER_NAME")
            (set -x; "$@" user.email "$GIT_AUTHOR")
            if ! SIGN_KEY="$(set +e; LC_ALL=C gpg --with-colons --list-secret-keys "$GIT_AUTHOR" 2>/dev/null | cut -d: -f5 | head -n 1)"; then
                echo "WARNING: gpg error: $SIGN_KEY"
                (set -x; "$@" commit.gpgsign false)
            elif [ -z "$SIGN_KEY" ]; then
                echo "WARNING: gpg key for '$GIT_AUTHOR' not found!"
                (set -x; "$@" commit.gpgsign false)
            else
                (set -x; "$@" user.signingkey "$SIGN_KEY")
                (set -x; "$@" commit.gpgsign true)
            fi
            ;;
        cleanup)
            local TO_REMOVE ASK BRANCH GIT_BIN

            _is_yadm && GIT_BIN="yadm" || GIT_BIN="$(which git)"
            # Update remote and cleanup branches that don't exist in remote
            echo "Fetching remote..."
            "$GIT_BIN" fetch --all --prune

            echo "Checking branches..."
            while read -r BRANCH; do
                # skip branches: master, + (worktree), * (current)
                if [ "$BRANCH" = 'master' ] || [ "$BRANCH" = '+' ] || [ "$BRANCH" = '*' ]; then
                    continue
                fi
                if [ -n "$("$GIT_BIN" ls-remote --heads origin "$BRANCH")" ]; then
                    echo "KEEP: $BRANCH"
                else
                    TO_REMOVE="$TO_REMOVE $BRANCH"
                fi
            done < <("$GIT_BIN" branch --list | awk '{print $1}')

            echo "Branches to delete:$TO_REMOVE"

            read -r -p "Do you wish to delete these branches [y/n]? " ASK

            case $ASK in
                [Yy]* )
                    for BRANCH in $TO_REMOVE; do
                        echo "$GIT_BIN branch --delete --force '$BRANCH'"
                        "$GIT_BIN" branch --delete --force "$BRANCH"
                    done
                    ;;
            esac
            ;;
        *)
            echo "Unknown command: '$1'"
            return 1
            ;;
    esac
}

__,git() {

    if [ "$1" = "--install-completion" ]; then
        complete -F __,git ,git
        return
    fi

    local CUR="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=()

    if [ "$COMP_CWORD" -eq 1 ]; then
        # Disable: Prefer mapfile or read -a to split command output (or quote to avoid splitting). [SC2207]
        # shellcheck disable=SC2207
        COMPREPLY=($(compgen -W "config cleanup" -- "$CUR"))
        return
    fi

    local CMD="${COMP_WORDS[1]}"

    case "$CMD" in
        config)
            if [ "$COMP_CWORD" -eq 2 ]; then
                # Disable: Prefer mapfile or read -a to split command output (or quote to avoid splitting). [SC2207]
                # shellcheck disable=SC2207
                COMPREPLY=($(compgen -W "-global" -- "$CUR"))
            fi
            ;;
    esac

    return

}

__,git --install-completion

# based on: https://github.com/magicmonty/bash-git-prompt
__git_status() {

    set -- command git

    local GIT_STATUS IS_YADM=''
    # Check if current directory is a git repository
    if _check _vercomp 1.8.0 '<' "$__GIT_VERSION"; then
        GIT_STATUS="$(LC_ALL=C "$@" status --porcelain 2>/dev/null)" || GIT_STATUS="!ERROR!"
    else
        GIT_STATUS="$(LC_ALL=C "$@" status --porcelain --branch 2>/dev/null)" || GIT_STATUS="!ERROR!"
    fi

    if [ "$GIT_STATUS" = "!ERROR!" ]; then
        _is_yadm || return 0
        set -- "$@" --git-dir="$HOME"/.local/share/yadm/repo.git --work-tree="$HOME"
        # Return if yadm returns an error
        GIT_STATUS="$(LC_ALL=C "$@" status --porcelain --branch 2>/dev/null)" || return 0
        IS_YADM=1
    fi

    # run only once per session
    _check _git-config-check

    # check configuration only once per session
    if _once "git check core.autocrlf in $PWD"; then
        if [ "$(LC_ALL=C "$@" config --get core.autocrlf)" != "false" ]; then
            "$@" config core.autocrlf false
        fi
    fi

    local MSG TMP_VAL


    local GIT_BRANCH="!ERROR!" GIT_NUM_STAGED=0 GIT_NUM_CHANGED=0 GIT_NUM_CONFLICT=0 GIT_NUM_UNTRACKED=0

    local line status
    while IFS='' read -r line || [ -n "$line" ]; do
        status="${line:0:2}"
        while [ -n "$status" ]; do
            case "$status" in
                \#\#) GIT_BRANCH="${line/\.\.\./^}"; break ;;
                \?\?) ((GIT_NUM_UNTRACKED++)); break ;;
                U?) ((GIT_NUM_CONFLICT++)); break;;
                ?U) ((GIT_NUM_CONFLICT++)); break;;
                DD) ((GIT_NUM_CONFLICT++)); break;;
                AA) ((GIT_NUM_CONFLICT++)); break;;
                ?M) ((GIT_NUM_CHANGED++)) ;;
                ?D) ((GIT_NUM_CHANGED++)) ;;
                ?\ ) ;;
                U) ((GIT_NUM_CONFLICT++)) ;;
                \ ) ;;
                *) ((GIT_NUM_STAGED++)) ;;
            esac
            status=${status:0:(${#status}-1)}
        done
    done <<< "$GIT_STATUS"

    if [ "$GIT_BRANCH" = "!ERROR!" ]; then
        if TMP_VAL="$("$@" rev-parse --abbrev-ref HEAD 2>/dev/null)"; then
            GIT_BRANCH="$TMP_VAL"
        fi
    fi

    local GIT_BRANCH_FIELDS
    IFS="^" read -ra GIT_BRANCH_FIELDS <<< "${GIT_BRANCH/\#\# }"
    GIT_BRANCH="${GIT_BRANCH_FIELDS[0]}"

    if [ -z "$IS_YADM" ]; then

        local GIT_REPO_ROOT
        GIT_REPO_ROOT="$("$@" rev-parse --git-dir 2>/dev/null)"
        if [ "$GIT_REPO_ROOT" = ".git" ]; then
            GIT_REPO_ROOT="$PWD"
        else
            _dirname -v GIT_REPO_ROOT -- "$GIT_REPO_ROOT"
        fi

        _homify -v GIT_REPO_ROOT "$GIT_REPO_ROOT"
        cprintf -v MSG '~K~[~W~GIT~K~: ~c~%s' "$GIT_REPO_ROOT"

        local IS_IN_SUBMODULE
        # try to detect if we are inside submodule. This command may fail
        # on old git version.
        if TMP_VAL="$("$@" rev-parse --show-superproject-working-tree 2>/dev/null)"; then
            # the command didn't fail
            [ -z "$TMP_VAL" ] || IS_IN_SUBMODULE=1
        else
            # try another method
            [ "${GIT_REPO_ROOT%*/.git/modules}" == "$GIT_REPO_ROOT" ] || IS_IN_SUBMODULE=1
        fi

        [ -z "$IS_IN_SUBMODULE" ] \
            || cprintf -A MSG '~K~(~d~submodule~K~)'

        cprintf -a MSG '~K~; ~d~branch~K~: ~m~%s' "$GIT_BRANCH"

        if [ "$GIT_BRANCH" != "HEAD" ]; then
            if ! "$@" show-ref --verify "refs/remotes/origin/$GIT_BRANCH" >/dev/null 2>&1; then
                cprintf -A MSG '~K~(~y~local only~K~)'
            elif ! TMP_VAL="$("$@" rev-list --count "${GIT_BRANCH}..origin/${GIT_BRANCH}" 2>&1)"; then
                cprintf -A MSG '~K~(~R~ERROR~K~: ~d~%s~K~)' "$TMP_VAL"
            elif [ "$TMP_VAL" != "0" ]; then
                cprintf -A MSG '~K~(~r~needs push force~K~)'
            elif ! TMP_VAL="$("$@" rev-list --count "origin/${GIT_BRANCH}..${GIT_BRANCH}" 2>&1)"; then
                cprintf -A MSG '~K~(~R~ERROR~K~: ~d~%s~K~)' "$TMP_VAL"
            elif [ "$TMP_VAL" = "1" ]; then
                cprintf -A MSG '~K~(~y~%s commit ahead remote~K~)' "$TMP_VAL"
            elif [ "$TMP_VAL" != "0" ]; then
                cprintf -A MSG '~K~(~y~%s commits ahead remote~K~)' "$TMP_VAL"
            fi
        fi

    else
        cprintf -v MSG '~K~[~W~YDM~K~: ~d~branch~K~: ~m~%s' "$GIT_BRANCH"
    fi

    local GIT_TAG
    if GIT_TAG="$("$@" describe --exact-match --tags "$("$@" rev-parse HEAD)" 2>/dev/null)"; then
        cprintf -a MSG '~K~; ~d~tag~K~: ~m~%s' "$GIT_TAG"
    fi

    [ "$GIT_NUM_CONFLICT" -eq 0 ] \
        || cprintf -a MSG '~K~; ~R~conflict~K~: ~d~%i' "$GIT_NUM_CONFLICT"

    [ "$GIT_NUM_STAGED" -eq 0 ] \
        || cprintf -a MSG '~K~; ~g~staged~K~: ~d~%i' "$GIT_NUM_STAGED"

    [ "$GIT_NUM_CHANGED" -eq 0 ] \
        || cprintf -a MSG '~K~; ~y~changed~K~: ~d~%i' "$GIT_NUM_CHANGED"

    [ "$GIT_NUM_UNTRACKED" -eq 0 ] \
        || cprintf -a MSG '~K~; ~d~untracked~K~: ~R~%i' "$GIT_NUM_UNTRACKED"

    cprintf -a MSG '~K~]'

    # other options

    cprintf -A MSG '~K~[~d~sign~K~:'

    local GIT_SIGN
    if TMP_VAL="$("$@" config --local --get commit.gpgsign 2>/dev/null)"; then
        if [ "$TMP_VAL" = "true" ]; then
            cprintf -a MSG '~g~true'
            GIT_SIGN=1
        else
            cprintf -a MSG '~r~%s' "$TMP_VAL"
        fi
    elif ! TMP_VAL="$("$@" config --get commit.gpgsign 2>/dev/null)"; then
        cprintf -a MSG '~R~undef'
    elif [ "$TMP_VAL" = "true" ]; then
        cprintf -a MSG '~g~true~K~(~d~G~K~)'
        GIT_SIGN=1
    else
        cprintf -a MSG '~r~%s~K~(~d~G~K~)' "$TMP_VAL"
    fi

    local GIT_AUTHOR_EMAIL

    # don't check for author in submodules
    if [ -z "$IS_IN_SUBMODULE" ]; then

        cprintf -a MSG '~K~; ~d~author~K~:'

        if TMP_VAL="$(LC_ALL=C "$@" config --local --get user.email 2>/dev/null)"; then
            GIT_AUTHOR_EMAIL="$TMP_VAL"
            if [ "$GIT_AUTHOR_EMAIL" = "$_GIT_USER_EMAIL" ]; then
                cprintf -a MSG '~g~ON'
            else
                cprintf -a MSG '~y~%s' "$GIT_AUTHOR_EMAIL"
            fi
        elif ! TMP_VAL="$(LC_ALL=C "$@" config --get user.email 2>/dev/null)"; then
            cprintf -a MSG '~R~undef'
        else
            GIT_AUTHOR_EMAIL="$TMP_VAL"
            if [ "$GIT_AUTHOR_EMAIL" = "$_GIT_USER_EMAIL" ]; then
                cprintf -a MSG '~g~ON'
            else
                cprintf -a MSG '~y~%s' "$GIT_AUTHOR_EMAIL"
            fi
            cprintf -a MSG '~K~(~d~G~K~)'
        fi

    fi

    local GIT_SIGN_KEY

    if [ -n "$GIT_SIGN" ] && [ -n "$GIT_AUTHOR_EMAIL" ]; then

        cprintf -a MSG '~K~; ~d~gpg~K~:'

        if ! _has gpg; then
            cprintf -a MSG '~R~unavailable'
        else
            if TMP_VAL="$(LC_ALL=C "$@" config --local --get user.signingkey 2>/dev/null)"; then
                GIT_SIGN_KEY="$TMP_VAL"
            elif TMP_VAL="$(LC_ALL=C "$@" config --get user.signingkey 2>/dev/null)"; then
                GIT_SIGN_KEY="$TMP_VAL"
            fi

            if [ -z "$GIT_SIGN_KEY" ]; then
                cprintf -a MSG '~R~not set'
            elif ! TMP_VAL="$(LC_ALL=C gpg --list-secret-keys "$GIT_SIGN_KEY" 2>/dev/null)"; then
                cprintf -a MSG "~r~no key '%s'" "$GIT_SIGN_KEY"
            else
                if ! TMP_VAL="$(LC_ALL=C gpg --with-colons --list-secret-keys "$GIT_AUTHOR_EMAIL" 2>/dev/null | cut -d: -f5 | head -n 1)"; then
                    cprintf -a MSG "~r~wrong key, no key for '%s'" "$GIT_AUTHOR_EMAIL"
                elif [ "$TMP_VAL" != "$GIT_SIGN_KEY" ]; then
                    cprintf -a MSG "~r~wrong key, set: %s; expected: '%s'" "$GIT_SIGN_KEY" "$TMP_VAL"
                else
                    cprintf -a MSG "~g~ON"
                fi
            fi
        fi

    fi

    cprintf -a MSG "~K~]"

    _ps1_show_status "$MSG"

}

