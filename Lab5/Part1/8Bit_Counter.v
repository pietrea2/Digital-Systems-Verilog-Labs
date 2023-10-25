`timescale 1ns / 1ns

module Counter_8Bit(SW, KEY, HEX0, HEX1, LEDR);

	input [1:0] SW;
	input [1:0] KEY;
	output [6:0] HEX0;
	output [6:0] HEX1;
	output [7:0] LEDR;
	
	wire [7:1] Enable;
	wire [7:0] Q_out;
	
	TFLip_Flop tff0 ( .T_enable(SW[1]), .clock(KEY[0]), .clear(SW[0]), .Q_out(Q_out[0]) );
	assign Enable[1] = Q_out[0] & SW[1];
	
	TFLip_Flop tff1 ( .T_enable(Enable[1]), .clock(KEY[0]), .clear(SW[0]), .Q_out(Q_out[1]) );
	assign Enable[2] = Q_out[1] & Enable[1];
	
	TFLip_Flop tff2 ( .T_enable(Enable[2]), .clock(KEY[0]), .clear(SW[0]), .Q_out(Q_out[2]) );
	assign Enable[3] = Q_out[2] & Enable[2];
	
	TFLip_Flop tff3 ( .T_enable(Enable[3]), .clock(KEY[0]), .clear(SW[0]), .Q_out(Q_out[3]) );
	assign Enable[4] = Q_out[3] & Enable[3];
	
	TFLip_Flop tff4 ( .T_enable(Enable[4]), .clock(KEY[0]), .clear(SW[0]), .Q_out(Q_out[4]) );
	assign Enable[5] = Q_out[4] & Enable[4];
	
	TFLip_Flop tff5 ( .T_enable(Enable[5]), .clock(KEY[0]), .clear(SW[0]), .Q_out(Q_out[5]) );
	assign Enable[6] = Q_out[5] & Enable[5];
	
	TFLip_Flop tff6 ( .T_enable(Enable[6]), .clock(KEY[0]), .clear(SW[0]), .Q_out(Q_out[6]) );
	assign Enable[7] = Q_out[6] & Enable[6];
	
	TFLip_Flop tff7 ( .T_enable(Enable[7]), .clock(KEY[0]), .clear(SW[0]), .Q_out(Q_out[7]) );

	HEX Display1 ( .IN( Q_out[7:4] ), .OUT( HEX1 ) );	
	HEX Display2 (. IN( Q_out[3:0] ), .OUT( HEX0 ) );
	
	assign LEDR[7:0] = Q_out[7:0];

endmodule




module TFLip_Flop ( T_enable, clock, clear, Q_out);
	
	input T_enable, clock, clear;
	output reg Q_out;

	always @ ( posedge clock, negedge clear )
		begin
			if ( clear == 0 )
			begin
				Q_out <= 0;
			end
			else if ( T_enable )
			begin
				Q_out <= !Q_out;
			end
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