#!/bin/bash

BASEDIR=$(pwd)

cd $BASEDIR/3rd/gcc/build && \
make distclean && \
cd .. && \
rm -rf build

cd $BASEDIR/3rd/binutils-gdb/build && \
make distclean && \
cd .. && \
rm -rf build

cd $BASEDIR/3rd/glibc/build && \
make distclean && \
cd .. && \
rm -rf build
