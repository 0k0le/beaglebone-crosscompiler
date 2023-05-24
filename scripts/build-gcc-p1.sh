#!/bin/bash

BASEDIR=$1
PREFIX=$2
TARGET=$3
NPROC=$4
HOST=$5

if [[ "$6" != "x86_64" ]]; then
    ARCH=--with-arch=$6 
    ZLIB=
	MLIB=--disable-multilib
	MLIST=
	MARCH=
	ETARGETS=
else
	#ETARGETS=--enable-targets=all
	MLIB=--disable-multilib
	#MARCH=--enable-multiarch
    #MLIST=--with-multilib-list=m64,m32,mx32
	ARCH=
    ZLIB=--with-system-zlib
	#HOST=i686-linux-gnu
fi

if [[ "$7" != "none" ]]; then
	SYSROOT=--with-sysroot=$7
else
	SYSROOT=
fi

echo "[GCC P1 build info]"
echo "BASEDIR: $BASEDIR"
echo "PREFIX: $PREFIX"
echo "TARGET: $TARGET"

cd $BASEDIR/3rd/gcc && \

# Download pre reqs
contrib/download_prerequisites && \

# Create build directory
mkdir -p build && \
cd build

../configure --target=$TARGET --prefix=$PREFIX/usr \
	--build=x86_64-linux-gnu --host=$HOST \
	$SYSROOT $ARCH $ZLIB \
	--disable-bootstrap \
	--disable-shared --disable-nls $ETARGETS $MLIB $MARCH $MLIST \
	--disable-threads \
	--with-newlib --without-headers \
	--enable-languages=c,c++ \
	--disable-libgomp --disable-libitm --disable-libquadmath \
	--disable-libsanitizer --disable-libssp --disable-libvtv \
	--disable-libcilkrts --disable-libatomic

if [[ $? != 0 ]]; then
	exit 1
fi

# Build and install
make -j$NPROC all-gcc all-target-libgcc && \
make install-gcc install-target-libgcc && \

echo "GCC Stage 1 compiler built successfully!" && \
exit 0

echo "[GCC P1 build info]"
echo "BASEDIR: $BASEDIR"
echo "PREFIX: $PREFIX"
echo "TARGET: $TARGET"

exit 1


