#!/bin/bash

BASEDIR=$1
PREFIX=$2
TARGET=$3
NPROC=$4
HOST=$5
HEADERS=$7

if [[ "$6" != "x86_64" ]]; then
    ARCH=--with-arch=$6 
    ZLIB=
else
    ARCH=
    ZLIB=--with-system-zlib
fi

echo "[GLIBC build info]"
echo "BASEDIR: $BASEDIR"
echo "PREFIX: $PREFIX"
echo "TARGET: $TARGET"

cd $BASEDIR/3rd/glibc && \

# Create build directory
mkdir -p build && \
cd build

# Configure build
../configure --prefix=$PREFIX/usr \
	--host=$HOST --build=x86_64-linux-gnu \
	$ARCH $ZLIB \
	--disable-werror \
	--with-gnu-ld --with-gnu-as \
	CFLAGS="-O2 -DBOOTSTRAP_GCC" \
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
	--with-headers=$HEADERS

if [[ $? != 0 ]]; then
	exit 1
fi

# Install headers
#make install-bootstrap-headers=yes install-headers

# Build and install
make -j$NPROC && \
make install && \

echo "GLIBC has built successfully!" && \
exit 0

echo "[GLIBC build info]"
echo "BASEDIR: $BASEDIR"
echo "PREFIX: $PREFIX"
echo "TARGET: $TARGET"
echo "HOST: $HOST"

exit 1
