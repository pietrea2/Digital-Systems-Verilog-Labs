`timescale 1ns / 1ns

module Rate_HEX_Counter (CLOCK_50, SW, HEX0, LEDR);

	input CLOCK_50;
	input [9:0] SW;
	output [6:0] HEX0;
	output [3:0] LEDR;

	wire [2:0] freq_select;
	wire reset;
	
	wire [26:0] countBound;
	wire [26:0] counter;
	wire enable_pulse;
	wire [3:0] HEX_count;
	
	assign freq_select[2:0] = SW[2:0];
	assign reset = SW[9];

	ClockFreqMux mux1 ( .select(freq_select[2:0]), .count(countBound) );
	
	RateDivider rate1 ( .count_bound(countBound), .count(counter), .clock(CLOCK_50), .enable(enable_pulse) );
	
	HEXCounter_4Bit count1 ( .enable(enable_pulse), .clock(CLOCK_50), .clear(reset), .Q_out(HEX_count) ); 

	HEX hexDecoder1 ( .IN(HEX_count), .OUT(HEX0) );
	
	assign LEDR[3:0] = HEX_count[3:0];

endmodule





// multiplexer module for choosing clock frequency
module ClockFreqMux(select, count);

	input [2:0] select;
	output reg [26:0] count;

	always @ (*)
	begin
		case (select[2:0])
			3'b000: count = 27'b000000000000000000000000000;
			3'b001: count = 27'b001011111010111100000111111;
			3'b010: count = 27'b010111110101111000001111111;
			3'b011: count = 27'b101111101011110000011111111;
			3'b100: count = 27'b000101111101011110000011111;
		endcase
	end
	
endmodule




// needs to count down to zero (which will trigger an enable signal for HEXCounter_4Bit)
// needs to be parallel loaded when it reaches zero
// needs to be attached to CLOCK_50
module RateDivider (count_bound, count, clock, enable);

	input [26:0] count_bound;
	input clock;
	output reg [26:0] count;
	output reg enable;

	always @ (posedge clock)
	begin
		if (count == 27'b0)
		begin
			count <= count_bound;
			enable <= 1;
		end
		else if (count === 27'bx)
		begin
			count <= 27'b0;
		end
		else
		begin
			count <= count - 1;
			enable <= 0;
		end
	end

endmodule




// needs to count from 0-F (i.e. 0000-1111) when enable is 1
// needs to reset when hits 1111
// needs to be attached to CLOCK_50
module HEXCounter_4Bit (enable, clock, clear, Q_out);

	input enable, clock, clear;
	output reg [3:0] Q_out;

	always @ (posedge clock)
	begin
		if (clear == 1'b0)
			Q_out <= 0;
		else if (enable == 1'b1)
			Q_out <= Q_out + 1;
	end

endmodule




module HEX( IN, OUT );  

	input [3:0] IN;
	output [6:0] OUT;
	
	wire a, b, c, d;
	assign a = IN[0];
	assign b = IN[1];
	assign c = IN[2];
	assign d = IN[3];
	
	assign OUT[0] = ~( (~a|b|c|d) & (a|b|~c|d) & (~a|~b|c|~d) & (~a|b|~c|~d) );
	assign OUT[1] = ~( (~a|b|~c|d) & (a|~b|~c|d) & (~a|~b|c|~d) & (a|b|~c|~d) & (a|~b|~c|~d) & (~a|~b|~c|~d) );
	assign OUT[2] = ~( (a|~b|c|d) & (a|b|~c|~d) & (a|~b|~c|~d) & (~a|~b|~c|~d) );
	assign OUT[3] = ~( (~a|b|c|d) & (a|b|~c|d) & (~a|~b|~c|d) & (~a|b|c|~d) & (a|~b|c|~d) & (~a|~b|~c|~d) );
	assign OUT[4] = ~( (~a|b|c|d) & (~a|~b|c|d) & (a|b|~c|d) & (~a|b|~c|d) & (~a|~b|~c|d) & (~a|b|c|~d) );
	assign OUT[5] = ~( (~a|b|c|d) & (a|~b|c|d) & (~a|~b|c|d) & (~a|~b|~c|d) & (~a|b|~c|~d) );
	assign OUT[6] = ~( (a|b|c|d) & (~a|b|c|d) & (~a|~b|~c|d) & (a|b|~c|~d) );

endmodule 