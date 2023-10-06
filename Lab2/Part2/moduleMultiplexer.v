`timescale 1ns / 1ns // `timescale time_unit/time_precision

module moduleMultiplexer (SW, LEDR); //module name and port list

  input [9:0] SW;
  output [9:0] LEDR;
  wire w1, w2, w3;
  
  v7404 U1( .pin1(SW[2]), 
            .pin2(w1));
				
  v7408 U2( .pin1(w1), 
            .pin2(SW[0]), 
				.pin3(w2), 
				.pin4(SW[1]), 
				.pin5(SW[2]), 
				.pin6(w3) ); 
				
  v7432 U3( .pin1(w3), 
            .pin2(w2), 
				.pin3(LEDR[0]) );
  
endmodule
  
  
  
  
  
module v7404 (input pin1, pin3, pin5, pin9, pin11, pin13,    //6 NOT gates
              output pin2,pin4, pin6, pin8, pin10, pin12);
      
      //how the pins are functioning inside chip
      assign pin2 = ~pin1;
      assign pin4 = ~pin3;
      assign pin6 = ~pin5;
      assign pin8 = ~pin9;
      assign pin10 = ~pin11;
      assign pin12 = ~pin13;
		
endmodule

  
module v7408 (input pin1, pin2, pin4, pin5, pin9, pin10, pin12, pin13,  //4 AND gates
              output pin3, pin6, pin8, pin11);
      
      //how the pins are functioning inside chip
      assign pin3 = pin1 & pin2;
      assign pin6 = pin4 & pin5;
      assign pin8 = pin9 & pin10;
      assign pin11 = pin12 & pin13;
		
endmodule
 
  
  
module v7432 (input pin1, pin2, pin4, pin5, pin9, pin10, pin12, pin13,   //4 OR gates
              output pin3, pin6, pin8, pin11);
      
      //how the pins are functioning inside chip
      assign pin3 = pin1 | pin2;
      assign pin6 = pin4 | pin5;
      assign pin8 = pin9 | pin1;
      assign pin11 = pin12 | pin13;
		
endmodule
  
  
 