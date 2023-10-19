`timescale 1ns/1ns

module HEX_Dec( SW, HEX0 );

	input [3:0] SW;
	output [6:0] HEX0;
	
	HEX U1( .IN(SW[3:0]), .OUT(HEX0[6:0]) );
	

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



