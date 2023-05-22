#!/bin/bash

# Use git to update submodules
git submodule update --init --recursive --remote && \

# Since git does not support tags, move into gcc and set tag
cd 3rd/gcc && \
git checkout releases/gcc-8.3.0 && \
echo "Submodule HEADS are set"
