 CC := avr-gcc
ISA := atmega328p #for gcc-avr
CLOCK := 8000000 #for the F_CPU constant definition. can also be defined in the code i suppose
#for minipro
DEVICE := ATMEGA328P@DIP28
OPTIMISATIONS := s
FUSE_FILE := fuses.conf

#internal 8mhz oscillator (no div8). SPI enabled. Brown out disabled. no locks
lfuse := 0x62
hfuse := 0xd6
efuse := 0xf9
lock := 0xff

a.out:main.c
	${CC} main.c ${VERBOSE} -O${OPTIMISATIONS} -mmcu=${ISA} -DF_CPU=${CLOCK} -Wall -o a.out

#feels kinda hacky
print_headers:set_headers a.out
	@echo "headers location printed!"
set_headers:
	$(eval VERBOSE = -v)

fuses:
	$(file > ${FUSE_FILE},lfuse=${lfuse})
	$(file >> ${FUSE_FILE},hfuse=${hfuse})
	$(file >> ${FUSE_FILE},efuse=${efuse})
	$(file >> ${FUSE_FILE},lock=${lock})
	minipro -p ${DEVICE} -w ${FUSE_FILE} -c config
	rm ${FUSE_FILE}

analyse:
	mkdir -p chip_dump
	cd chip_dump
	rm *
	minipro -p ${DEVICE} -f ihex -r dump.hex -c code
	avr-objcopy -I ihex -o elf32-avr dump.hex out.bin
	avr-objdump -D out.bin > out.disasm

.PHONY:print_headers set_headers fuses analyse

#references
# https://ece-aclasses.usc.edu/ee459/library/documents/AVR-gcc.pdf
# https://avrdudes.github.io/avr-libc/avr-libc-user-manual-1.8.1/group__util__delay.html
# https://eleccelerator.com/fusecalc/fusecalc.php?chip=atmega328p
# https://www.arnabkumardas.com/arduino-tutorial/avr-memory-architecture/
