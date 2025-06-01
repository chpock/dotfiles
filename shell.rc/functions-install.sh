#!/bin/bash

__INSTALL_VERSION="
  shellcheck    0.10.0
  awscli:aws    2.24.26
  kubectl       1.32.3
  dive          0.12.0
  jq            1.7.1
  k9s           0.50.6
  kdash         0.6.2
  kl            0.6.0
  ktop          0.3.7
  kube-capacity 0.8.0
  kpexec        0.4.1
  kubecolor     0.5.0
  mcfly         0.9.3
  vim           9.0.2094
  yq            4.45.1
  grpcurl       1.9.3
  yazi          25.3.2
  httptap       0.1.1
  tracexec      0.12.0
  systemctl-tui 0.4.0
  kubectl-browse-pvc:kubectl-browse_pvc 1.2.0
  kubectl-whoami                        0.0.46
  kubectl-pod-lens:kubectl-pod_lens     0.3.1
  kubectl-node-shell:kubectl-node_shell 1.11.0
  7z            24.09
  moar          1.31.4 auto
  tar-portable  1.35
  gzip-portable 1.13
  xz-portable   5.6.4
  pdu           0.11.0
  cidr          2.2.0
  lnav          0.13.0-rc2
"

__install_lnav() {
    local VERSION="$1" EXECUTABLE="$2"

    if [ "$VERSION" = "-check" ]; then
        __install_check_version "$EXECUTABLE" -V \
            | awk '{print $NF}'
        return 0
    elif [ "$VERSION" = "-latest" ]; then
        __install_get_latest_github "tstack/lnav"
        return 0
    fi

    local FORMAT URL="https://github.com/tstack/lnav/releases/download/v${VERSION}/lnav-${VERSION}-"
    __install_make_url "
        linux-x64   linux-musl-x86_64.zip
    " && __install_download && __install_unpack &&  __install_bin || return $?
}

__install_cidr() {
    local VERSION="$1" EXECUTABLE="$2"

    if [ "$VERSION" = "-check" ]; then
        __install_check_version "$EXECUTABLE" --version \
            | awk '{print $NF}'
        return 0
    elif [ "$VERSION" = "-latest" ]; then
        __install_get_latest_github "bschaatsbergen/cidr"
        return 0
    fi

    local FORMAT URL="https://github.com/bschaatsbergen/cidr/releases/download/v${VERSION}/cidr_${VERSION}_"
    __install_make_url "
        linux-x64   linux_amd64.tar.gz
    " && __install_download && __install_unpack &&  __install_bin || return $?
}

__install_7z() {
    local VERSION="$1" EXECUTABLE="$2"

    if [ "$VERSION" = "-check" ]; then
        __install_check_version "$EXECUTABLE" \
            | grep '^7-Zip' | awk '{print $3}'
        return 0
    elif [ "$VERSION" = "-latest" ]; then
        __install_get_latest_github "ip7z/7zip"
        return 0
    fi

    local FORMAT URL="https://github.com/ip7z/7zip/releases/download/${VERSION}/7z${VERSION//./}-"
    __install_make_url "
        linux-x64   linux-x64.tar.xz
    " && __install_download && __install_unpack &&  __install_bin "7zzs" || return $?
}

__install_kubectl_node_shell() {
    local VERSION="$1" EXECUTABLE="$2"

    if [ "$VERSION" = "-check" ]; then
        __install_check_version "$EXECUTABLE" --version \
            | awk '{print $NF}'
        return 0
    elif [ "$VERSION" = "-latest" ]; then
        __install_get_latest_github "kvaps/kubectl-node-shell"
        return 0
    fi

    # This tool is a shell script and it is available for any platform
    [ "$VERSION" != "-available" ] || return 251

    local URL="https://github.com/kvaps/kubectl-node-shell/archive/refs/tags/v${VERSION}.tar.gz"
    local FORMAT="tar.gz"

    __install_download && __install_unpack &&  __install_bin || return $?
}

__install_kubectl_pod_lens() {
    local VERSION="$1" EXECUTABLE="$2"

    if [ "$VERSION" = "-check" ]; then
        # pod-lens has no command line option to check its version. Thus, we will
        # only check for its presence.
        return 1
    elif [ "$VERSION" = "-latest" ]; then
        __install_get_latest_github "sunny0826/kubectl-pod-lens"
        return 0
    fi

    local FORMAT URL="https://github.com/sunny0826/kubectl-pod-lens/releases/download/v${VERSION}/pod-lens_"
    __install_make_url "
        linux-x64   linux_amd64.tar.gz
    " && __install_download && __install_unpack &&  __install_bin "pod-lens" || return $?
}

__install_kubectl_whoami() {
    local VERSION="$1" EXECUTABLE="$2"

    if [ "$VERSION" = "-check" ]; then
        __install_check_version "$EXECUTABLE" --version
        return 0
    elif [ "$VERSION" = "-latest" ]; then
        __install_get_latest_github "rajatjindal/kubectl-whoami"
        return 0
    fi

    local FORMAT URL="https://github.com/rajatjindal/kubectl-whoami/releases/download/v${VERSION}/kubectl-whoami_v${VERSION}_"
    __install_make_url "
        linux-x64   linux_amd64.tar.gz
    " && __install_download && __install_unpack &&  __install_bin || return $?
}

__install_kubectl_browse_pvc() {
    local VERSION="$1" EXECUTABLE="$2"

    if [ "$VERSION" = "-check" ]; then
        __install_check_version "$EXECUTABLE" --version \
            | awk '{print $NF}' | tr -d 'v'
        return 0
    elif [ "$VERSION" = "-latest" ]; then
        __install_get_latest_github "clbx/kubectl-browse-pvc"
        return 0
    fi

    local FORMAT URL="https://github.com/clbx/kubectl-browse-pvc/releases/download/v${VERSION}/kubectl-browse-pvc-"
    __install_make_url "
        linux-x64   linux-x86_64.zip
    " && __install_download && __install_unpack &&  __install_bin "kubectl-browse-pvc" || return $?
}

__install_systemctl_tui() {
    local VERSION="$1" EXECUTABLE="$2"

    if [ "$VERSION" = "-check" ]; then
        __install_check_version "$EXECUTABLE" --version \
            | head -n 1 | awk '{print $NF}'
        return 0
    elif [ "$VERSION" = "-latest" ]; then
        __install_get_latest_github "rgwood/systemctl-tui"
        return 0
    fi

    local FORMAT URL="https://github.com/rgwood/systemctl-tui/releases/download/v${VERSION}/systemctl-tui-"
    __install_make_url "
        linux-x64   x86_64-unknown-linux-musl.tar.gz
    " && __install_download && __install_unpack &&  __install_bin || return $?
}

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

__install_tracexec() {
    local VERSION="$1" EXECUTABLE="$2"

    if [ "$VERSION" = "-check" ]; then
        __install_check_version "$EXECUTABLE" --version \
            | awk '{print $NF}'
        return 0
    elif [ "$VERSION" = "-latest" ]; then
        __install_get_latest_github "kxxt/tracexec"
        return 0
    fi

    local FORMAT URL="https://github.com/kxxt/tracexec/releases/download/v${VERSION}/tracexec-"
    __install_make_url "
        linux-x64   x86_64-unknown-linux-gnu.tar.gz
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

__install_kpexec() {
    local VERSION="$1" EXECUTABLE="$2"

    if [ "$VERSION" = "-check" ]; then
        __install_check_version "$EXECUTABLE" --version \
            | awk '{print $NF}' | tr -d 'v'
        return 1
    elif [ "$VERSION" = "-latest" ]; then
        __install_get_latest_github "ssup2/kpexec"
        return 0
    fi

    local FORMAT URL="https://github.com/ssup2/kpexec/releases/download/v${VERSION}/kpexec_v${VERSION}_"
    __install_make_url "
        linux-x64   Linux_amd64.tar.gz
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

__install_moar() {
    local VERSION="$1" EXECUTABLE="$2"

    if [ "$VERSION" = "-check" ]; then
        __install_check_version "$EXECUTABLE" --version \
            | tr -d 'v'
        return 0
    elif [ "$VERSION" = "-latest" ]; then
        __install_get_latest_github "walles/moar"
        return 0
    fi

    local URL="https://github.com/walles/moar/releases/download/v${VERSION}/moar-v${VERSION}-"
    __install_make_url -noformat "
        linux-x64   linux-amd64
    " && __install_download && __install_bin "archive" || return $?
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

__install_pdu() {
    local VERSION="$1" EXECUTABLE="$2"

    if [ "$VERSION" = "-check" ]; then
        __install_check_version "$EXECUTABLE" --version \
            | awk '{print $NF}'
        return 0
    elif [ "$VERSION" = "-latest" ]; then
        __install_get_latest_github "KSXGitHub/parallel-disk-usage"
        return 0
    fi

    local URL="https://github.com/KSXGitHub/parallel-disk-usage/releases/download/${VERSION}/pdu-"
    __install_make_url -noformat "
        linux-x64   x86_64-unknown-linux-gnu
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

__install_xz_portable() {
    local VERSION="$1" EXECUTABLE="$2"

    if [ "$VERSION" = "-check" ]; then
        __install_check_version "$EXECUTABLE" --version \
            | head -n 1 | awk '{print $NF}'
        return 0
    elif [ "$VERSION" = "-latest" ]; then
        echo "skip"
        return 0
    fi

    local VERSION_REPO="v0.0.0"
    local URL="https://github.com/chpock/dotfiles/releases/download/${VERSION_REPO}/xz-portable.${VERSION}."
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

__install_vim() {
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
        _get_url https://dl.k8s.io/release/stable.txt 2>/dev/null \
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
            | awk '{print $1}' | cut -d/ -f2
        return 0
    elif [ "$VERSION" = "-latest" ]; then
        _get_url https://raw.githubusercontent.com/aws/aws-cli/v2/CHANGELOG.rst 2>/dev/null \
            | sed -n -e '/^===/{x;p;d;}' -e x | grep '^2\.' | head -n 1
        return 0
    fi

    local FORMAT URL="https://awscli.amazonaws.com/"
    __install_make_url "
        linux-x64 awscli-exe-linux-x86_64-${VERSION}.zip
    " && __install_download && __install_unpack || return $?

    local BASE_EXE_DIRECTORY="${EXECUTABLE%/*}"
    ./aws/install --bin-dir "$BASE_EXE_DIRECTORY" --install-dir "$BASE_EXE_DIRECTORY/aws-cli-install" --update >/dev/null || return $?
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
        tar.gz)
            local GZIP="gzip" TAR="tar"
            if _hasnot gzip; then
                ,install gzip-portable
                GZIP="gzip-portable"
            fi
            if _hasnot tar; then
                ,install tar-portable
                GZIP="tar-portable"
            fi
            "$GZIP" -d < archive | "$TAR" x || R=$?
            ;;
        tar.xz)
            local XZ="xz" TAR="tar"
            if _hasnot "xz"; then
                ,install xz-portable && XZ="xz-portable"
            fi
            if _hasnot tar; then
                ,install tar-portable && GZIP="tar-portable"
            fi
            "$XZ" -d < archive | "$TAR" x || R=$?
            ;;
        zip)
            if _has unzip; then
                unzip -qq archive || R=$?
            else
                _maybe_local 7z
                7z x -y -bd -bsp0 -bso0 archive || R=$?
            fi
            ;;
        7z)
            _maybe_local 7z
            7z x -y -bd -bsp0 -bso0 archive || R=$?
            ;;
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
    if ! _get_url "$URL" >archive; then
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
                    *.7z)           FORMAT="7z" ;;
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
    # _get_url "https://api.github.com/repos/$1/releases/latest" 2>/dev/null \
    #     | grep -F '"tag_name":' | cut -d'"' -f4 | sed 's/^[^0-9]*//'
    _get_url "https://github.com/$1/releases/latest" 2>/dev/null \
        | sed -n '/\/releases\/expanded_assets\// s#.*/releases/expanded_assets/[^0-9]*\([^"]*\).*#\1#p'
}

__install_check_new_versions() {
    local VERSION_LATEST
    local DISABLED TOOL VERSION EXECUTABLE
    while read -r DISABLED TOOL EXECUTABLE VERSION; do
        [ -n "$TOOL" ] || continue
        local TOOL_FUNC="__install_${TOOL//-/_}"
        cprintf -n '~c~%s ~b~v~B~%s ~d~...' "$TOOL" "$VERSION"
        VERSION_LATEST="$("$TOOL_FUNC" -latest "$EXECUTABLE" || :)"
        cprintf -n '\b\b\b\b~K~:   \r\t\t\t\t\t'
        if [ -z "$VERSION_LATEST" ]; then
            cprintf '~R~unknown error'
        elif [ "$VERSION_LATEST" = "skip" ]; then
            cprintf '~g~OK ~K~(skipped)'
        elif [ "$VERSION_LATEST" = "$VERSION" ]; then
            cprintf '~g~OK'
        else
            cprintf "update available, new version: ~y~v~Y~%s" "$VERSION_LATEST"
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

    local BY_EXECUTABLE=""
    if [ "$1" = "-executable" ]; then
        BY_EXECUTABLE=1
        shift
    fi

    local TOOL
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
    elif [ $# -gt 1 ]; then
        for TOOL; do
            ,install "$TOOL" || return $?
        done
        return
    fi

    local V="__CACHE_INSTALL_${1//-/_}"
    # for debug
    #[ -z "${!V}" ] || return "${!V}"

    local R=1 DISABLED=1 VERSION EXECUTABLE
    while read -r DISABLED TOOL EXECUTABLE VERSION; do

        # Check if the current tool is the tool that was requested on
        # the command line.
        if [ -n "$BY_EXECUTABLE" ]; then
            [ "$EXECUTABLE" != "$1" ] || R=0
        else
            [ "$TOOL" != "$1" ] || R=0
        fi

        # continue if R is not 0
        [ "$R" -eq 0 ] || continue

        # if the tool is disabled, then unset DISABLE variable as a flag
        if [ "$DISABLED" != "0" ]; then
            echo "Error: tool '$1' is unavailable in current OS/architecture" >&2
            unset DISABLED
            R=1
        fi
        break

    done < <(echo "$__INSTALL_VERSION_FILTERED")

    if [ $R -eq 1 ]; then
        # if disable does not exist, then we have already printed the error message
        [ -z "$DISABLED" ] || echo "Error: tool '$1' is unknown" >&2
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

            # don't use '--directory' parameter here as it is not suppurted by busybox
            local TEMP_DIR="$(mktemp -d)"
            (cd "$TEMP_DIR"; "$TOOL_FUNC" "$VERSION" "$EXECUTABLE") || R=$?
            rm -rf "$TEMP_DIR"

        fi

    fi

    printf -v "$V" '%s' "$R"
    return "${!V}"

}

__install_complete() {
    COMPREPLY=()

    if [ $COMP_CWORD -lt 2 ]; then
        COMPREPLY=($(compgen -W "-check $__INSTALL_AVAILABLE_TOOLS" -- "${COMP_WORDS[COMP_CWORD]}"))
    else
        COMPREPLY=($(compgen -W "$__INSTALL_AVAILABLE_TOOLS" -- "${COMP_WORDS[COMP_CWORD]}"))
    fi
}

complete -F __install_complete ,install

unset __INSTALL_VERSION_FILTERED
unset __INSTALL_AVAILABLE_TOOLS
unset __INSTALL_AVAILABLE_EXECUTABLES
unset __INSTALL_AUTO
while read -r TOOL VERSION OPTIONS; do
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
        if [ "$OPTIONS" = "auto" ]; then
            if [ -n "$__INSTALL_AUTO" ]; then
                __INSTALL_AUTO="$__INSTALL_AUTO $TOOL"
            else
                __INSTALL_AUTO="$TOOL"
            fi
        fi
        _has_function "$EXECUTABLE" || eval "${EXECUTABLE}() {  _maybe_local \"\${FUNCNAME[0]}\"; env \"\${FUNCNAME[0]}\" \"\$@\"; }"
        R=0
    fi
    __INSTALL_VERSION_FILTERED="$R $TOOL $EXECUTABLE $VERSION
        $__INSTALL_VERSION_FILTERED"
done < <(echo "$__INSTALL_VERSION")
unset R TOOL VERSION OPTIONS EXECUTABLE TOOL_FUNC
unset __INSTALL_VERSION

if [ -n "$__INSTALL_AUTO" ]; then
    # Install update auto-install tools
    ,install $__INSTALL_AUTO >/dev/null 2>&1 &
    disown $!
    unset __INSTALL_AUTO
fi

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

! _has_function "systemctl-tui" || systemctl-tui() {
    _maybe_local "systemctl-tui"
    sudo "$IAM_HOME/tools/bin/systemctl-tui" "$@"
}

! _has_function "pdu" || pdu() {
    _maybe_local "pdu"
    command pdu --progress --top-down --max-depth 2 "$@"
}

__INSTALL_FUNCTIONS_AVAILABLE=1

