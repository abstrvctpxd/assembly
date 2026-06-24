all: alu

alu:
	nasm -f elf64 alu.asm -o alu.o
	ld alu.o -o alu

clean:
	rm -f alu.o alu
