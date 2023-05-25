#!/bin/bash

BASEDIR=$1
TARGET=$2
PREFIX=$3
NPROC=$4

usage () {
	echo "USAGE: $0 [BASEDIR] [TARGET] [PREFIX] [NPROC]"
	exit 1
}

fail () {
	echo [ERROR] $@
	exit 1
}

create_build_dir () {		
	cd $BASEDIR/3rd/$1
	cd build && make distclean
	cd $BASEDIR/3rd/$1 && rm -rf build && \
	mkdir -p build && cd build

	if [[ $? != 0 ]]; then
		fail "Failed to create builddir"
	fi
}

configure_build () {
	cd $BASEDIR/3rd/binutils-gdb/build
	../configure --prefix=$PREFIX --with-gnu-ld --with-gnu-as \
    	--target=$TARGET --disable-multilib \
    	--disable-werror --disable-gdb
}

build () {
	make -j$NPROC
	make install
}

if [[ $# != 4 ]]; then
	usage
fi

create_build_dir binutils-gdb && \
configure_build && \
build && \
echo "BINUTILS Built Successfully" && \
exit 0

cd $BASEDIR

exit 1



