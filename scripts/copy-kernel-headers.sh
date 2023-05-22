#!/bin/bash

BASEDIR=$1
PREFIX=$2
TARGET=$3
NPROC=$4

echo "Installing kernel headers"

cd $BASEDIR/3rd/ti-linux-kernel && \

make headers_install ARCH=arm INSTALL_HDR_PATH=$PREFIX && \

echo "Kernel headers installed successfully!" && \
exit 0

exit 1
