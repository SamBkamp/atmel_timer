CC := avr-gcc
ISA := atmega328p #for gcc-avr
CLOCK := 8000000 #for the F_CPU constant definition. can also be defined in the code i suppose
DEVICE := ATMEGA328P@DIP28 #for minipro
OPTIMISATIONS := 1

#internal 8mhz oscillator (no div8). SPI enabled. Brown out disabled. no locks
HI_FUSE := -U hfuse:w:0xd9:m
LO_FUSE := -U lfuse:w:0xe0:m
E_FUSE := -U efuse:w:0xFF:m
LOCK_FUSE := -U lock:w:0xFF:m

a.out:main.c
	${CC} main.c ${VERBOSE} -O${OPTIMISATIONS} -mmcu=${ISA} -DF_CPU=${CLOCK} -Wall -o a.out

#feels kinda hacky
print_headers:set_headers a.out
	@echo "headers location printed!"
set_headers:
	$(eval VERBOSE = -v)

.PHONY:print_headers set_headers

#references
# https://ece-aclasses.usc.edu/ee459/library/documents/AVR-gcc.pdf
# https://avrdudes.github.io/avr-libc/avr-libc-user-manual-1.8.1/group__util__delay.html
# https://eleccelerator.com/fusecalc/fusecalc.php?chip=atmega328p
