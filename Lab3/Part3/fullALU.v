`timescale 1ns/1ns

module fullALU ( SW, KEY, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 );

	input  [7:0] SW;
	input  [2:0] KEY;
			
	output [7:0] LEDR;
	output [6:0] HEX0;
	output [6:0] HEX1;
	output [6:0] HEX2;
	output [6:0] HEX3;
	output [6:0] HEX4;
	output [6:0] HEX5;
			 
	wire [7:0] Output;
			
	ALU U0 ( .A(SW[7:4]), .B(SW[3:0]), .C(KEY[2:0]), .ALUout( Output[7:0] ) );

	assign LEDR[7:0] = Output[7:0];

	HEX U1( Output[7:4], HEX5 );

	HEX U2( Output[3:0], HEX4 );

	wire [3:0] ZERO;
	assign ZERO = 4'b0000;

	HEX U3 ( ZERO, HEX3 );
	HEX U4 ( ZERO, HEX1 );

	HEX U5 ( SW[7:4], HEX2 );
	HEX U6 ( SW[3:0], HEX0 );


endmodule 






module ALU ( A, B, C, ALUout );

input [3:0] A;
input [3:0] B;
input [2:0] C;
output reg [7:0] ALUout;

//have to invert the key inputs
//bc unpressed push button = 1
wire [2:0] pushButtons;
assign pushButtons = ~C;

//Adder output
wire [4:0] adderOutput;
fullAdder A1( .IN({A, B}) , .OUT(adderOutput) );


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





module fullAdder ( IN , OUT );

 input [7:0] IN;
 output [4:0] OUT;
 wire w0, w1, w2;

 adder U1 ( .a(IN[4]), .b(IN[0]), .cin(1'b0), .s(OUT[0]), .cout(w0) );
 adder U2 ( .a(IN[5]), .b(IN[1]), .cin(w0), .s(OUT[1]), .cout(w1) );
 adder U3 ( .a(IN[6]), .b(IN[2]), .cin(w1), .s(OUT[2]), .cout(w2) );
 adder U4 ( .a(IN[7]), .b(IN[3]), .cin(w2), .s(OUT[3]), .cout(OUT[4]) );

endmodule





module adder ( input a, b, cin, output s, cout );

 assign s = a ^ b ^ cin;
 assign cout = (a&b) + (b&cin) + (a&cin);

endmodule




module h0 (input p0, p1, p2, p3, output p4);

assign p4 = ~( ( (~p0)|p1|p2|p3 )&( p0|p1|(~p2)|p3 )&( (~p0)|(~p1)|p2|(~p3) )&( (~p0)|p1|(~p2)|(~p3) ) );

endmodule 

module h1 (input p0, p1, p2, p3, output p4);

assign p4 = ~( ( (~p0)|p1|(~p2)|p3 )&( p0|(~p1)|(~p2)|p3 )&( (~p0)|(~p1)|p2|(~p3) )&( p0|p1|(~p2)|(~p3) )&( p0|(~p1)|(~p2)|(~p3) )&( (~p0)|(~p1)|(~p2)|(~p3) ) );

endmodule 

module h2 (input p0, p1, p2, p3, output p4);

assign p4 = ~( ( p0|(~p1)|p2|p3 )&( p0|p1|(~p2)|(~p3) )&( p0|(~p1)|(~p2)|(~p3) )&( (~p0)|(~p1)|(~p2)|(~p3) ) );

endmodule 

module h3 (input p0, p1, p2, p3, output p4);

assign p4 = ~( ( (~p0)|p1|p2|p3 )&( p0|p1|(~p2)|p3 )&( (~p0)|(~p1)|(~p2)|p3 )&( (~p0)|p1|p2|(~p3) )&( p0|(~p1)|p2|(~p3) )&( (~p0)|(~p1)|(~p2)|(~p3) ) );

endmodule 

module h4 (input p0, p1, p2, p3, output p4);

assign p4 = ~( ( (~p0)|p1|p2|p3 )&( (~p0)|(~p1)|p2|p3 )&( p0|p1|(~p2)|p3 )&( (~p0)|p1|(~p2)|p3 )&( (~p0)|(~p1)|(~p2)|p3 )&( (~p0)|p1|p2|(~p3) ) );

endmodule 

module h5 (input p0, p1, p2, p3, output p4);

assign p4 = ~( ( (~p0)|p1|p2|p3 )&( p0|(~p1)|p2|p3 )&( (~p0)|(~p1)|p2|p3 )&( (~p0)|(~p1)|(~p2)|p3)&( (~p0)|p1|(~p2)|(~p3) ) );

endmodule 

module h6 (input p0, p1, p2, p3, output p4);

assign p4 = ~( ( p0|p1|p2|p3 )&( (~p0)|p1|p2|p3 )&( (~p0)|(~p1)|(~p2)|p3 )&( p0|p1|(~p2)|(~p3) ) );

endmodule 




module HEX( IN, OUT );  

input [3:0] IN;
output [6:0] OUT;

h0 U1( .p0(IN[0]), .p1(IN[1]), .p2(IN[2]), .p3(IN[3]), .p4(OUT[0]) );
h1 U2( .p0(IN[0]), .p1(IN[1]), .p2(IN[2]), .p3(IN[3]), .p4(OUT[1]) );
h2 U3( .p0(IN[0]), .p1(IN[1]), .p2(IN[2]), .p3(IN[3]), .p4(OUT[2]) );
h3 U4( .p0(IN[0]), .p1(IN[1]), .p2(IN[2]), .p3(IN[3]), .p4(OUT[3]) );
h4 U5( .p0(IN[0]), .p1(IN[1]), .p2(IN[2]), .p3(IN[3]), .p4(OUT[4]) );
h5 U6( .p0(IN[0]), .p1(IN[1]), .p2(IN[2]), .p3(IN[3]), .p4(OUT[5]) );	
h6 U7( .p0(IN[0]), .p1(IN[1]), .p2(IN[2]), .p3(IN[3]), .p4(OUT[6]) );

endmodule 


