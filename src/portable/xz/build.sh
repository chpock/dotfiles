#!/bin/bash

set -e

XZ_VERSION="5.6.4"

BUILD_DOCKER_IMAGE="ubuntu:noble"
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

OUTPUT="$MY_HOME/xz-portable"
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"
OUTPUT="${OUTPUT}.${XZ_VERSION}.${OS}.${ARCH}"

DIR_BUILD="/tmp/build"
DIR_INSTALL="/tmp/install"

MUSL_VERSION="1.2.4"

set -x

rm -f "$OUTPUT"

apt-get update
apt-get install -y make gcc libtool curl

mkdir -p "$DIR_BUILD"
cd "$DIR_BUILD"

curl --silent --fail https://musl.libc.org/releases/musl-${MUSL_VERSION}.tar.gz | tar xz
cd musl-*
./configure --prefix=$DIR_INSTALL/musl --disable-shared
make -j8
make install

CC=$DIR_INSTALL/musl/bin/musl-gcc
export CC

cd "$DIR_BUILD"

curl -L --silent --fail https://github.com/tukaani-project/xz/releases/download/v${XZ_VERSION}/xz-${XZ_VERSION}.tar.gz | tar xz
cd xz-*
CFLAGS="-no-pie" LDFLAGS="-static" ./configure --prefix=$DIR_INSTALL/xz --enable-small \
    --disable-microlzma \
    --disable-lzmadec --disable-lzmainfo --disable-lzma-links --disable-scripts --disable-doc \
    --disable-shared --enable-static \
    --disable-nls --disable-rpath
make -j8
#make check
make install-strip

cp -f "$DIR_INSTALL/xz/bin/xz" "$OUTPUT"
chown ${EUID}:${EGID} "$OUTPUT"
chmod +x "$OUTPUT"
