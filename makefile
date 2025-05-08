PROGRAM = dynload
ZC = zig

build-zig:
	rm -rf $(PROGRAM)
	$(ZC) build-exe --name $(PROGRAM) src/main.zig
	rm -rf $(PROGRAM).o

build-c:
	rm -rf lib.so
	gcc -shared -fPIC -o clib.so lib.c

build-cc:
	rm -rf cclib.so
	g++ -shared -fPIC -o cclib.so lib.cc

# -ofmt=elf doesn't work
# -ofmt=macho doesn't work
build-libzig:
	rm -rf *.o *.dynlib
	zig build-lib -lc -fPIC -dynamic -isystem -ofmt=elf --name zlib lib.zig # mmm yes I love magical flags

all: build-c build-cc build-zig
