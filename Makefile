CC := avr-gcc
DEVICE := atmega328p
CLOCK := 8000000 #for the F_CPU constant definition. can also be defined in the code i suppose
#FUSES := -U hfuse:w:0xd9:m -U lfuse:w:0xe0:m

a.out:main.c
	${CC} main.c -O1 -mmcu=${DEVICE} -DF_CPU=${CLOCK} -Wall -o a.out

print_headers:main.c
	${CC} main.c -v -O1 -mmcu=${DEVICE} -DF_CPU=${CLOCK} -Wall -o a.out

.PHONY:print_headers

#references
# https://ece-aclasses.usc.edu/ee459/library/documents/AVR-gcc.pdf
# https://avrdudes.github.io/avr-libc/avr-libc-user-manual-1.8.1/group__util__delay.html
