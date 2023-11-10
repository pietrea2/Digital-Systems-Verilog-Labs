`timescale 1ns / 1ns

module ram_embed_module(SW, HEX0, HEX2, HEX4, HEX5, KEY);

	 input [9:0] SW;
	 input [1:0] KEY;
	 output [6:0] HEX0, HEX2, HEX4, HEX5;
	 
	 wire [4:0] address;
	 wire clock;
	 wire [3:0] data_in;
	 wire write_en;
	 wire [3:0] data_out;
	 
    assign address = SW[8:4];
	 assign clock = ~KEY[0];
	 assign data_in = SW[3:0];
	 assign write_en = SW[9];
	 
	
	 ram32x4 RAM( .address(address), .clock(clock), .data(data_in), .wren(write_en), .q(data_out) );
	
	 //Display address on HEX5, HEX4
	 hex_decoder H5( {3'b000, address[4]}, HEX5 );
	 hex_decoder H4( address[3:0], HEX4 );
	
	 //Display data in
	 hex_decoder H2( data_in, HEX2 );
	
	 //Display data out
	 hex_decoder H0( data_out, HEX0 );

endmodule





module hex_decoder(hex_digit, segments);
    input [3:0] hex_digit;
    output reg [6:0] segments;
   
    always @(*)
        case (hex_digit)
            4'h0: segments = 7'b100_0000;
            4'h1: segments = 7'b111_1001;
            4'h2: segments = 7'b010_0100;
            4'h3: segments = 7'b011_0000;
            4'h4: segments = 7'b001_1001;
            4'h5: segments = 7'b001_0010;
            4'h6: segments = 7'b000_0010;
            4'h7: segments = 7'b111_1000;
            4'h8: segments = 7'b000_0000;
            4'h9: segments = 7'b001_1000;
            4'hA: segments = 7'b000_1000;
            4'hB: segments = 7'b000_0011;
            4'hC: segments = 7'b100_0110;
            4'hD: segments = 7'b010_0001;
            4'hE: segments = 7'b000_0110;
            4'hF: segments = 7'b000_1110;   
            default: segments = 7'h7f;
        endcase
endmodule