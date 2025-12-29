CC := avr-gcc
DEVICE := atmega328p
CLOCK := 8000000
#FUSES := -U hfuse:w:0xd9:m -U lfuse:w:0xe0:m
# https://ece-classes.usc.edu/ee459/library/documents/AVR-gcc.pdf

a.out:main.c
	${CC} main.c -mmcu=${DEVICE} -DF_CPU=${CLOCK} -Wall -o a.out
