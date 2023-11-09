module Divider_Function(SW, KEY, CLOCK_50, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
    input [9:0] SW;
    input [3:0] KEY;
    input CLOCK_50;
    output [9:0] LEDR;
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

    wire resetn;
    wire go;
	 wire next_calc;

    wire [8:0] data_result;
    assign go = ~KEY[1];            //Press go = KEY[1] to start calculation
    assign resetn = KEY[0];         //Press KEY[0] to reset 
	 assign next_calc = ~KEY[2];     //Press KEY[2] to do next calculation

    part3 u0(
        .clk(CLOCK_50),
        .resetn(resetn),
        .go(go),
		  .next_calc(next_calc),
        .data_in(SW[7:0]),
        .data_result(data_result)
    );
      
    assign LEDR[8:0] = data_result; //data_result[8:4] = Remainder
												//data_result[3:0] = Quotient

	 //Quotient
    hex_decoder H0( .hex_digit(data_result[3:0]), .segments(HEX1) );
        
	 //Remainder
    hex_decoder H1( .hex_digit(data_result[7:4]), .segments(HEX0) );
		  
    //Divisor
	 hex_decoder H2( .hex_digit(SW[3:0]), .segments(HEX2) );
	 
	 //Dividend
	 hex_decoder H3( .hex_digit(SW[7:4]), .segments(HEX4) );
	 
	 hex_decoder H4( .hex_digit(4'b0), .segments(HEX5) );
	 hex_decoder H5( .hex_digit(4'b0), .segments(HEX3) );

endmodule

module part3(
    input clk,
    input resetn,
    input go,
	 input next_calc,
    input [7:0] data_in,
    output [8:0] data_result
    );

    // lots of wires to connect our datapath and control
    wire regA_msb, dividend_msb;
    wire ld_divisor_dividend, left_shift, add, sub, set_q0;
	 wire [2:0] shift_count;

    control C0(
        .clk(clk),
        .resetn(resetn),
        .go(go),
		  .next_calc(next_calc),
        
        .regA_msb(regA_msb), 
        .dividend_msb(dividend_msb),
		  .shift_count(shift_count),
		  
        .ld_divisor_dividend(ld_divisor_dividend),
        .left_shift(left_shift),
        .add(add), 
        .sub(sub), 
        .set_q0(set_q0)
    );

    datapath D0(
        .clk(clk),
        .resetn(resetn),
		  .data_in(data_in),

        .ld_divisor_dividend(ld_divisor_dividend),
        .left_shift(left_shift),
        .add(add), 
        .sub(sub), 
        .set_q0(set_q0),

        .data_result(data_result),
		  .regA_msb(regA_msb), 
        .dividend_msb(dividend_msb),
		  .shift_count(shift_count)
    );
                
 endmodule        
                

module control(
    input clk,
    input resetn,
    input go,
	 input next_calc,
	 input regA_msb,
	 input dividend_msb,
	 input [2:0] shift_count,

    output reg ld_divisor_dividend,
    output reg left_shift,
    output reg add,
	 output reg sub,
    output reg set_q0
    );

    reg [3:0] current_state, next_state; 
    
    localparam  S_LOAD_Divisor_Dividend = 5'd0,
                S_LOAD_DD_WAIT   = 5'd1,
                S_CYCLE_0       = 5'd2,
                S_CYCLE_1       = 5'd3,
                S_CYCLE_2       = 5'd4,
					 S_CYCLE_3       = 5'd5,
					 S_CYCLE_4       = 5'd6,
					 S_CYCLE_5       = 5'd7,
					 S_CYCLE_5_WAIT  = 5'd8;
    
    // Next state logic aka our state table
    always@(*)
    begin: state_table 
            case (current_state)
                S_LOAD_Divisor_Dividend: next_state = go ? S_LOAD_DD_WAIT : S_LOAD_Divisor_Dividend; // Loop in current state until value is input
                S_LOAD_DD_WAIT: next_state = go ? S_LOAD_DD_WAIT : S_CYCLE_0; // Loop in current state until go signal goes low
                S_CYCLE_0: next_state = S_CYCLE_1;  // Left Shift
                S_CYCLE_1: next_state = S_CYCLE_2;  // RegA - Divisor
					 S_CYCLE_2: next_state = shift_count ? S_CYCLE_0 : S_CYCLE_5;  // Check MSB
					 S_CYCLE_5: next_state = next_calc ? S_CYCLE_5_WAIT : S_CYCLE_5; 
					 S_CYCLE_5_WAIT: next_state = next_calc ? S_CYCLE_5_WAIT : S_LOAD_Divisor_Dividend; 
            default:     next_state = S_LOAD_Divisor_Dividend;
        endcase
    end // state_table
   

    // Output logic aka all of our datapath control signals
    always @(*)
    begin: enable_signals
        // By default make all our signals 0 to avoid latches.
        // This is a different style from using a default statement.
        // It makes the code easier to read.  If you add other out
        // signals be sure to assign a default value for them here.
        ld_divisor_dividend = 1'b0;
        left_shift = 1'b0;
        add = 1'b0;
		  sub = 1'b0;
        set_q0 = 1'b0;

        case (current_state)
            S_LOAD_Divisor_Dividend: begin
                ld_divisor_dividend = 1'b1;
					 
                end
            S_CYCLE_0: begin // Do Left Shift
                left_shift = 1'b1; 
            end
				S_CYCLE_1: begin // RegA - Divisor
                sub = 1'b1;
            end
            S_CYCLE_2: begin //Check MSB
                if(regA_msb)begin
						add = 1'b1;
					 end
					 else begin
						set_q0 = 1'b1;
					 end
            end
        // default:    // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
    end // enable_signals
   
    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(!resetn)
            current_state <= S_LOAD_Divisor_Dividend;
        else
            current_state <= next_state;
    end // state_FFS
endmodule

module datapath(
    input clk,
    input resetn,
    input [7:0] data_in,
    input ld_divisor_dividend, 
    input left_shift,
    input add,
    input sub, 
    input set_q0,
	 
    output reg [8:0] data_result,
	 output reg regA_msb,
	 output reg dividend_msb,
	 output reg [2:0] shift_count
    );
    
    // registers
    reg [4:0] divisor, regA;
    reg [3:0] dividend;
	 reg left_shift_msb;
	 reg [2:0] count;
    
    // Registers with respective input logic
    always@(posedge clk) begin
        if(!resetn) begin
            divisor <= 5'b0; 
            regA <= 5'b0; 
            dividend <= 4'b0;
        end
        else begin
            if(ld_divisor_dividend) begin
                divisor <= {1'b0, data_in[3:0]};
					 regA <= 5'b0;
					 dividend <= data_in[7:4];
					 
					 if(data_in[4] == 1'b1)
					     count = 4;
				    if(data_in[5:4] == {1'b1, 1'b0})
					     count = 3;
					 if(data_in[6:4] == {1'b1, 1'b0, 1'b0})
					     count = 2;
					 if(data_in[7:4] == {1'b1, 1'b0, 1'b0, 1'b0})
					     count = 1;
					 
					 shift_count <= count;
				end 
            if(left_shift) begin
                left_shift_msb = dividend[3];
					 dividend <= dividend << 1;
					 regA <= regA << 1;
					 regA[0] <= left_shift_msb;
					 shift_count <= shift_count - 1;
				end
            if(add) begin
                regA <= regA + divisor;
					 dividend[0] <= 1'b0;
				end
            if(sub)
                regA <= regA - divisor;
				if(set_q0)
				    dividend[0] <= 1'b1;
				    
        end
    end
 
    // Output result register
    always@(*) begin
        if(!resetn) begin
            data_result <= 8'b0; 
        end
        else 
            data_result <= {regA, dividend};
				regA_msb <= regA[4];
				dividend_msb <= dividend[3];
    end
 
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


