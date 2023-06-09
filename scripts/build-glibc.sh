#!/bin/bash
                               
BASEDIR=$1
TARGET=$2
PREFIX=$3                      
NPROC=$4
PART=$5

dump () {
	echo "BASEDIR: $BASEDIR"
	echo "TARGET: $TARGET"
	echo "PREFIX: $PREFIX"
	echo "NPROC: $NPROC"
	echo "PART: $PART"
}

usage () {
    echo "USAGE: $0 [BASEDIR] [TARGET] [PREFIX] [NPROC] [PART]"
    exit 1
}

fail () {
    echo [ERROR] $@
    dump
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
    cd $BASEDIR/3rd/glibc/build 
	../configure --prefix=$PREFIX --build=$(gcc -dumpmachine) \
        --host=$TARGET --target=$TARGET --with-headers=$PREFIX/include \
        --disable-multilib libc_cv_forced_unwind=yes --disable-werror --with-arch=armv7a
}

build_p1 () {
	cd $BASEDIR/3rd/glibc/build
    make install-bootstrap-headers=yes install-headers && \
    make -j$NPROC csu/subdir_lib && \
    install csu/crt1.o csu/crti.o csu/crtn.o $PREFIX/lib && \
    $TARGET-gcc -nostdlib -nostartfiles -shared -x c /dev/null -o $PREFIX/lib/libc.so && \
    touch $PREFIX/include/gnu/stubs.h
}

build_p2 () {
	cd $BASEDIR/3rd/glibc/build
	make -j$NPROC && \
	make install
}

if [[ $# != 5 ]]; then
    usage
fi

if [[ "$PART" == "1" ]]; then
	create_build_dir glibc
	configure_build && \
	build_p1
elif [[ "$PART" == "2" ]]; then
	build_p2
else
	usage
fi

if [[ $? != 0 ]]; then
	dump
	exit 1
fi

exit 0











