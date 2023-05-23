#!/bin/bash

usage () {
	echo $0 [NPROC]
}

fail () {
	echo [ERROR] $1
	exit 1
}

BASEDIR=$(pwd)
PREFIX=$BASEDIR/x86_64
TARGET=arm-linux-gnueabi
NPROC=8
HOST=x86_64-linux-gnu

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
scripts/build-binutils.sh $BASEDIR $PREFIX $TARGET $NPROC $HOST x86_64
if [ $? != 0 ]
	then
		fail "Failed to build binutils"
fi

# Copy kernel headers
scripts/copy-kernel-headers.sh $BASEDIR $PREFIX $TARGET $NPROC $BASEDIR/3rd/linux x86_64
if [ $? != 0 ]
	then
		fail "Failed to copy kernel headers 1"
fi

mkdir -p $PREFIX/ti

# Copy kernel headers
scripts/copy-kernel-headers.sh $BASEDIR $PREFIX/ti $TARGET $NPROC $BASEDIR/3rd/ti-linux-kernel arm
if [ $? != 0 ]
	then
		fail "Failed to copy kernel headers 2"
fi

# Build GCC part 1
scripts/build-gcc-p1.sh $BASEDIR $PREFIX $TARGET $NPROC $HOST x86_64
if [ $? != 0 ]
	then
		fail "Failed to build first part of gcc"
fi

mkdir -p $PREFIX/arm

# Build glibc arm
scripts/build-glibc.sh $BASEDIR $PREFIX/ti $TARGET $NPROC arm-linux-gnueabi armv7l $PREFIX/ti/usr/include
if [ $? != 0 ]
	then
		fail "Failed to build glibc 1"
fi

cd $BASEDIR/3rd/glibc/build
make distclean
cd ..
rm -rf build
cd $BASEDIR

# Build glibc x86_64
scripts/build-glibc.sh $BASEDIR $PREFIX x86_64-linux-gnu $NPROC x86_64-linux-gnu x86_64 $PREFIX/usr/include
if [ $? != 0 ]
	then
		fail "Failed to build glibc 2"
fi

# Build GCC part 2
scripts/build-gcc-p2.sh $BASEDIR $PREFIX $TARGET $NPROC $HOST x86_64
if [ $? != 0 ]
	then
		fail "Failed to build GCC part 2"
fi

echo "Cross compiler has built successfully!"


