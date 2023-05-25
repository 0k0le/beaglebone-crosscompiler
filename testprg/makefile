#
# Build file

ROOT=../arm-linux-gnueabihf-cross
CC=$(ROOT)/bin/arm-linux-gnueabihf-g++
SYSROOT=$(ROOT)/arm-linux-gnueabihf
BINDIR=bin
BIN=$(BINDIR)/testprg

$(BIN): init main.cpp
	$(CC) main.cpp -isysroot $(SYSROOT) -Wall -Wextra -pedantic -O2 -o $(BIN)

init:
	mkdir -p $(BINDIR)

clean:
	rm -rf $(BINDIR)
