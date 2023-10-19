`timescale 1ns / 1ns // `timescale 


module rotatingRegister( SW, KEY, LEDR );

	input [9:0] SW;
	input [3:0] KEY;
	output [7:0] LEDR;


	rotating_8Bit_Register R1( .DATA_IN(SW[7:0]), 
										.LSRight(~KEY[3]), 
										.RotateRight(~KEY[2]), 
										.ParallelLoadn(~KEY[1]), 
										.clock(~KEY[0]), 
										.reset(SW[9]), 
										.Q(LEDR[7:0]) );

endmodule




module rotating_8Bit_Register( DATA_IN, LSRight, RotateRight, ParallelLoadn, clock, reset, Q );

	input [7:0] DATA_IN;
	input LSRight, RotateRight, ParallelLoadn, clock, reset;
	output [7:0] Q;

	wire b0, b1, b2, b3, b4, b5, b6, b7, b8;
	
	mux2to1 LSMux( .x(b0), .y(1'b0), .s(LSRight), .m(b8) ); //Logical Shift Right Register for Bit 7 (make it 0)

	FF_sub_circuit Bit7 ( b8, b6, RotateRight, DATA_IN[7], ParallelLoadn, clock, reset, b7);
	FF_sub_circuit Bit6 ( b7, b5, RotateRight, DATA_IN[6], ParallelLoadn, clock, reset, b6);
	FF_sub_circuit Bit5 ( b6, b4, RotateRight, DATA_IN[5], ParallelLoadn, clock, reset, b5);
	FF_sub_circuit Bit4 ( b5, b3, RotateRight, DATA_IN[4], ParallelLoadn, clock, reset, b4);
	FF_sub_circuit Bit3 ( b4, b2, RotateRight, DATA_IN[3], ParallelLoadn, clock, reset, b3);
	FF_sub_circuit Bit2 ( b3, b1, RotateRight, DATA_IN[2], ParallelLoadn, clock, reset, b2);
	FF_sub_circuit Bit1 ( b2, b0, RotateRight, DATA_IN[1], ParallelLoadn, clock, reset, b1);
	FF_sub_circuit Bit0 ( b1, b7, RotateRight, DATA_IN[0], ParallelLoadn, clock, reset, b0);
	
	assign Q[7:0] = {b7, b6, b5, b4, b3, b2, b1, b0};

endmodule



module FF_sub_circuit( left, right, loadLeft, D, loadn, clock, reset, Q );

	input left, right, loadLeft, D, loadn, clock, reset;
	output Q;
	wire w1, w2;

	mux2to1 mux0( .x(right), .y(left), .s(loadLeft), .m(w1) );
	mux2to1 mux1( .x(D), .y(w1), .s(loadn), .m(w2) );

	flipFlop FF1( .D(w2), .clk(clock), .reset_b(reset), .Q(Q) );

endmodule




module mux2to1(x, y, s, m);

	input x; //select 0
	input y; //select 1
	input s; //select signal
	output m; //output

	assign m = s & y | ~s & x ;

endmodule 




module flipFlop ( D, clk, reset_b, Q );

	input D, clk, reset_b;
	output reg Q;
	
	always@(posedge clk)
		begin
			if(reset_b == 1'b1) //active-high synch reset
				Q <= 1'b0;
			else
				Q <= D;
		end
		
endmodule 
