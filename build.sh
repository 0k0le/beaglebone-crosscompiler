#!/bin/bash

fail() {
	echo [ERROR] $1
	exit 1
}

TARGET=arm-linux-gnueabihf
BASEDIR=$(pwd)
NPROC=20

scripts/update-modules.sh

# Setup cross directory
rm -rf $BASEDIR/$TARGET-cross
mkdir -p $BASEDIR/$TARGET-cross

scripts/build-binutils.sh $BASEDIR $TARGET $BASEDIR/$TARGET-cross $NPROC

if [[ $? != 0 ]]; then
	fail "Failed to build binutils"
fi

echo "Finished binutils"

# KERNEL HEADERS
scripts/copy-kernel-headers.sh $BASEDIR arm $BASEDIR/$TARGET-cross/$TARGET

if [[ $? != 0 ]]; then
	fail "Failed to install linux kernel headers"
fi

echo "Finished kernel headers"

# GCC p1
scripts/build-gcc.sh $BASEDIR $TARGET $BASEDIR/$TARGET-cross $NPROC 1

if [[ $? != 0 ]]; then
	fail "Failed to build gcc s1"
fi

echo "Finished gcc s1"

# BUILD S1 GLIBC
scripts/build-glibc.sh $BASEDIR $TARGET $BASEDIR/$TARGET-cross/$TARGET $NPROC 1

if [[ $? != 0 ]]; then
	fail "Failed to build s1 glibc"
fi

echo "Finished s1 glibc"

# BUILD LIBGCC
scripts/build-gcc.sh $BASEDIR $TARGET $BASEDIR/$TARGET-cross $NPROC 2

if [[ $? != 0 ]]; then
	fail "Failed to build libgcc"
fi

echo "Finshed libgcc"

scripts/build-glibc.sh $BASEDIR $TARGET $BASEDIR/$TARGET-cross/$TARGET $NPROC 2

if [[ $? != 0 ]]; then
	fail "Failed to build glibc s2"
fi

echo "Finished glibc s2"

# FINISH GCC
scripts/build-gcc.sh $BASEDIR $TARGET $BASEDIR/$TARGET-cross $NPROC 3

if [[ $? != 0 ]]; then
	fail "Failed to build gcc s3"
fi

echo "Crosscompiler complete"













