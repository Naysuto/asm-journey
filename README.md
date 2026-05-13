# x86-64 Assembly Learning Journey

Personal learning repository for x86-64 Linux Assembly, from absolute basics
to small-scale projects. Built as preparation for offensive security (red team,
reverse engineering, exploit development).

## Structure

- `exercises-XX/` — code from each chapter of the curriculum
- `projects/` — larger projects combining multiple concepts

## Projects

- **calculator** — CLI calculator parsing `12 + 7` style expressions
- **mini-shell** — minimal *nix shell with fork/execve, argument tokenization
- **mini-cat-with-args** — `cat` clone reading argv[1]
- **mini-libc** — reimplementation of select libc functions in pure ASM,
  callable from C, with automated tests

## Toolchain

- NASM (Intel syntax)
- GNU ld / gcc
- gdb with `set disassembly-flavor intel`
- Target: Linux x86-64

## Build

Each project has its own build instructions in its directory.
Generally:

\`\`\`bash
nasm -f elf64 file.asm -o file.o
ld file.o -o file
\`\`\`
