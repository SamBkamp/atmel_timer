#include <avr/io.h> //for pin/port/data direction constants
#include <util/delay.h> //for delay

int main(int argc, char* argv[]){
  //setup
  DDRB = 0b00000010; //set pb1 to output

  //loop
  while(1){
    PORTB = 0;
    _delay_ms(1000); //one second
    PORTB = 0b00000010;
    _delay_ms(1000); //one second
  }
}
