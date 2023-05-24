#!/bin/bash

BASEDIR=$1
PREFIX=$2
TARGET=$3
NPROC=$4
HOST=$5

if [[ "$6" != "x86_64" ]]; then
	ARCH=--with-arch=$6
	ZLIB=
else
	ARCH=
	ZLIB=--with-system-zlib
fi

if [[ "$7" != "none" ]]; then
    SYSROOT=--with-sysroot=$7  
else
    SYSROOT=
fi

echo "[BINUTILS build info]"
echo "BASEDIR: $BASEDIR"
echo "PREFIX: $PREFIX"
echo "TARGET: $TARGET"

# Create build directory
cd $BASEDIR/3rd/binutils-gdb && \
mkdir -p build && \
cd build

# Configure build
../configure --target=$TARGET --prefix=$PREFIX/usr --disable-nls --disable-werror \
	$ARCH --disable-gdb --disable-libdecnumber \
	$ZLIB --build=x86_64-linux-gnu --host=$HOST \
	$SYSROOT --disable-readline --disable-sim

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
