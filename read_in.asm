.DEVICE ATmega328p
.DEFINE PORTB 0x05
.DEFINE DDRB 0x04
.DEFINE PINB 0x03
.DEFINE LOOP_LO 0xFF
.DEFINE LOOP_MI 0x69
.DEFINE LOOP_HI 0x18
.CSEG
.org 0                          ;vector jump table
        jmp     _start
        jmp     __bad_interrupt
        jmp     __bad_interrupt
        jmp     __bad_interrupt
        jmp     __bad_interrupt
        jmp     __bad_interrupt
        jmp     __bad_interrupt
        jmp     __bad_interrupt
        jmp     __bad_interrupt
        jmp     __bad_interrupt
        jmp     __bad_interrupt
        jmp     __bad_interrupt
        jmp     __bad_interrupt
        jmp     __bad_interrupt
        jmp     __bad_interrupt
        jmp     __bad_interrupt
        jmp     __bad_interrupt
        jmp     __bad_interrupt
        jmp     __bad_interrupt
        jmp     __bad_interrupt
        jmp     __bad_interrupt
        jmp     __bad_interrupt
        jmp     __bad_interrupt
        jmp     __bad_interrupt
        jmp     __bad_interrupt
        jmp     __bad_interrupt

_start:
        eor r1, r1
        out 0x3f, r1            ;zero SREG
        ldi r28, 0xFF
        ldi r29, 0x08
        out 0x3e, r29           ;init stack pointer (high)
        out 0x3d, r28           ;(low)
        call main

main:
        ldi r24, 0x03          
        ldi r26, 0x02
        ldi r23, 1              ;bit mask for input (pb0)
        out DDRB, r26          ;PB1 to output, rest to input
        out PORTB, r24         ;turn on pb1 and set pb0 to pull up
main_loop:
        ldi r25, 0
        in r25, PINB
        and r25, r23            ;result of and stored in r25, target pb0
        cpi r25, 1
        breq main_loop          ;if not set, repeat check
        out PORTB, r1
        jmp main_loop

__bad_interrupt:
        jmp 0
