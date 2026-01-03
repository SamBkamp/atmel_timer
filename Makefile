CC := avr-gcc
ISA := atmega328p #for gcc-avr
CLOCK := 8000000 #for the F_CPU constant definition. can also be defined in the code i suppose
#for minipro
DEVICE := ATMEGA328P@DIP28
OPTIMISATIONS := s
FUSE_FILE := fuses.conf

#internal 8mhz oscillator (no div8). SPI enabled. Brown out disabled. no locks. no bootloader
lfuse := 0xe2
hfuse := 0xdf
efuse := 0xff
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
	rm chip_dump/*
	minipro -p ${DEVICE} -f ihex -r chip_dump/dump.hex -c code
	avr-objcopy -I ihex -O elf32-avr chip_dump/dump.hex chip_dump/out.bin
	avr-objdump -D chip_dump/out.bin > chip_dump/out.disasm
upload:
	minipro -p "${DEVICE}" -f ihex -w main.hex -c code -u

avrdude:
	avrdude -v -p ${ISA} -c stk500v1 -b 19200 -P /dev/ttyACM0  -U "flash:w:main.hex:i"

.PHONY:print_headers set_headers fuses analyse upload avrdude

# "/home/sam/.arduino15/packages/arduino/tools/avrdude/6.3.0-arduino17/bin/avrdude" "-C/home/sam/.arduino15/packages/arduino/tools/avrdude/6.3.0-arduino17/etc/avrdude.conf" -v -patmega328p -cstk500v1 -P/dev/ttyACM0 -b19200 -e -Ulock:w:0x3F:m -Uefuse:w:0xFD:m -Uhfuse:w:0xDE:m -Ulfuse:w:0xFF:m



#references
# https://ece-aclasses.usc.edu/ee459/library/documents/AVR-gcc.pdf
# https://avrdudes.github.io/avr-libc/avr-libc-user-manual-1.8.1/group__util__delay.html
# https://eleccelerator.com/fusecalc/fusecalc.php?chip=atmega328p
# https://www.arnabkumardas.com/arduino-tutorial/avr-memory-architecture/
