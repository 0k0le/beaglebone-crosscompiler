#!/bin/bash

BASEDIR=$1
PREFIX=$2
TARGET=$3
NPROC=$4
ARCH=$6
HOST=$5

echo "[GLIBC build info]"
echo "BASEDIR: $BASEDIR"
echo "PREFIX: $PREFIX"
echo "TARGET: $TARGET"

cd $BASEDIR/3rd/glibc && \

# Create build directory
mkdir -p build && \
cd build

if [[ "$ARCH" != "x86_64" ]]; then

# Configure build
../configure --target=$TARGET --prefix=$PREFIX \
	--host=$HOST --build=x86_64-linux-gnu \
	--disable-werror \
	--with-arch=$ARCH \
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
	--with-headers=$PREFIX/include

else

# Configure build
../configure --target=$TARGET --prefix=$PREFIX \
	--host=$HOST --build=x86_64-linux-gnu \
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
	--with-system-zlib \
	--enable-hacker-mode \
	--with-headers=$PREFIX/include

fi

if [[ $? != 0 ]]; then
	exit 1
fi

# Install headers
make install-bootstrap-headers=yes install-headers

# Build and install
make -j$NPROC && \
make install && \

echo "GLIBC has built successfully!" && \
exit 0

exit 1
