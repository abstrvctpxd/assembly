all: marks

marks:
	nasm -f elf64 marks.asm -o marks.o
	ld marks.o -o marks

clean:
	rm -f marks.o marks
