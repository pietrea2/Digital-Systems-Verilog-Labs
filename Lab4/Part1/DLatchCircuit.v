`timescale 1ns/1ns

module DLatchCircuit (SW, LEDR);

	input [9:0] SW;
	output [1:0] LEDR;
	
	wire  s, r, clk, s_g, r_g, w0, w1, Qa, Qb;
	assign s = SW[0];
	assign clk = SW[1];
	
	v7404 U1( .pin1(s),		//NOT gate for R signal
				 .pin2(r) );

	v7400 U2( .pin1(s),
				 .pin2(clk),
				 .pin3(s_g) );
	
	v7400 U3( .pin4(r),
				 .pin5(clk),
				 .pin6(r_g) );
				 
	v7400 U4( .pin9(s_g),
				 .pin10(w1),
				 .pin8(w0) );
				 
	v7400 U5( .pin12(r_g),
				 .pin13(w0),
				 .pin11(w1) );
	
	assign Qa = w0;		//Gated D Latch Output Signals
	assign Qb = w1;
	
	assign LEDR[0] = Qa;
	assign LEDR[1] = Qb;
	

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
      assign pin8 = pin9 | pin10;
      assign pin11 = pin12 | pin13;
		
endmodule



module v7400 (input pin1, pin2, pin4, pin5, pin9, pin10, pin12, pin13,   //4 NAND gates
              output pin3, pin6, pin8, pin11);
      
      //how the pins are functioning inside chip
      assign pin3 = ~(pin1 & pin2);
      assign pin6 = ~(pin4 & pin5);
      assign pin8 = ~(pin9 & pin10);
      assign pin11 = ~(pin12 & pin13);
		
endmodule