#!/bin/bash

fail() {
	echo [ERROR] $1
	exit 1
}

TARGET=arm-linux-gnueabi
BASEDIR=$(pwd)
NPROC=20

# Setup cross directory
rm -rf $BASEDIR/$TARGET-cross
mkdir -p $BASEDIR/$TARGET-cross

# BINUTILS
# setup build dir
cd $BASEDIR/3rd/binutils-gdb/
cd build && make distclean
cd $BASEDIR/3rd/binutils-gdb
rm -rf $BASEDIR/3rd/binutils/build
mkdir -p build && cd build

if [[ $? != 0 ]]; then
	fail "Failed to setup binutils builddir"
fi

# configure
../configure --prefix=$BASEDIR/$TARGET-cross --with-gnu-ld --with-gnu-as \
	--target=$TARGET --disable-multilib \
	--disable-werror --disable-gdb

# build
make -j$NPROC && \
make install

if [[ $? != 0 ]]; then
	fail "Failed to build binutils"
fi

# KERNEL HEADERS
cd $BASEDIR/3rd/linux
make ARCH=arm INSTALL_HDR_PATH=$BASEDIR/$TARGET-cross/$TARGET headers_install

if [[ $? != 0 ]]; then
	fail "Failed to install linux kernel headers"
fi

# BUILD S1 GCC
# Setup gcc builddir
cd $BASEDIR/3rd/gcc/
contrib/download_prerequisites
cd build && make distclean
cd $BASEDIR/3rd/gcc
rm -rf $BASEDIR/3rd/gcc/build
mkdir -p build && cd build

if [[ $? != 0 ]]; then
	fail "Failed to setup gcc builddir"
fi

# configure
../configure --prefix=$BASEDIR/$TARGET-cross --target=$TARGET \
		--enable-languages=c,c++ --disable-multilib

# build
make -j$NPROC all-gcc && \
make install-gcc

if [[ $? != 0 ]]; then
	fail "Failed to build gcc"
fi

# BUILD S1 GLIBC
cd $BASEDIR/3rd/glibc/
cd build && make distclean
cd $BASEDIR/3rd/glibc
rm -rf $BASEDIR/3rd/glibc/build
mkdir -p build && cd build

if [[ $? != 0 ]]; then
	fail "Failed to setup glibc builddir"
fi

# configure
../configure --prefix=$BASEDIR/$TARGET-cross/$TARGET --build=$(gcc -dumpmachine) \
		--host=$TARGET --target=$TARGET --with-headers=$BASEDIR/$TARGET-cross/$TARGET/include \
		--disable-multilib libc_cv_forced_unwind=yes --disable-werror

# build
make install-bootstrap-headers=yes install-headers && \
make -j$NPROC csu/subdir_lib && \
install csu/crt1.o csu/crti.o csu/crtn.o $BASEDIR/$TARGET-cross/$TARGET/lib && \
$TARGET-gcc -nostdlib -nostartfiles -shared -x c /dev/null -o $BASEDIR/$TARGET-cross/$TARGET/lib/libc.so && \
touch $BASEDIR/$TARGET-cross/$TARGET/include/gnu/stubs.h

if [[ $? != 0 ]]; then
	fail "Failed to build s1 glibc"
fi

# BUILD LIBGCC
cd $BASEDIR/3rd/gcc/build
make -j$NPROC all-target-libgcc
make install-target-libgcc

if [[ $? != 0 ]]; then
	fail "Failed to build libgcc"
fi

# FINISH GLIBC
cd $BASEDIR/3rd/glibc/build
make -j$NPROC
make install

if [[ $? != 0 ]]; then
	fail "Failed to build glibc s2"
fi

# FINISH GCC
cd $BASEDIR/3rd/gcc/build
make -j$NPROC
make install

if [[ $? != 0 ]]; then
	fail "Failed to build gcc s2"
fi

echo "Cross compiler complete"
















