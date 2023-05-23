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
NPROC=4
HOST=$TARGET

re='^[0-9]+$'

# Check if arg exists
if [[ -z "$1" ]]
	# Display usage prompt if requested
	if [[ "$1" == "--help" ]]
		then
			usage
			exit 0
	fi

	# Process command line input	
	then
		if [[ $1 =~ $re ]]
			then
				NPROC=$1
		fi
fi

# Create install directory
mkdir -p $PREFIX

# Pull and set tags of submodules
scripts/update-modules.sh

# Build binutils
scripts/build-binutils.sh $BASEDIR $PREFIX $TARGET $NPROC $HOST armv7l
if [ $? != 0 ]
	then
		fail "Failed to build binutils"
fi

# Copy kernel headers
scripts/copy-kernel-headers.sh $BASEDIR $PREFIX $TARGET $NPROC $BASEDIR/3rd/ti-linux-kernel arm
if [ $? != 0 ]
	then
		fail "Failed to copy kernel headers"
fi

# Build GCC part 1
scripts/build-gcc-p1.sh $BASEDIR $PREFIX $TARGET $NPROC $HOST armv7-a
if [ $? != 0 ]
	then
		fail "Failed to build first part of gcc"
fi

# Build glibc
scripts/build-glibc.sh $BASEDIR $PREFIX $TARGET $NPROC $HOST armv7l $PREFIX/usr/include
if [ $? != 0 ]
	then
		fail "Failed to build glibc"
fi

# Build GCC part 2
scripts/build-gcc-p2.sh $BASEDIR $PREFIX $TARGET $NPROC $HOST armv7-a
if [ $? != 0 ]
	then
		fail "Failed to build GCC part 2"
fi

echo "Cross compiler has built successfully!"


