#!/bin/bash

set -e

BASH_VERSION="5.2.21"

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

OUTPUT="$MY_HOME/bash-portable"
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"
OUTPUT="${OUTPUT}.${BASH_VERSION}.${OS}.${ARCH}"

DIR_BUILD="/tmp/build"
DIR_INSTALL="/tmp/install"

MUSL_VERSION="1.2.4"

set -x

rm -f "$OUTPUT"

yum install -y make gcc bison libtool

mkdir -p "$DIR_BUILD"
cd "$DIR_BUILD"


curl --silent --fail https://musl.libc.org/releases/musl-${MUSL_VERSION}.tar.gz | tar xz
cd musl-*
./configure --prefix=$DIR_INSTALL/musl --disable-shared
make -j8
make install

cd "$DIR_BUILD"

curl --silent --fail https://ftp.gnu.org/gnu/bash/bash-${BASH_VERSION}.tar.gz | tar xz
cd bash-*
# known bug for bash&musl: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1023053
sed -i -E 's/(if test \$bash_cv_func_strtoimax = )yes/\1no/' configure
CC=$DIR_INSTALL/musl/bin/musl-gcc LDFLAGS="-static" ./configure --prefix=$DIR_INSTALL/bash --without-bash-malloc
make -j8
make tests
# make install-strip
# I don't need anything other than bash executable. Also loadable builtins are failed with:
#
# /tmp/install/musl/bin/musl-gcc -std=gnu99 -shared -Wl,-soname,print -static -L./lib/termcap  -o print print.o
# /usr/bin/ld: /tmp/install/musl/lib/libc.a(free.o): relocation R_X86_64_32S against `__malloc_size_classes' can not be used when making a shared object; recompile with -fPIC
# /tmp/install/musl/lib/libc.a: could not read symbols: Bad value
#
# so, just copy the needed executable to expected location.
mkdir -p $DIR_INSTALL/bash/bin
install -c -s -m 0755 bash /tmp/install/bash/bin/bash

cp -f "$DIR_INSTALL/bash/bin/bash" "$OUTPUT"
chown ${EUID}:${EGID} "$OUTPUT"
chmod +x "$OUTPUT"
