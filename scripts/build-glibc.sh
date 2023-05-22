#!/bin/bash

BASEDIR=$1
PREFIX=$2
TARGET=$3
NPROC=$4

echo "[GLIBC build info]"
echo "BASEDIR: $BASEDIR"
echo "PREFIX: $PREFIX"
echo "TARGET: $TARGET"

cd $BASEDIR/3rd/glibc && \

# Create build directory
mkdir -p build && \
cd build && \

# Configure build
../configure --target=$TARGET --prefix=$PREFIX \
	--build=x86_64-linux-gnu \
	--with-gnu-ld --with-gnu-as \
	libc_cv_forced_unwind=yes libc_cv_c_cleanup=yes \
	libc_cv_gnu89_inline=yes \
	libc_cv_ssp=no \
	--without-cvs \
	--disable-nls \
	--disable-sanity-checks \
	--enable-obsolete-rpc \
	--disable-profile \
	--disable-debug \
	--without-selinux \
	--with-tls \
	--enable-hacker-mode \
	--with-headers=$PREFIX/include && \

# Build and install
make -j$NPROC && \
make install && \

echo "GLIBC has built successfully!" && \
exit 0

exit 1
