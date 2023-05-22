#!/bin/bash

BASEDIR=$1
PREFIX=$2
TARGET=$3
NPROC=$4

echo "[GCC P1 build info]"
echo "BASEDIR: $BASEDIR"
echo "PREFIX: $PREFIX"
echo "TARGET: $TARGET"

cd $BASEDIR/3rd/gcc && \

# Download pre reqs
contrib/download_prerequisites && \

# Create build directory
mkdir -p build && \
cd build && \

# Configure build
../configure --target=$TARGET --prefix=$PREFIX \
	--disable-bootstrap \
	--disable-shared --disable-nls --enable-multilib \
	--disable-threads \
	--with-newlib --without-headers \
	--enable-languages=c \
	--with-system-zlib \
	--disable-libgomp --disable-libitm --disable-libquadmath \
	--disable-libsanitizer --disable-libssp --disable-libvtv \
	--disable-libcilkrts --disable-libatomic && \

# Build and install
make -j$NPROC all-gcc all-target-libgcc && \
make install-gcc install-target-libgcc && \

echo "GCC Stage 1 compiler built successfully!" && \
exit 0

exit 1
