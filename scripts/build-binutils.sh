#!/bin/bash

BASEDIR=$1
PREFIX=$2
TARGET=$3
NPROC=$4
ARCH=$6
HOST=$5

echo "[BINUTILS build info]"
echo "BASEDIR: $BASEDIR"
echo "PREFIX: $PREFIX"
echo "TARGET: $TARGET"

# Create build directory
cd $BASEDIR/3rd/binutils-gdb && \
mkdir -p build && \
cd build

if [[ "$ARCH" != "x86_64" ]]; then

# Configure build
../configure --target=$TARGET --prefix=$PREFIX/usr --disable-nls --disable-werror \
	--with-arch=$ARCH --disable-gdb --disable-libdecnumber \
	--build=x86_64-linux-gnu --host=$HOST \
	--with-sysroot=$PREFIX \
	--disable-readline --disable-sim

else

# Configure build
../configure --target=$TARGET --prefix=$PREFIX/usr --disable-nls --disable-werror \
	--disable-gdb --disable-libdecnumber \
	--with-system-zlib \
	--build=x86_64-linux-gnu --host=$HOST \
	--with-sysroot=$PREFIX \
	--disable-readline --disable-sim

fi

if [[ $? != 0 ]]; then
	exit 1
fi

# Build
make -j$NPROC && \
make install && \
echo "BINUTILS has compiled successfully for $TARGET in $PREFIX" && \
exit 0

echo "[BINUTILS build info]"
echo "BASEDIR: $BASEDIR"
echo "PREFIX: $PREFIX"
echo "TARGET: $TARGET"
echo "NPROC: $NPROC"
echo "ARCH: $ARCH"
echo "HOST: $HOST"

exit 1
