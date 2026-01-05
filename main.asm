.DEVICE ATmega328p
.DEFINE PINB 0x03
.DEFINE DDRB 0x04
.DEFINE PORTB 0x05
.DEFINE TCCR0A 0x24
.DEFINE TCCR0B 0x25
.DEFINE OCR0A 0x27
.DEFINE TIMSK0 0x6E
.DEFINE LOOP_LO 0xFF
.DEFINE LOOP_MI 0x69
.DEFINE LOOP_HI 0x18
.CSEG
.org 0                          ;vector jump table
        jmp _start              ;restart
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
        jmp toggle_pb1         ;timer/counter 0 compare match A
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
        ldi r18, 0x02
        out TCCR0A, r18         ;set TCCR0A to 0b00000010 (wgm01 high) (clear on ocr0a match)
        ldi r18, 0x05
        out TCCR0B, r18         ;set prescaler to 0b101 (clk/1024)
        ldi r18, 0x02
        sts TIMSK0, r18         ;set output compare intr. enable A
        ldi r18, 0xFF
        out OCR0A, r18          ;set out match for 0xFF
        sei

        ldi r18, 0x03
        ldi r19, 0x06
        ldi r17, 0x01
        out DDRB, r19           ;r24 = 6 -> set pin PB1 & PB2 to output
        out PORTB, r17          ;r1 = set pb0 to pull up
        nop                     ;for synchronization
        ldi r20, 0

stupid_loop:                    ;temporary nonsense
        ldi r18, 0x03
        ldi r19, 0x06
        ldi r17, 0x01
        jmp stupid_loop

while:
        ldi r25, 0
        in r25, PINB            ;read pb
        andi r25, 0x1
        breq PB2_toggle         ;toggle pb2 if button pressed
next_blink:
        out PORTB, r17          ;r1 = set pb0 to pull up
        out PORTB, r18          ;all the output pins to drive high
        jmp while


PB2_toggle:
        push r20
        ldi r20, 0x04
        eor r18, r20            ;toggle pb2
        pop r20
        jmp next_blink

toggle_pb1:
        push r21
        ldi r21, 0x04
        eor r20, r21
        out PORTB, r20
        pop r21
        reti

_exit:
        cli
__bad_interrupt:
        jmp 0
