#!/bin/bash

BASEDIR=$1
PREFIX=$2
TARGET=$3
NPROC=$4

echo "[GCC Part 2 build info]"
echo "BASEDIR: $BASEDIR"
echo "PREFIX: $PREFIX"
echo "TARGET: $TARGET"

# Setup build directory
cd $BASEDIR/3rd/gcc/ && \
rm -rf build && \
mkdir build && \
cd build && \
../configure --target=$TARGET --prefix=$PREFIX --with-gnu-ld --with-gnu-as \
	--with-arch=armv7 \
	--build=x86_64-linux-gnu --host=$TARGET \
	--disable-bootstrap \
	--disable-libsanitizer \
	--disable-werror \
	--disable-libgomp \
	--disable-libitm \
	--disable-libquadmath \
	--disable-libssp --disable-libvtv \
	--disable-libcilkrts --disable-libatomic \
	--enable-shared --disable-nls --enable-multilib \
	--enable-languages=c,c++ && \
make -j$NPROC && \
make install && \
echo "GCC Part 2 built successfully" && \
exit 0

exit 1
