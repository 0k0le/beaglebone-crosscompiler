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
    cd $BASEDIR/3rd/gcc/build 
	../configure --prefix=$PREFIX --target=$TARGET \
		--enable-languages=c,c++ --disable-multilib \
		--with-float=hard

	exit $?
}

build_p1 () {
    cd $BASEDIR/3rd/gcc/build && \
	make -j$NPROC all-gcc && \
    make install-gcc
}

build_p2 () {
	cd $BASEDIR/3rd/gcc/build && \
	make -j$NPROC all-target-libgcc && \ 
	make install-target-libgcc
}

build_p3 () {
	cd $BASEDIR/3rd/gcc/build && \
	make -j$NPROC && \
	make install
}

if [[ $# != 5 ]]; then
    usage
fi

if [[ "$PART" == "1" ]]; then
	create_build_dir gcc && \
	configure_build && \
	build_p1
elif [[ "$PART" == "2" ]]; then
	build_p2
elif [[ "$PART" == "3" ]]; then
	build_p3
fi

cd $BASEDIR

if [[ $? != 0 ]]; then
	dump
	exit 1
fi

exit 0





