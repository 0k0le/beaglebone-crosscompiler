#!/bin/bash

usage () {
	echo $0 [KERNEL_ARCH] [HOST] [KERNDIR] [GLIBCARCH] [GCCARCH] [BUARCH]
	exit 1
}

fail () {
	echo [ERR] $1
	exit 1
}

# Setup variables
MACH=$1
HOST=$2
KERNEL=$3
GLIBCARCH=$4
GCCARCH=$5
BUARCH=$6
BASEDIR=$(pwd)
NPROC=8
SYSROOT=$BASEDIR/$HOST-sysroot
PREFIX=$SYSROOT

if [[ "$#" != "6" ]]; then
	usage
fi

# Create sysroot dir
mkdir -p $SYSROOT

# Copy kernel headers          PROJROOT INSTALLDIR COMPILER NPROC KERNDIR ARCH
scripts/copy-kernel-headers.sh $BASEDIR $PREFIX $HOST $NPROC $KERNEL $MACH
if [[ $? != 0 ]]; then
	fail "Failed to copy kernel headers"
fi

# Build Stage 1 gcc
scripts/build-gcc-p1.sh $BASEDIR $PREFIX $HOST $NPROC $HOST $GCCARCH none
if [[ $? != 0 ]]; then
	fail "Failed to build GCC P1"
fi

# Build glibc
scripts/build-glibc.sh $BASEDIR $PREFIX $HOST $NPROC $HOST $GLIBCARCH $PREFIX/usr/include
if [[ $? != 0 ]]; then
	fail "Failed to build glibc"
fi

# Build Binutils
scripts/build-binutils.sh $BASEDIR $PREFIX $HOST $NPROC $HOST $BUARCH none
if [[ $? != 0 ]]; then
    fail "Failed to build BINUTILS" 
fi

# Build Stage 2 GCC
scripts/build-gcc-p2.sh $BASEDIR $PREFIX $HOST $NPROC $HOST $GCCARCH none
if [[ $? != 0 ]]; then
    fail "Failed to build GCC P2"
fi

echo "SYSROOT Built Successfully"
