all: hello data_repr

hello:
	nasm -f elf64 hello.asm -o hello.o
	ld hello.o -o hello

data_repr:
	nasm -f elf64 data_repr.asm -o data_repr.o
	ld data_repr.o -o data_repr

clean:
	rm -f *.o hello data_repr
