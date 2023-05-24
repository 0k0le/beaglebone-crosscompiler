#!/bin/bash

fail () {
    echo [ERROR] $1
    exit 1
}

BASEDIR=$(pwd)
HOST=$(gcc -dumpmachine)
TARGET=arm-linux-gnueabi
PREFIX=$BASEDIR/$TARGET
SYSROOT=$BASEDIR/$TARGET-sysroot
NPROC=8

./clean.sh && rm -rf $PREFIX
mkdir -p $PREFIX

scripts/update-modules.sh
if [[ $? != 0 ]]; then
	fail "Failed to update modules"
fi

scripts/copy-kernel-headers.sh $BASEDIR $PREFIX $TARGET $NPROC $BASEDIR/3rd/linux x86_64
if [[ $? != 0 ]]; then
	fail "Failed to copy kernel headers"
fi

scripts/build-binutils.sh $BASEDIR $PREFIX $TARGET $NPROC $HOST x86_64 $SYSROOT
if [[ $? != 0 ]]; then
	fail "Failed to build binutils"
fi

scripts/build-gcc-p1.sh $BASEDIR $PREFIX $TARGET $NPROC $HOST x86_64 $SYSROOT
if [[ $? != 0 ]]; then
	fail "Failed to bulid gcc p1"
fi

scripts/build-glibc.sh $BASEDIR $PREFIX $TARGET $NPROC $HOST x86_64 $PREFIX/usr/include
if [[ $? != 0 ]]; then
	fail "Failed to build glibc"
fi

scripts/build-gcc-p2.sh $BASEDIR $PREFIX $TARGET $NPROC $HOST x86_64 $SYSROOT
if [[ $? != 0 ]]; then
	fail "Failed to bulid gcc p2"
fi

echo "Compiler comilation complete"

