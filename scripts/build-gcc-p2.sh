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
else
	MLIB=--disable-multilib
    #MLIST=--with-multilib-list=m64,m32,mx32
    ARCH=
	ZLIB=--with-system-zlib
fi

if [[ "$7" != "none" ]]; then
    SYSROOT=--with-sysroot=$7 
	#BSYSROOT=--with-build-sysroot=$7
else
    SYSROOT=
	BSYSROOT=
fi

echo "[GCC Part 2 build info]"
echo "BASEDIR: $BASEDIR"
echo "PREFIX: $PREFIX"
echo "TARGET: $TARGET"

# Setup build directory
cd $BASEDIR/3rd/gcc/build && \
make distclean && \
cd .. && \
rm -rf build && \
mkdir build && \
cd build 

if [[ $? != 0 ]]; then
    exit 1
fi

CFLAGS="$CFLAGS -O2 -D__x86_64__" ../configure --target=$TARGET --prefix=$PREFIX/usr  \
	$SYSROOT $BSYSROOT $ARCH $ZLIB \
	--build=x86_64-linux-gnu --host=$HOST \
	--disable-bootstrap \
	--disable-libsanitizer \
	--disable-werror \
	--disable-libgomp \
	--disable-libitm \
	--disable-libquadmath \
	--disable-libssp --disable-libvtv \
	--disable-libcilkrts --disable-libatomic \
	--enable-shared --disable-nls $MLIB $MLIST \
	--enable-languages=c,c++

if [[ $? != 0 ]]; then
	exit 1
fi

	
make -j$NPROC && \
make install && \
echo "GCC Part 2 built successfully" && \
exit 0

echo "[GCC Part 2 build info]"
echo "BASEDIR: $BASEDIR"
echo "PREFIX: $PREFIX"
echo "TARGET: $TARGET"

exit 1


