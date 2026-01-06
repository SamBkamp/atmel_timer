ISA := atmega328p #for avrdude
DEVICE := ATMEGA328P@DIP28 #for minipro
FUSE_FILE := fuses.conf

OUTDEVICE := /dev/ttyACM0

FILE := main.avra

#internal 1mhz oscillator (div8). SPI enabled. Brown out disabled. no locks. no bootloader
lfuse := 0x62
hfuse := 0xdf
efuse := 0xff
lock := 0xff

main.hex:${FILE}
	avra ${FILE}
	rm *eep.hex *obj

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

install:main.hex
	avrdude -v -p ${ISA} -c stk500v1 -b 19200 -P ${OUTDEVICE}  -U "flash:w:main.hex:i"

.PHONY:fuses analyse install

#references
# https://ece-aclasses.usc.edu/ee459/library/documents/AVR-gcc.pdf
# https://avrdudes.github.io/avr-libc/avr-libc-user-manual-1.8.1/group__util__delay.html
# https://eleccelerator.com/fusecalc/fusecalc.php?chip=atmega328p
# https://www.arnabkumardas.com/arduino-tutorial/avr-memory-architecture/
