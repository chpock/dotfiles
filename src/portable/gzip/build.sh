#!/bin/bash

set -e

GZIP_VERSION="1.13"

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

OUTPUT="$MY_HOME/gzip-portable"
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"
OUTPUT="${OUTPUT}.${GZIP_VERSION}.${OS}.${ARCH}"

DIR_BUILD="/tmp/build"
DIR_INSTALL="/tmp/install"

set -x

rm -f "$OUTPUT"

yum install -y make gcc libtool glibc-static

mkdir -p "$DIR_BUILD"
cd "$DIR_BUILD"

curl --silent --fail https://ftp.gnu.org/gnu/gzip/gzip-${GZIP_VERSION}.tar.gz | tar xz
cd gzip-*
LDFLAGS="-static-libgcc" ./configure --prefix=$DIR_INSTALL/gzip
make -j8
#make check
make install-strip

sed "s/!GZIP_VERSION!/$GZIP_VERSION/g" "$MY_HOME/stub.sh" > "$OUTPUT"
cat "$DIR_INSTALL/gzip/bin/gzip" >> "$OUTPUT"

chown ${EUID}:${EGID} "$OUTPUT"
chmod +x "$OUTPUT"
