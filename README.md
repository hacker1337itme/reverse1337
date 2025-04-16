# reverse1337
LINUX REVERSE SHELL IN PURE ASM

# BUILD

```shell
nasm -f elf32 reverse1337.asm -o reverse1337.o
ld -m elf_i386 reverse1337.o -o reverse1337

```
