#!/bin/bash

BASEDIR=$1
ARCH=$2
INSTALLDIR=$3

usage () {
	echo "$0 $BASEDIR $ARCH $INSTALLDIR"
	exit 1
}

if [[ $# != 3 ]]; then
	usage
fi

cd $BASEDIR/3rd/ti-linux-kernel && \
make ARCH=$ARCH INSTALL_HDR_PATH=$INSTALLDIR headers_install

exit $?

