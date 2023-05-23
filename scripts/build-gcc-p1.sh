#!/bin/bash

BASEDIR=$1
PREFIX=$2
TARGET=$3
NPROC=$4
ARCH=$6
HOST=$5

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

if [[ "$ARCH" != "x86_64" ]]; then

../configure --target=$TARGET --prefix=$PREFIX/usr \
	--build=x86_64-linux-gnu --host=$HOST \
	$SYSROOT \
	--with-arch=$ARCH \
	--disable-bootstrap \
	--disable-shared --disable-nls --disable-multilib \
	--disable-threads \
	--with-newlib --without-headers \
	--enable-languages=c,c++ \
	--disable-libgomp --disable-libitm --disable-libquadmath \
	--disable-libsanitizer --disable-libssp --disable-libvtv \
	--disable-libcilkrts --disable-libatomic

else

# Configure build
../configure --target=$TARGET --prefix=$PREFIX/usr \
	--build=x86_64-linux-gnu --host=$HOST \
	$SYSROOT \
	--disable-bootstrap \
	--disable-shared --disable-nls --enable-multilib \
	--with-system-zlib \
	--disable-threads \
	--with-newlib --without-headers \
	--enable-languages=c,c++ \
	--disable-libgomp --disable-libitm --disable-libquadmath \
	--disable-libsanitizer --disable-libssp --disable-libvtv \
	--disable-libcilkrts --disable-libatomic

fi

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


