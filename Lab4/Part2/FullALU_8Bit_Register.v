`timescale 1ns/1ns

module FullALU_8Bit_Register ( SW, KEY, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 );

	input  [9:0] SW;
	input  [3:0] KEY;
			
	output [7:0] LEDR;
	output [6:0] HEX0;
	output [6:0] HEX1;
	output [6:0] HEX2;
	output [6:0] HEX3;
	output [6:0] HEX4;
	output [6:0] HEX5;
			 
	wire [7:0] Output;
	wire [7:0] Register_Output;
			
	ALU ALU0 ( .A(SW[3:0]), .B(Register_Output[3:0]), .cin(SW[8]), .funct(KEY[3:1]), .ALUout(Output[7:0]), .register(Register_Output[7:0]) );
	
	assign LEDR[7:0] = Output[7:0];
	
	//8 bit register
	register_8bit REG0 ( .D(Output[7:0]), .clk(KEY[0]), .reset_b(SW[9]), .Q(Register_Output[7:0]) );
	
	HEX U0 ( SW[3:0], HEX0 ); //display data
	
	wire [3:0] ZERO;
	assign ZERO = 4'b0000;	  //display ZEROs
	HEX U1 ( ZERO, HEX1 );
	HEX U2 ( ZERO, HEX2 );
	HEX U3 ( ZERO, HEX3 );
	
	HEX U4( Register_Output[3:0], HEX4 );
	HEX U5( Register_Output[7:4], HEX5 );


endmodule 





module register_8bit ( D, clk, reset_b, Q );

	input [7:0] D;
	input clk, reset_b;
	output reg [7:0] Q;
	
	always@(posedge clk)
	begin
		if(reset_b == 1'b0)
			Q <= 8'b00000000;
		else
			Q <= D;
	end

endmodule 



module ALU ( A, B, cin, funct, ALUout, register);

	input [3:0] A;
	input [3:0] B;
	input cin;
	input [2:0] funct;
	input [7:0] register;
	output reg [7:0] ALUout;

	//have to invert the key inputs
	//bc unpressed push button = 1
	wire [2:0] pushButtons;
	assign pushButtons = ~funct;

	//Adder output
	wire [4:0] adderOutput;
	fullAdder A1( .IN({A, B}) , .CIN(cin), .OUT(adderOutput) );


	//modules used for counting 1's in A and B
	wire [3:0] countA;
	wire [3:0] countB;
	count_ones C1(.number(A), .count(countA));
	count_ones C2(.number(B), .count(countB));



	always @(*)
		begin
		
			case( pushButtons )
				0: ALUout = adderOutput;
				1: ALUout = A + B;
				2: ALUout = { ~(A | B), ~(A & B) };
				3: begin
						if( A||B )
							ALUout = 8'b11000000;
						else
							ALUout = 8'b00000000;
					end
					
				4: begin
						
						if( countA == 2 && countB == 3)
							ALUout = 8'b00111111;
						else
							ALUout = 8'b00000000;
						
					end
				5: ALUout = { B, ~A };
				6: ALUout = { A ^ B, A ~^ B };
				7: ALUout = register;
				default: ALUout = 8'b00000000;
			endcase
		end

endmodule 






module count_ones(number,count);

   input [3:0] number;
   output reg [3:0] count;
	integer i;
	 
	always @ (*) 
		begin
		
			 count = 0;
			 
			 for (i = 0; i < 4; i = i + 1) 
				  if (number[i] == 1'b1) 
						count = count + 1;
				   
		end

endmodule





module fullAdder ( IN, CIN, OUT );

	input [7:0] IN;
	input CIN;
	output [4:0] OUT;
	wire w0, w1, w2;

	adder U1 ( .a(IN[4]), .b(IN[0]), .cin(CIN), .s(OUT[0]), .cout(w0) );
	adder U2 ( .a(IN[5]), .b(IN[1]), .cin(w0), .s(OUT[1]), .cout(w1) );
	adder U3 ( .a(IN[6]), .b(IN[2]), .cin(w1), .s(OUT[2]), .cout(w2) );
	adder U4 ( .a(IN[7]), .b(IN[3]), .cin(w2), .s(OUT[3]), .cout(OUT[4]) );

endmodule





module adder ( input a, b, cin, output s, cout );

	assign s = a ^ b ^ cin;
	assign cout = (a&b) + (b&cin) + (a&cin);

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