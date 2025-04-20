#!/bin/bash

set -e

CURL_VERSION="8.13.0"
ZLIB_VERSION="1.3.1"
MBEDTLS_VERSION="3.6.3"

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

OUTPUT="$MY_HOME/curl-portable"
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

DIR_BUILD="/tmp/build"
DIR_INSTALL="/tmp/install"

MUSL_VERSION="1.2.4"

set -x

rm -f "$OUTPUT"*

apt-get update
apt-get install -y make gcc libtool curl bzip2 ca-certificates

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

curl --silent --fail -L "https://github.com/Mbed-TLS/mbedtls/releases/download/mbedtls-${MBEDTLS_VERSION}/mbedtls-${MBEDTLS_VERSION}.tar.bz2" | tar jx
cd mbedtls-*
make lib
MBEDTLS_ROOT="$(pwd)"

cd "$DIR_BUILD"

curl --silent --fail -L "https://zlib.net/zlib-${ZLIB_VERSION}.tar.gz" | tar zx
cd zlib-*
CFLAGS="-fPIC -O3" ./configure --prefix=$DIR_INSTALL --static
make -j8 install

cd "$DIR_BUILD"

curl --silent --fail -L "https://github.com/curl/curl/releases/download/curl-${CURL_VERSION//./_}/curl-${CURL_VERSION}.tar.bz2" | tar jx
cd curl-*
LDFLAGS="-static -Wl,--gc-sections -Wl,-Bsymbolic -Wl,-s -L${MBEDTLS_ROOT}/library" \
    CFLAGS="-Os -no-pie -fdata-sections -ffunction-sections -fno-unwind-tables -fno-asynchronous-unwind-tables -fno-record-gcc-switches -fno-plt" \
    CPPFLAGS="-I${MBEDTLS_ROOT}/include" \
    ./configure --prefix=$DIR_INSTALL/curl \
    --enable-static --disable-shared --disable-docs --disable-manual \
    --with-mbedtls --without-libpsl --disable-libcurl-option \
    --disable-alt-svc --disable-headers-api --disable-hsts --disable-progress-meter --disable-aws \
    --disable-negotiate-auth --disable-ntlm --disable-doh --disable-get-easy-options --disable-netrc \
    --disable-unix-sockets --disable-versioned-symbols --disable-verbose --disable-ipfs --disable-rtsp \
    --disable-dict --disable-file --disable-gopher --disable-gophers --disable-ftp --disable-ftps \
    --disable-imap --disable-imaps --disable-mqtt --disable-pop3 --disable-pop3s --disable-smtp \
    --disable-smtps --disable-telnet --disable-tftp \
    --with-ca-embed=/etc/ssl/certs/ca-certificates.crt \
    --without-ca-path --without-ca-fallback --without-ca-bundle \
    --with-zlib=$DIR_INSTALL
make -j8 install-strip

HASH="$(sha256sum -b "$DIR_INSTALL/curl/bin/curl" | awk '{print $1}')"

OUTPUT="${OUTPUT}.${CURL_VERSION}.${HASH}.${OS}.${ARCH}"

cp -f "$DIR_INSTALL/curl/bin/curl" "$OUTPUT"
chown ${EUID}:${EGID} "$OUTPUT"
chmod +x "$OUTPUT"
