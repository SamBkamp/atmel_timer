.DEVICE ATmega328p
.DEFINE PORTB 0x05
.DEFINE DDRB 0x04
.DEFINE LOOP_LO 0xFF
.DEFINE LOOP_MI 0x69
.DEFINE LOOP_HI 0x18
.CSEG
.org 0
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
        eor     r1, r1
        out     0x3f, r1        ;zero SREG
        ldi     r28, 0xFF
        ldi     r29, 0x08
        out     0x3e, r29       ;init SPH (stack pointer high) (i think)
        out     0x3d, r28       ;init SPL (stack pointer low)
        call    main
        jmp     _exit

main:
        ldi     r24, 0x02
        out     DDRB, r24       ;r24 = 2 -> set pin PB1 to output
while:
        out     PORTB, r1       ;r1 = 0 -> all pins to low
        ldi     r18, LOOP_LO
        ldi     r19, LOOP_MI
        ldi     r25, LOOP_HI
off_loop:
        subi    r18, 0x01
        sbci    r19, 0x00
        sbci    r25, 0x00
        brne    off_loop
        out     PORTB, r24      ;r24 = 2 -> PB1 to high
        ldi     r18, LOOP_LO
        ldi     r19, LOOP_MI
        ldi     r25, LOOP_HI
on_loop:
        subi    r18, 0x01
        sbci    r19, 0x00
        sbci    r25, 0x00
        brne    on_loop
        rjmp    while

_exit:
        cli
__bad_interrupt:
        jmp 0
