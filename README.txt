[README]

# Warning, kernels and other large projects are included as submodules and will require a larger amount of space

# Basic steps
./init.sh # Only run this once
./build.sh

[Basic Understanding]
this will create a directory ending in "-cross", this contains useable tools for x86_64 and 
a functioning sysroot for cross compiling.

Look at testprg for an example

[More notes]
- Glibc, gcc, and binutils are pinned to the correct version compatible with beaglebone Debian 10 Buster
- This should be easily modifiable for other architectures, just note that hard floats are enabled
	in the current script. You should be fine just changing $TARGET and removing --with-float=hard for gcc
	but dont take my word on it
- This might not be a perfect cross-compiler but I plan on coming back to this later when my boss
	is not up my a**
- The pinned version of binutils requires a patch to get functional with with arm,
	The patch is applied in init.sh
	(http://patches.linaro.org/project/binutils/patch/20191126191014.13576-1-luis.machado@linaro.org/)

-- SOME DEPS (I had to download these after a fresh 22.04 server install) --
make
gnueabihf gcc/g++
texinfo
bison
flex
gawk
