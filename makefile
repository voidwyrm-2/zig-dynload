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

all: build-c build-cc build-zig

run: all
	./$(PROGRAM) lib.so
