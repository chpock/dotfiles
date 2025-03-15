#!/bin/bash

__INSTALL_VERSION="
  shellcheck    0.10.0
  awscli:aws    2.24.20
  kubectl       1.32.3
  dive          0.12.0
  gzip-portable 1.13
  jq            1.7.1
  k9s           0.40.8
  kdash         0.6.2
  kl            0.6.0
  ktop          0.3.7
  kube-capacity 0.8.0
  kubecolor     0.5.0
  mcfly         0.9.3
  tar-portable  1.35
  vim-portable  9.0.2094
  yq            4.45.1
  grpcurl       1.9.3
  yazi          25.3.2
  httptap       0.1.1
"

__install_httptap() {
    local VERSION="$1" EXECUTABLE="$2"

    if [ "$VERSION" = "-check" ]; then
        # httptap has no command line option to check its version. Thus, we will
        # only check for its presence.
        return 1
    elif [ "$VERSION" = "-latest" ]; then
        __install_get_latest_github "monasticacademy/httptap"
        return 0
    fi

    local FORMAT URL="https://github.com/monasticacademy/httptap/releases/download/v${VERSION}/httptap_"
    __install_make_url "
        linux-x64   linux_x86_64.tar.gz
    " && __install_download && __install_unpack &&  __install_bin || return $?
}

__install_yazi() {
    local VERSION="$1" EXECUTABLE="$2"

    if [ "$VERSION" = "-check" ]; then
        __install_check_version "$EXECUTABLE" --version \
            | awk '{print $2}'
        return 0
    elif [ "$VERSION" = "-latest" ]; then
        __install_get_latest_github "sxyazi/yazi"
        return 0
    fi

    local FORMAT URL="https://github.com/sxyazi/yazi/releases/download/v${VERSION}/yazi-"
    __install_make_url "
        linux-x64   x86_64-unknown-linux-gnu.zip
    " && __install_download && __install_unpack &&  __install_bin || return $?
}

__install_mcfly() {
    local VERSION="$1" EXECUTABLE="$2"

    if [ "$VERSION" = "-check" ]; then
        __install_check_version "$EXECUTABLE" --version \
            | awk '{print $NF}'
        return 0
    elif [ "$VERSION" = "-latest" ]; then
        __install_get_latest_github "cantino/mcfly"
        return 0
    fi

    local FORMAT URL="https://github.com/cantino/mcfly/releases/download/v${VERSION}/mcfly-v${VERSION}-"
    __install_make_url "
        linux-x64   x86_64-unknown-linux-musl.tar.gz
    " && __install_download && __install_unpack &&  __install_bin || return $?
}

__install_grpcurl() {
    local VERSION="$1" EXECUTABLE="$2"

    if [ "$VERSION" = "-check" ]; then
        __install_check_version -stderr "$EXECUTABLE" --version \
            | awk '{print $NF}' | tr -d 'v'
        return 0
    elif [ "$VERSION" = "-latest" ]; then
        __install_get_latest_github "fullstorydev/grpcurl"
        return 0
    fi

    local FORMAT URL="https://github.com/fullstorydev/grpcurl/releases/download/v${VERSION}/grpcurl_${VERSION}_"
    __install_make_url "
        linux-x64   linux_x86_64.tar.gz
    " && __install_download && __install_unpack &&  __install_bin || return $?
}

__install_kubecolor() {
    local VERSION="$1" EXECUTABLE="$2"

    if [ "$VERSION" = "-check" ]; then
        __install_check_version "$EXECUTABLE" --kubecolor-version
        return 0
    elif [ "$VERSION" = "-latest" ]; then
        __install_get_latest_github "kubecolor/kubecolor"
        return 0
    fi

    local FORMAT URL="https://github.com/kubecolor/kubecolor/releases/download/v${VERSION}/kubecolor_${VERSION}_"
    __install_make_url "
        linux-x64   linux_amd64.tar.gz
    " && __install_download && __install_unpack &&  __install_bin || return $?
}

__install_kube_capacity() {
    local VERSION="$1" EXECUTABLE="$2"

    if [ "$VERSION" = "-check" ]; then
        # Version number is broken in kube-capacity v0.8.0 and reports
        # version 0.7.4 instead. So, here we will only check for its presence.
        return 1
    elif [ "$VERSION" = "-latest" ]; then
        __install_get_latest_github "robscott/kube-capacity"
        return 0
    fi

    local FORMAT URL="https://github.com/robscott/kube-capacity/releases/download/v${VERSION}/kube-capacity_v${VERSION}_"
    __install_make_url "
        linux-x64   linux_x86_64.tar.gz
    " && __install_download && __install_unpack &&  __install_bin || return $?
}

__install_ktop() {
    local VERSION="$1" EXECUTABLE="$2"

    if [ "$VERSION" = "-check" ]; then
        # ktop has no command line option to check its version. Thus, we will
        # only check for its presence.
        return 1
    elif [ "$VERSION" = "-latest" ]; then
        __install_get_latest_github "vladimirvivien/ktop"
        return 0
    fi

    local FORMAT URL="https://github.com/vladimirvivien/ktop/releases/download/v${VERSION}/ktop_v${VERSION}_"
    __install_make_url "
        linux-x64   linux_amd64.tar.gz
    " && __install_download && __install_unpack &&  __install_bin || return $?
}

__install_kl() {
    local VERSION="$1" EXECUTABLE="$2"

    if [ "$VERSION" = "-check" ]; then
        __install_check_version "$EXECUTABLE" --version \
            | awk '{print $NF}' | tr -d 'v'
        return 0
    elif [ "$VERSION" = "-latest" ]; then
        __install_get_latest_github "robinovitch61/kl"
        return 0
    fi

    local FORMAT URL="https://github.com/robinovitch61/kl/releases/download/v${VERSION}/kl_${VERSION}_"
    __install_make_url "
        linux-x64   Linux_x86_64.tar.gz
    " && __install_download && __install_unpack &&  __install_bin || return $?
}

__install_kdash() {
    local VERSION="$1" EXECUTABLE="$2"

    if [ "$VERSION" = "-check" ]; then
        __install_check_version "$EXECUTABLE" --version \
            | awk '{print $NF}'
        return 0
    elif [ "$VERSION" = "-latest" ]; then
        __install_get_latest_github "kdash-rs/kdash"
        return 0
    fi

    local FORMAT URL="https://github.com/kdash-rs/kdash/releases/download/v${VERSION}/kdash-"
    __install_make_url "
        linux-x64   linux.tar.gz
    " && __install_download && __install_unpack &&  __install_bin || return $?
}

__install_k9s() {
    local VERSION="$1" EXECUTABLE="$2"

    if [ "$VERSION" = "-check" ]; then
        __install_check_version "$EXECUTABLE" version \
            | grep 'Version:' | awk '{print $2}' | tr -d 'v'
        return 0
    elif [ "$VERSION" = "-latest" ]; then
        __install_get_latest_github "derailed/k9s"
        return 0
    fi

    local FORMAT URL="https://github.com/derailed/k9s/releases/download/v${VERSION}/k9s_"
    __install_make_url "
        linux-x64   Linux_amd64.tar.gz
    " && __install_download && __install_unpack &&  __install_bin || return $?
}

__install_jq() {
    local VERSION="$1" EXECUTABLE="$2"

    if [ "$VERSION" = "-check" ]; then
        __install_check_version "$EXECUTABLE" --version \
            | cut -d- -f2
        return 0
    elif [ "$VERSION" = "-latest" ]; then
        __install_get_latest_github "jqlang/jq"
        return 0
    fi

    local URL="https://github.com/jqlang/jq/releases/download/jq-${VERSION}/jq-"
    __install_make_url -noformat "
        linux-x64   linux-amd64
    " && __install_download && __install_bin "archive" || return $?
}

__install_yq() {
    local VERSION="$1" EXECUTABLE="$2"

    if [ "$VERSION" = "-check" ]; then
        __install_check_version "$EXECUTABLE" --version \
            | awk '{print $NF}' | tr -d 'v'
        return 0
    elif [ "$VERSION" = "-latest" ]; then
        __install_get_latest_github "mikefarah/yq"
        return 0
    fi

    local URL="https://github.com/mikefarah/yq/releases/download/v${VERSION}/yq_"
    __install_make_url -noformat "
        linux-x64   linux_amd64
    " && __install_download && __install_bin "archive" || return $?
}

__install_gzip_portable() {
    local VERSION="$1" EXECUTABLE="$2"

    if [ "$VERSION" = "-check" ]; then
        __install_check_version "$EXECUTABLE" --portable-version
        return 0
    elif [ "$VERSION" = "-latest" ]; then
        echo "skip"
        return 0
    fi

    local VERSION_REPO="v0.0.0"
    local URL="https://github.com/chpock/dotfiles/releases/download/${VERSION_REPO}/gzip-portable.${VERSION}."
    __install_make_url -noformat "
        linux-x64   linux.x86_64
    " && __install_download && __install_bin "archive" || return $?
}

__install_tar_portable() {
    local VERSION="$1" EXECUTABLE="$2"

    if [ "$VERSION" = "-check" ]; then
        __install_check_version "$EXECUTABLE" --portable-version
        return 0
    elif [ "$VERSION" = "-latest" ]; then
        echo "skip"
        return 0
    fi

    local VERSION_REPO="v0.0.0"
    local URL="https://github.com/chpock/dotfiles/releases/download/${VERSION_REPO}/tar-portable.${VERSION}."
    __install_make_url -noformat "
        linux-x64   linux.x86_64
    " || return $?

    if _hasnot gzip; then
        ,install gzip-portable || return $?
    fi

    __install_download && __install_bin "archive" || return $?
}

__install_vim_portable() {
    local VERSION="$1" EXECUTABLE="$2"

    if [ "$VERSION" = "-check" ]; then
        __install_check_version "$EXECUTABLE" --portable-version \
            | tr -d 'v'
        return 0
    elif [ "$VERSION" = "-latest" ]; then
        echo "skip"
        return 0
    fi

    local VERSION_REPO="v0.0.0"
    local URL="https://github.com/chpock/dotfiles/releases/download/${VERSION_REPO}/vim-portable.v${VERSION}."
    __install_make_url -noformat "
        linux-x64   linux.x86_64
    " || return $?

    if _hasnot gzip; then
        ,install gzip-portable || return $?
    fi

    if _hasnot tar; then
        ,install tar-portable || return $?
    fi

    __install_download && __install_bin "archive" || return $?
}

__install_kubectl() {
    local VERSION="$1" EXECUTABLE="$2"

    if [ "$VERSION" = "-check" ]; then
        __install_check_version "$EXECUTABLE" version --client=true \
            | grep -F 'Client Version' | awk '{print $NF}' | tr -d 'v'
        return 0
    elif [ "$VERSION" = "-latest" ]; then
        geturl https://dl.k8s.io/release/stable.txt 2>/dev/null \
            | tr -d 'v'
        return 0
    fi

    local URL="https://dl.k8s.io/release/v${VERSION}/bin/"
    __install_make_url -noformat "
        linux-x64   linux/amd64/kubectl
    " || return $?

    __install_download && __install_bin "archive" || return $?
}

__install_awscli() {
    local VERSION="$1" EXECUTABLE="$2"

    if [ "$VERSION" = "-check" ]; then
        __install_check_version "$EXECUTABLE" --version \
            | aws --version | awk '{print $1}' | cut -d/ -f2
        return 0
    elif [ "$VERSION" = "-latest" ]; then
        geturl https://raw.githubusercontent.com/aws/aws-cli/v2/CHANGELOG.rst 2>/dev/null \
            | sed -n -e '/^===/{x;p;d;}' -e x | grep '^2\.' | head -n 1
        return 0
    fi

    local FORMAT URL="https://awscli.amazonaws.com/"
    __install_make_url "
        linux-x64 awscli-exe-linux-x86_64-${VERSION}.zip
    " && __install_download && __install_unpack || return $?

    if [ -e "/usr/local/bin/aws" ]; then
        echo "Updating ..." >&2
        sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update >/dev/null || return $?
    else
        echo "Installing ..." >&2
        sudo ./aws/install >/dev/null || return $?
    fi

    ln -sf /usr/local/bin/aws "$EXECUTABLE"
}


__install_dive() {
    local VERSION="$1" EXECUTABLE="$2"

    if [ "$VERSION" = "-check" ]; then
        __install_check_version "$EXECUTABLE" --version \
            | awk '{print $2}'
        return 0
    elif [ "$VERSION" = "-latest" ]; then
        __install_get_latest_github "wagoodman/dive"
        return 0
    fi

    local FORMAT URL="https://github.com/wagoodman/dive/releases/download/v${VERSION}/dive_${VERSION}_"
    __install_make_url "
        linux-x64   linux_amd64.tar.gz
        macos-x64   darwin_amd64.tar.gz
        windows-x64 windows_amd64.zip
    " && __install_download && __install_unpack &&  __install_bin || return $?
}


__install_shellcheck() {
    local VERSION="$1" EXECUTABLE="$2"

    if [ "$VERSION" = "-check" ]; then
        __install_check_version "$EXECUTABLE" --version \
            | grep "version:" | awk '{print $2}'
        return 0
    elif [ "$VERSION" = "-latest" ]; then
        __install_get_latest_github "koalaman/shellcheck"
        return 0
    fi

    local FORMAT URL="https://github.com/koalaman/shellcheck/releases/download/v${VERSION}/shellcheck-v${VERSION}."
    __install_make_url "
        linux-x64   linux.x86_64.tar.xz
        macos-x64   darwin.x86_64.tar.xz
        windows-x64 zip
    " && __install_download && __install_unpack &&  __install_bin || return $?
}

__install_bin() {
    local EXECUTABLE_BASE="${EXECUTABLE##*/}" EXECUTABLE_ORIGINAL="$1"
    echo "Installing as $EXECUTABLE ..." >&2
    if [ -z "$EXECUTABLE_ORIGINAL" ]; then
        if [ -f "$EXECUTABLE_BASE" ]; then
            EXECUTABLE_ORIGINAL="$EXECUTABLE_BASE"
        else
            EXECUTABLE_ORIGINAL="$(echo */"$EXECUTABLE_BASE")"
        fi
    fi
    if [ ! -f "$EXECUTABLE_ORIGINAL" ]; then
        echo "Error: could not find executable '$EXECUTABLE_ORIGINAL' in the archive"
        return 1
    fi
    mv -f "$EXECUTABLE_ORIGINAL" "$EXECUTABLE"
    chmod +x "$EXECUTABLE"
}

__install_unpack() {
    echo "Extracting the archive ..." >&2
    local R=0
    case "$FORMAT" in
        tar.gz) tar zxf archive || R=$? ;;
        tar.xz) xzcat archive | tar x || R=$? ;;
        zip)    unzip -qq archive || R=$? ;;
        *)
            echo "Error: unknown archive format '$FORMAT'" >&2
            R=1
            ;;
    esac
    [ $R -eq 0 ] || echo "Error: failed to extract" >&2
    return $R
}

__install_download() {
    echo "Downloading $TOOL version $VERSION ..." >&2
    if ! geturl "$URL" >archive; then
        echo "Error: failed to download tool '$TOOL'" >&2
        return 1
    fi
}

__install_make_url() {
    local CONDITION SUFFIX NO_FORMAT
    if [ "$1" = "-noformat" ]; then
        NO_FORMAT=1
        shift
    fi
    while read -r CONDITION SUFFIX FORMAT; do
        if [ -n "$CONDITION" ] &&  _is "$CONDITION"; then
            [ "$VERSION" != "-available" ] || return 251
            URL="$URL$SUFFIX"
            if [ -z "$NO_FORMAT" ]; then
                case "$URL" in
                    *.tar.gz|*.tgz) FORMAT="tar.gz" ;;
                    *.tar.xz)       FORMAT="tar.xz" ;;
                    *.zip)          FORMAT="zip" ;;
                    *)
                        echo "Error: unknown format of the final file in the URL: $URL" >&2
                        return 1
                        ;;
                esac
            fi
            return 0
        fi
    done < <(echo "$1")
    [ "$VERSION" = "-available" ] || echo "Error: tool '$TOOL' is not available for the current OS/architecture" >&2
    return 1
}

__install_check_version() {
    if [ "$1" = "-stderr" ]; then
        shift
        "$@" 2>&1 | tr -d '\r'
    else
        "$@" 2>/dev/null | tr -d '\r'
    fi
}

__install_get_latest_github() {
    # This is version that uses GitHub API. However, it has a limit for
    # unauthenticated users as only 60 requests per hour.
    #
    # geturl "https://api.github.com/repos/$1/releases/latest" 2>/dev/null \
    #     | grep -F '"tag_name":' | cut -d'"' -f4 | sed 's/^[^0-9]*//'
    geturl "https://github.com/$1/releases/latest" 2>/dev/null \
        | sed -n '/\/releases\/expanded_assets\// s#.*/releases/expanded_assets/[^0-9]*\([^"]*\).*#\1#p'
}

__install_check_new_versions() {
    local VERSION_LATEST
    local DISABLED TOOL VERSION EXECUTABLE
    while read -r DISABLED TOOL EXECUTABLE VERSION; do
        [ -n "$TOOL" ] || continue
        local TOOL_FUNC="__install_${TOOL//-/_}"
        printf "${COLOR_CYAN}%s ${COLOR_BLUE}v${COLOR_LIGHTBLUE}%s${COLOR_DEFAULT} ..." "$TOOL" "$VERSION"
        VERSION_LATEST="$("$TOOL_FUNC" -latest "$EXECUTABLE" || :)"
        printf '\b\b\b\b'"${COLOR_GRAY}:   "'\r\t\t\t'
        if [ -z "$VERSION_LATEST" ]; then
            echo "${COLOR_LIGHTRED}unknown error${COLOR_DEFAULT}"
        elif [ "$VERSION_LATEST" = "skip" ]; then
            echo "${COLOR_GREEN}OK ${COLOR_GRAY}(skipped)${COLOR_DEFAULT}"
        elif [ "$VERSION_LATEST" = "$VERSION" ]; then
            echo "${COLOR_GREEN}OK${COLOR_DEFAULT}"
        else
            echo "${COLOR_DEFAULT}update available, new version: ${COLOR_BROWN}v${COLOR_YELLOW}$VERSION_LATEST${COLOR_DEFAULT}"
        fi
    done < <(echo "$__INSTALL_VERSION_FILTERED" | sort)
}

_is_install_available() {
    local DISABLED TOOL VERSION EXECUTABLE
    while read -r DISABLED TOOL EXECUTABLE VERSION; do
        [ "$EXECUTABLE" = "$1" ] || continue
        return 0
    done < <(echo "$__INSTALL_VERSION_FILTERED")
    return 1
}

,install() {

    if [ -z "$1" ]; then
        echo "Available tools:"
        echo
        local TOOL
        for TOOL in $__INSTALL_AVAILABLE_TOOLS; do
            echo "  $TOOL"
        done | sort
        echo
        return
    elif [ "$1" = "-check" ]; then
        __install_check_new_versions
        return
    fi

    local V="__CACHE_INSTALL_${1//-/_}"
    #[ -z "${!V}" ] || return "${!V}"

    local R=0 DISABLED TOOL VERSION EXECUTABLE
    while read -r DISABLED TOOL EXECUTABLE VERSION; do
        # Check if the current tool is the tool that was requested on
        # the command line.
        if [ "$TOOL" = "$1" ]; then
            if [ "$DISABLED" != "0" ]; then
                echo "Error: tool '$1' is unavailable in current OS/architecture" >&2
                unset TOOL
            fi
            break
        fi
        unset TOOL DISABLED
    done < <(echo "$__INSTALL_VERSION_FILTERED")

    if [ -z "$TOOL" ]; then
        [ -n "$DISABLED" ] || echo "Error: tool '$1' is unknown" >&2
        R=1
    else

        local TOOL_FUNC="__install_${TOOL//-/_}"

        [ -n "$EXECUTABLE" ] || EXECUTABLE="$TOOL"
        EXECUTABLE="$IAM_HOME/tools/bin/$EXECUTABLE"
        _is windows && EXECUTABLE="${EXECUTABLE}.exe" || true

        local CHECK_VERSION
        if [ -x "$EXECUTABLE" ]; then
            if CHECK_VERSION="$("$TOOL_FUNC" -check "$EXECUTABLE")"; then
                if [ -n "$CHECK_VERSION" ] && [ "$CHECK_VERSION" != "$VERSION" ]; then
                    echo "The current $TOOL version '$CHECK_VERSION' does not match the desired version '$VERSION'" >&2
                fi
            else
                # If "__install_$TOOL -check" returns a non-zero exit code,
                # then the current tool cannot return its current version.
                # In this case, we just check that the executable exists
                # and ignore its version. To avoid reinstalling the tool below,
                # we set CHECK_VERSION as VERSION.
                CHECK_VERSION="$VERSION"
            fi
        fi

        if [ "$CHECK_VERSION" != "$VERSION" ]; then

            local TEMP_DIR="$(mktemp --directory)"
            (cd "$TEMP_DIR"; "$TOOL_FUNC" "$VERSION" "$EXECUTABLE") && R=0 || R=$?
            rm -rf "$TEMP_DIR"

        fi

    fi

    printf -v "$V" '%s' "$R"
    return "${!V}"

}

__install_complete() {
    COMPREPLY=()

    if [ $COMP_CWORD -lt 2 ]; then
        COMPREPLY=($(compgen -W "-check $__INSTALL_AVAILABLE_TOOLS" -- "${COMP_WORDS[1]}"))
        return
    fi
}

complete -F __install_complete ,install

unset __INSTALL_VERSION_FILTERED
unset __INSTALL_AVAILABLE_TOOLS
unset __INSTALL_AVAILABLE_EXECUTABLES
while read -r TOOL VERSION; do
    [ -n "$TOOL" ] || continue
    # Try extracting the executable name from the tool name by removing
    # all characters before the colon.
    EXECUTABLE="${TOOL#*:}"
    # If the executable file name is equal to the tool name, there
    # is no colon in the tool name. Otherwise, refine the tool name by
    # cutting off all characters after the colon.
    [ "$EXECUTABLE" = "$TOOL" ] || TOOL="${TOOL%%:*}"
    TOOL_FUNC="__install_${TOOL//-/_}"
    "$TOOL_FUNC" -available "$EXECUTABLE" && R=1 || R=$?
    # If "$TOOL_FUNC -available" returns 251, then the tool is available
    if [ $R -eq 251 ]; then
        if [ -n "$__INSTALL_AVAILABLE_TOOLS" ]; then
            __INSTALL_AVAILABLE_TOOLS="$__INSTALL_AVAILABLE_TOOLS $TOOL"
            __INSTALL_AVAILABLE_EXECUTABLES="$__INSTALL_AVAILABLE_EXECUTABLES $EXECUTABLE"
        else
            __INSTALL_AVAILABLE_TOOLS="$TOOL"
            __INSTALL_AVAILABLE_EXECUTABLES="$EXECUTABLE"
        fi
        _has_function "$EXECUTABLE" || eval "${EXECUTABLE}() {  _maybe_local \"\${FUNCNAME[0]}\"; env \"\${FUNCNAME[0]}\" \"\$@\"; }"
        R=0
    fi
    __INSTALL_VERSION_FILTERED="$R $TOOL $EXECUTABLE $VERSION
        $__INSTALL_VERSION_FILTERED"
done < <(echo "$__INSTALL_VERSION")
unset R TOOL VERSION EXECUTABLE TOOL_FUNC
unset __INSTALL_VERSION

# Define simple wrappers for tools

! _has_function "yazi" || yazi() {
    _maybe_local "yazi"
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    env YAZI_CONFIG_HOME="$IAM_HOME/yazi-config" yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

! _has_function "httptap" || httptap() {
    _maybe_local "httptap"
    local VAL VAR
    for VAR in \
        "kernel.apparmor_restrict_unprivileged_unconfined" \
        "kernel.apparmor_restrict_unprivileged_userns"
    do
        if VAL="$(sysctl -n "$VAR" 2>/dev/null)" && [ "$VAL" != "0" ]; then
            printf '%s\n' \
                "Error: $VAR = $VAL" \
                "" \
                "Execute to fix:" \
                "  sudo sysctl -w ${VAR}=0" \
                >&2
            return 1
        fi
    done
    env httptap "$@"
}

__INSTALL_FUNCTIONS_AVAILABLE=1


