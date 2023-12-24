#!/bin/bash

set -e

VIM_TAG="v9.0.2094"
NCURSES_VERSION="6.4"

BUILD_DOCKER_IMAGE="dokken/centos-6"
MY_HOME="$(cd "$(dirname "$0")"; pwd)"
MY_NAME="$(basename "$0")"

if [ ! -e /.dockerenv ]; then
    exec docker run --rm -ti \
        -w /tmp/work \
        -v "${MY_HOME}:/tmp/work" \
        -e EUID="$(id -u)" -e EGID="$(id -g)" \
        "$BUILD_DOCKER_IMAGE" \
        bash "/tmp/work/$MY_NAME"
fi

OUTPUT="$MY_HOME/vim-portable"
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"
OUTPUT="${OUTPUT}.${VIM_TAG}.${OS}.${ARCH}"

DIR_BUILD="/tmp/build"
DIR_INSTALL="/tmp/install"
DIR_DIST="/tmp/dist"

set -x

rm -f "$OUTPUT"

yum install -y git make gcc libtool glibc-static

mkdir -p "$DIR_BUILD"
cd "$DIR_BUILD"

curl --silent --fail https://ftp.gnu.org/gnu/ncurses/ncurses-${NCURSES_VERSION}.tar.gz | tar xz
cd ncurses-*
./configure --prefix=$DIR_INSTALL/ncurses --without-manpages --without-shared
make -j8
make install
cd "$DIR_BUILD"

git clone https://github.com/vim/vim.git
cd vim/src
git checkout "$VIM_TAG"
# gcc in cenos6 doesn't support -Wpedantic
sed -E -i 's/[[:space:]]+-Wpedantic//' libvterm/Makefile
LDFLAGS="-static -L$DIR_INSTALL/ncurses/lib" ./configure \
    --prefix=$DIR_INSTALL/vim \
    --enable-multibyte \
    --enable-terminal \
    --without-local-dir
make -j8
#make test
make installvimbin installrtbase

mkdir -p "$DIR_DIST"
cd "$DIR_DIST"
mv "$DIR_INSTALL/vim/bin/vim" .
mv "$DIR_INSTALL/vim/share/vim"/vim* ./vim-runtime
mv "$DIR_INSTALL/ncurses/share/terminfo" .

sed "s/!VIM_VERSION!/$VIM_TAG/g" "$MY_HOME/stub.sh" > "$OUTPUT"
tar zcf - * >> "$OUTPUT"

chown ${EUID}:${EGID} "$OUTPUT"
chmod +x "$OUTPUT"
