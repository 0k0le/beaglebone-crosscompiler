#!/bin/bash

BASEDIR=$1
PREFIX=$2
TARGET=$3
NPROC=$4

echo "[BINUTILS build info]"
echo "BASEDIR: $BASEDIR"
echo "PREFIX: $PREFIX"
echo "TARGET: $TARGET"

# Create build directory
cd $BASEDIR/3rd/binutils-gdb && \
mkdir -p build && \
cd build && \

# Configure build
../configure --target=$TARGET --prefix=$PREFIX --disable-nls --disable-werror \
	--disable-gdb --disable-libdecnumber --disable-readline --disable-sim && \

# Build
make -j$NPROC && \
make install && \

echo "BINUTILS has compiled successfully for $TARGET in $PREFIX" && \
exit 0

exit 1
