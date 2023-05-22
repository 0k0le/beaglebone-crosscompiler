#!/bin/bash

BASEDIR=$(pwd)
PREFIX1=$BASEDIR/armv7l
PREFIX2=$BASEDIR/x86_64

rm -rf 3rd/binutils-gdb/build
rm -rf 3rd/gcc/build
rm -rf 3rd/glibc/build
#rm -rf $PREFIX1
#rm -rf $PREFIX2
