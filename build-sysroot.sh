#!/bin/bash

usage () {
    echo $0 [NPROC]
}

fail () {
    echo [ERROR] $1
    exit 1
}

BASEDIR=$(pwd)
TARGET=arm-linux-gnueabi
NPROC=8
HOST=$(gcc -dumpmachine)

mkdir -p $TARGET

# BUILD BEAGLEBONE SYSROOT
./clean.sh && rm -rf arm-linux-gnueabi-sysroot

scripts/update-modules.sh
if [[ $? != 0 ]]; then
	fail "Failed to update modules"	
fi

scripts/build-sysroot.bash arm arm-linux-gnueabi 3rd/ti-linux-kernel/ armv7l armv7 armv7l
if [[ $? != 0 ]]; then
	fail "Failed to build sysroot!"
fi
