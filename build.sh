#!/bin/bash

usage () {
	echo $0 [NPROC]
}

fail () {
	echo [ERROR] $1
	exit 1
}

BASEDIR=$(pwd)
PREFIX=$BASEDIR/armv7l
TARGET=arm-linux-gnueabi
NPROC=10

# Check if arg exists
if [ -z "$1" ]
	# Display usage prompt if requested
	if [ "$1" == "--help" ]
		then
			usage
			exit 0
	fi

	# Process command line input	
	then
		NPROC=$1
fi

# Create install directory
mkdir -p $PREFIX

# Pull and set tags of submodules
scripts/update-modules.sh

# Build binutils
scripts/build-binutils.sh $BASEDIR $PREFIX $TARGET $NPROC
if [ $? != 0 ]
	then
		fail "Failed to build binutils"
fi

# Copy kernel headers
scripts/copy-kernel-headers.sh $BASEDIR $PREFIX $TARGET $NPROC
if [ $? != 0 ]
	then
		fail "Failed to copy kernel headers"
fi

# Build GCC part 1
scripts/build-gcc-p1.sh $BASEDIR $PREFIX $TARGET $NPROC
if [ $? != 0 ]
	then
		fail "Failed to build first part of gcc"
fi

# Build glibc
scripts/build-glibc.sh $BASEDIR $PREFIX $TARGET $NPROC
if [ $? != 0 ]
	then
		fail "Failed to build glibc"
fi

echo "Cross compiler has built successfully!"


