#!/bin/bash

BASEDIR=$1
PREFIX=$2
TARGET=$3
NPROC=$4
ARCH=$6
HOST=$5

echo "[GCC Part 2 build info]"
echo "BASEDIR: $BASEDIR"
echo "PREFIX: $PREFIX"
echo "TARGET: $TARGET"

# Setup build directory
cd $BASEDIR/3rd/gcc/ && \
rm -rf build && \
mkdir build && \
cd build 

if [[ "$ARCH" != "x86_64" ]]; then

../configure --target=$TARGET --prefix=$PREFIX --with-gnu-ld --with-gnu-as \
	--with-arch=$ARCH \
	--build=x86_64-linux-gnu --host=$HOST \
	--disable-bootstrap \
	--disable-libsanitizer \
	--disable-werror \
	--disable-libgomp \
	--disable-libitm \
	--disable-libquadmath \
	--disable-libssp --disable-libvtv \
	--disable-libcilkrts --disable-libatomic \
	--enable-shared --disable-nls --enable-multilib \
	--enable-languages=c,c++

else
	
../configure --target=$TARGET --prefix=$PREFIX --with-gnu-ld --with-gnu-as \
	--build=x86_64-linux-gnu --host=$HOST \
	--disable-bootstrap \
	--disable-libsanitizer \
	--with-system-zlib \
	--disable-werror \
	--disable-libgomp \
	--disable-libitm \
	--disable-libquadmath \
	--disable-libssp --disable-libvtv \
	--disable-libcilkrts --disable-libatomic \
	--enable-shared --disable-nls --enable-multilib \
	--enable-languages=c,c++

fi

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


