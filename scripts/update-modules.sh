#!/bin/bash

# Use git to update submodules
#git submodule update --init --recursive --remote && \

# Since git does not support tags, move into gcc and set tag
cd 3rd/gcc && \
git checkout releases/gcc-8.3.0 && \
cd ../linux && \
git checkout v6.3 && \
cd ../glibc && \
git checkout release/2.28/master && \
cd ../binutils-gdb && \
git checkout binutils-2_31-branch && \
echo "Submodule HEADS are set"

