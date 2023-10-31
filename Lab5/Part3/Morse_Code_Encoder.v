`timescale 1ns / 1ns

module Morse_Code_Encoder (CLOCK_50, SW, KEY, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);

	input CLOCK_50;
	input [2:0] SW;
	input [1:0] KEY;
	
	output [1:0] LEDR;
	output [6:0] HEX0;
	output [6:0] HEX1;
	output [6:0] HEX2;
	output [6:0] HEX3;
	output [6:0] HEX4;
	output [6:0] HEX5;

	wire [2:0] code_select;
	assign code_select = SW[2:0];
	
	wire [12:0] morse_code;
	wire [26:0] counter;
	assign counter = 27'b0;
	
	wire enable_pulse;
	
	wire show_code;
	assign show_code = ~KEY[1];
	
	wire asynch_reset;
	assign asynch_reset = ~KEY[0];
	
	wire morse_output;
	
	MorseCodeMux mux1 ( code_select, morse_code );
	
	RateDivider rate1 ( CLOCK_50, counter, enable_pulse );
	
	ShiftRegister reg1 ( .code(morse_code), .right_shift(show_code), .clock(CLOCK_50), .reset(asynch_reset), .enable_shift(enable_pulse), .Q(morse_output) );
	
	assign LEDR[0] = morse_output;
	
	
	
	
	//Additional HEX letter display
	MorseHEXLetterDecoder HEXdec1 (show_code, code_select, HEX5, HEX4, HEX3, HEX2);
	assign HEX1[6:0] = 7'b1111111;
	MorseHEXDecoder HEXdec2 (morse_output, HEX0);
	

endmodule





// multiplexer module for choosing Morse Codes for Letters
module MorseCodeMux(select, code);

	input [2:0] select;
	output reg [12:0] code;

	always @ (*)
	begin
		case (select[2:0])
			3'b000: code = 13'b101;  //I
			3'b001: code = 13'b1110111011101;  //J
			3'b010: code = 13'b111010111;  //K
			3'b011: code = 13'b101011101;  //L
			3'b100: code = 13'b1110111;  //M
			3'b101: code = 13'b10111;  //N
			3'b110: code = 13'b11101110111;  //O
			3'b111: code = 13'b10111011101;  //P
		endcase
	end
	
endmodule




//Creates enable signal that pulses every 0.5s (THis is a 2Hz pule)
//Therefore need to count to 25M to get 2Hz
module RateDivider (clock, counter, enable);

	input clock;
	output reg [26:0] counter;
	output reg enable;

	always @ (posedge clock)
	begin
		if (counter == 27'b0)
		begin
			counter <= 27'b001011111010111100000111111; //25M - 1 = 24 999 999
			enable <= 1;
		end
		else if (counter === 27'bx)
		begin
			counter <= 27'b0;
		end
		else
		begin
			counter <= counter - 1;
			enable <= 0;
		end
	end

endmodule






module ShiftRegister( code, right_shift, clock, reset, enable_shift, Q );

	input [12:0] code;
	input right_shift, clock, reset, enable_shift	;
	output Q;

	wire b11, b10, b9, b8, b7, b6, b5, b4, b3, b2, b1, b0;

	FF_sub_circuit Bit12 ( .D(code[12]), .left(1'b0), .shift(right_shift), .clock(clock), .reset(reset), .enable(enable_shift), .Q(b12) );
	FF_sub_circuit Bit11 ( .D(code[11]), .left(b12), .shift(right_shift), .clock(clock), .reset(reset), .enable(enable_shift), .Q(b11) );
	FF_sub_circuit Bit10 ( .D(code[10]), .left(b11), .shift(right_shift), .clock(clock), .reset(reset), .enable(enable_shift), .Q(b10) );
	FF_sub_circuit Bit9 ( .D(code[9]), .left(b10), .shift(right_shift), .clock(clock), .reset(reset), .enable(enable_shift), .Q(b9) );
	FF_sub_circuit Bit8 ( .D(code[8]), .left(b9), .shift(right_shift), .clock(clock), .reset(reset), .enable(enable_shift), .Q(b8) );
	FF_sub_circuit Bit7 ( .D(code[7]), .left(b8), .shift(right_shift), .clock(clock), .reset(reset), .enable(enable_shift), .Q(b7) );
	FF_sub_circuit Bit6 ( .D(code[6]), .left(b7), .shift(right_shift), .clock(clock), .reset(reset), .enable(enable_shift), .Q(b6) );
	FF_sub_circuit Bit5 ( .D(code[5]), .left(b6), .shift(right_shift), .clock(clock), .reset(reset), .enable(enable_shift), .Q(b5) );
	FF_sub_circuit Bit4 ( .D(code[4]), .left(b5), .shift(right_shift), .clock(clock), .reset(reset), .enable(enable_shift), .Q(b4) );
	FF_sub_circuit Bit3 ( .D(code[3]), .left(b4), .shift(right_shift), .clock(clock), .reset(reset), .enable(enable_shift), .Q(b3) );
	FF_sub_circuit Bit2 ( .D(code[2]), .left(b3), .shift(right_shift), .clock(clock), .reset(reset), .enable(enable_shift), .Q(b2) );
	FF_sub_circuit Bit1 ( .D(code[1]), .left(b2), .shift(right_shift), .clock(clock), .reset(reset), .enable(enable_shift), .Q(b1) );
	FF_sub_circuit Bit0 ( .D(code[0]), .left(b1), .shift(right_shift), .clock(clock), .reset(reset), .enable(enable_shift), .Q(b0) );

	assign Q = b0;

endmodule



module FF_sub_circuit( D, left, shift, clock, reset, enable, Q );

	input D, left, shift, clock, reset, enable;
	output Q;
	wire w1;

	mux2to1 mux1( .x(D), .y(left), .s(shift), .m(w1) );

	flipFlop FF1( .D(w1), .clk(clock), .reset_b(reset), .enable(enable), .Q(Q) );

endmodule




module mux2to1(x, y, s, m);

	input x; //select 0
	input y; //select 1
	input s; //select signal
	output m; //output

	assign m = s ? y : x;

endmodule 




module flipFlop ( D, clk, reset_b, enable, Q );

	input D, clk, reset_b, enable;
	output reg Q;
	
	always@(posedge clk, posedge reset_b)
		begin
			if(reset_b == 1'b1) //active-high asynch reset
				Q <= 1'b0;
			else if(enable == 1'b1)
				Q <= D;
		end
		
endmodule 




module MorseHEXDecoder(code, HEXoutput);

	input code;
	output reg [6:0] HEXoutput;
	
	always @ (*)
	begin
		case (code)
			1'b1: HEXoutput = 7'b1000000;
			1'b0: HEXoutput = 7'b1111111;
		endcase
	end
	
endmodule




module MorseHEXLetterDecoder(display, morse_code, output1, output2, output3, output4);

	input display;
	input [2:0] morse_code;
	output reg [6:0] output1;
	output reg [6:0] output2;
	output reg [6:0] output3;
	output reg [6:0] output4;
	
	always @ (*)
	begin
		case (display)
			1'b1: begin
						case(morse_code[2:0])
							3'b000: begin					//I
										output1 = 7'b1111111;  
										output2 = 7'b1111111;
										output3 = 7'b1111001;
										output4 = 7'b1111111;
									  end
							3'b001: begin					//J
										output1 = 7'b1111111;  
										output2 = 7'b1111111;
										output3 = 7'b1110000;
										output4 = 7'b1111111;
									  end
							3'b010: begin					//K
										output1 = 7'b1111111;  
										output2 = 7'b1111111;
										output3 = 7'b0000111;
										output4 = 7'b1111111;
									  end
							3'b011: begin					//L
										output1 = 7'b1111111;  
										output2 = 7'b1111111;
										output3 = 7'b1000111;
										output4 = 7'b1111111;
									  end
							3'b100: begin					//M
										output1 = 7'b1111111;  
										output2 = 7'b1111111;
										output3 = 7'b0101011;
										output4 = 7'b0101011;
									  end
							3'b101: begin					//N
										output1 = 7'b1111111;  
										output2 = 7'b1111111;
										output3 = 7'b0101011;
										output4 = 7'b1111111;
									  end
							3'b110: begin					//O
										output1 = 7'b1111111;  
										output2 = 7'b1111111;
										output3 = 7'b0100011;
										output4 = 7'b1111111;
									  end
							3'b111: begin					//P
										output1 = 7'b1111111;  
										output2 = 7'b1111111;
										output3 = 7'b0001100;
										output4 = 7'b1111111;
									  end
						endcase
					end
			1'b0: begin
						output1 = 7'b0100001; //done 
						output2 = 7'b0100011;
						output3 = 7'b0101011;
						output4 = 7'b0000110;
					end
		endcase
	end


endmodule

