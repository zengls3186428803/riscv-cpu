CROSS_COMPILE=riscv64-unknown-elf-
CC=$(CROSS_COMPILE)gcc
CFLAGS=-c -nostdlib -march=rv32i -mabi=ilp32
SFLAGS=-S -nostdlib -march=rv32i -mabi=ilp32
OBJCOPY=$(CROSS_COMPILE)objcopy
OBJCOPYFLAGS=-O binary -j .text
LD=$(CROSS_COMPILE)ld
LDFLAGS=-melf32lriscv

final_ld.bin:main.o init.o
	$(LD) $(LDFLAGS) -o final.o init.o main.o
	$(OBJCOPY) $(OBJCOPYFLAGS) final.o final_ld.bin
	$(CROSS_COMPILE)objdump -D -b binary -mriscv final_ld.bin>final_hex.txt
	python3 process.py > /dev/null

main.o:main.c
	$(CC) $(SFLAGS) main.c -o main.s
	$(CC) $(CFLAGS) main.c -o main.o

init.o:init.s
	$(CC) $(CFLAGS) init.s -o init.o

clean:
	rm -f *.o
	rm -f *.bin
	rm -f *.txt
	rm main.s

