`timescale 1ns/1ns

module RippleCarryAdder4b ( SW , LEDR );

 input [8:0] SW;
 output [9:0] LEDR;
 wire w0, w1, w2;

 FullAdder U1 ( .a(SW[4]), .b(SW[0]), .cin(SW[8]), .s(LEDR[0]), .cout(w0) );
 FullAdder U2 ( .a(SW[5]), .b(SW[1]), .cin(w0), .s(LEDR[1]), .cout(w1) );
 FullAdder U3 ( .a(SW[6]), .b(SW[2]), .cin(w1), .s(LEDR[2]), .cout(w2) );
 FullAdder U4 ( .a(SW[7]), .b(SW[3]), .cin(w2), .s(LEDR[3]), .cout(LEDR[9]) );

endmodule




module FullAdder ( input a, b, cin, output s, cout );

 assign s = a ^ b ^ cin;
 assign cout = (a&b) + (b&cin) + (a&cin);

endmodule