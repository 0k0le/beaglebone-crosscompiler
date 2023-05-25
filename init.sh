#!/bin/bash

git submodule update --init --recursive --remote

cd $(pwd)/3rd/glibc
git apply ../../glibc.patch
