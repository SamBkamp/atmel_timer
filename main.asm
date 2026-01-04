.DEVICE ATmega328p
.DEFINE PORTB 0x05
.DEFINE DDRB 0x04
.DEFINE PINB 0x03
.DEFINE LOOP_LO 0xFF
.DEFINE LOOP_MI 0x69
.DEFINE LOOP_HI 0x18
.CSEG
.org 0                          ;vector jump table
        jmp _start
        jmp __bad_interrupt
        jmp __bad_interrupt
        jmp __bad_interrupt
        jmp __bad_interrupt
        jmp __bad_interrupt
        jmp __bad_interrupt
        jmp __bad_interrupt
        jmp __bad_interrupt
        jmp __bad_interrupt
        jmp __bad_interrupt
        jmp __bad_interrupt
        jmp __bad_interrupt
        jmp __bad_interrupt
        jmp __bad_interrupt
        jmp __bad_interrupt
        jmp __bad_interrupt
        jmp __bad_interrupt
        jmp __bad_interrupt
        jmp __bad_interrupt
        jmp __bad_interrupt
        jmp __bad_interrupt
        jmp __bad_interrupt
        jmp __bad_interrupt
        jmp __bad_interrupt
        jmp __bad_interrupt

_start:
        eor r1, r1
        out 0x3f, r1        ;zero SREG
        ldi r28, 0xFF
        ldi r29, 0x08
        out 0x3e, r29       ;init SPH (stack pointer high) (i think)
        out 0x3d, r28       ;init SPL (stack pointer low)
        call main
        jmp _exit

main:
        ldi r18, 0x03
        ldi r19, 0x06
        ldi r17, 0x01
        out DDRB, r19           ;r24 = 6 -> set pin PB1 & PB2 to output
        out PORTB, r17          ;r1 = set pb0 to pull up
        nop                     ;for synchronization
while:
        ldi r25, 0
        in r25, PINB            ;read pb
        andi r25, 0x1
        breq PB2_toggle         ;toggle pb2 if button pressed
next_blink:
        out PORTB, r17          ;r1 = set pb0 to pull up
        call delay
        out PORTB, r18          ;all the output pins to drive high
        call delay
        jmp while


PB2_toggle:
        push r20
        ldi r20, 0x04
        eor r18, r20            ;toggle pb2
        pop r20
        jmp next_blink


delay:                          ;a busy loop lol
        ldi r20, LOOP_LO
        ldi r21, LOOP_MI
        ldi r22, LOOP_HI
subbing:
        subi r20, 1
        sbci r21, 0
        sbci r22, 0
        brne subbing
        ret


_exit:
        cli
__bad_interrupt:
        jmp 0
