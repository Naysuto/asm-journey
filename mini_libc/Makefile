NASM    = nasm
CC      = gcc
NASMFLAGS = -f elf64
CFLAGS  = -no-pie -g

SRC_ASM = src/string.asm src/memory.asm src/stdlib.asm src/stdio.asm
OBJ     = $(SRC_ASM:.asm=.o)

all: tests/test_string tests/test_memory tests/test_stdlib

%.o: %.asm
	$(NASM) $(NASMFLAGS) $< -o $@

tests/test_string: tests/test_string.c src/string.o src/memory.o
	$(CC) $(CFLAGS) $^ -o $@

tests/test_memory: tests/test_memory.c src/memory.o src/string.o
	$(CC) $(CFLAGS) $^ -o $@

tests/test_stdlib: tests/test_stdlib.c src/stdlib.o src/string.o
	$(CC) $(CFLAGS) $^ -o $@

clean:
	rm -f $(OBJ) tests/test_string tests/test_memory tests/test_stdlib
