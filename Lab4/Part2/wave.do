# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog FullALU_8Bit_Register.v

#load simulation using mux as the top level simulation module
vsim FullALU_8Bit_Register

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

# SW[3:0]  = A
# SW[8]    = cin
# KEY[3:1] = funct
# KEY[0]   = clk
# SW[9]    = reset_b
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0

force {SW[8]} 0

force {KEY[1]} 1
force {KEY[2]} 1
force {KEY[3]} 1

force {KEY[0]} 1

force {SW[9]} 0
run 10ns



force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0

force {SW[8]} 1

force {KEY[1]} 1
force {KEY[2]} 1
force {KEY[3]} 1

force {KEY[0]} 0

force {SW[9]} 1
run 10ns



force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0

force {SW[8]} 1

force {KEY[1]} 1
force {KEY[2]} 1
force {KEY[3]} 1

force {KEY[0]} 1

force {SW[9]} 1
run 10ns


# 1 + 1 = 2 (now in register after 1 clk cycle) 
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0

force {SW[8]} 0

force {KEY[1]} 1
force {KEY[2]} 1
force {KEY[3]} 1

force {KEY[0]} 1

force {SW[9]} 1
run 10ns



# Check ALU Case 1: Using + operator for addition
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0

force {SW[8]} 0

force {KEY[1]} 0
force {KEY[2]} 1
force {KEY[3]} 1

force {KEY[0]} 1

force {SW[9]} 1
run 10ns



# Check ALU Case 2
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0

force {SW[8]} 0

force {KEY[1]} 1
force {KEY[2]} 0
force {KEY[3]} 1

force {KEY[0]} 1

force {SW[9]} 1
run 10ns



# Check ALU Case 3
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0

force {SW[8]} 0

force {KEY[1]} 0
force {KEY[2]} 0
force {KEY[3]} 1

force {KEY[0]} 1

force {SW[9]} 1
run 10ns



# Set A = 5, add to register value (2)
# Start clk cycle
force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 1
force {SW[3]} 0

force {SW[8]} 0

force {KEY[1]} 1
force {KEY[2]} 1
force {KEY[3]} 1

force {KEY[0]} 0

force {SW[9]} 1
run 10ns



# Done 5 + 2 = 7 now, stored in register
# Done clk cycle
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0

force {SW[8]} 0

force {KEY[1]} 1
force {KEY[2]} 1
force {KEY[3]} 1

force {KEY[0]} 1

force {SW[9]} 1
run 10ns



# A = 3, B = 7
# Check ALU Case 4: two 1's in A, three 1's in B
force {SW[0]} 1
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 0

force {SW[8]} 0

force {KEY[1]} 1
force {KEY[2]} 1
force {KEY[3]} 0

force {KEY[0]} 1

force {SW[9]} 1
run 10ns



# Start Reset of register, start clk cycle
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0

force {SW[8]} 0

force {KEY[1]} 1
force {KEY[2]} 1
force {KEY[3]} 1

force {KEY[0]} 0

force {SW[9]} 0
run 10ns




# Done Reset of register, done clk cycle
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0

force {SW[8]} 0

force {KEY[1]} 1
force {KEY[2]} 1
force {KEY[3]} 1

force {KEY[0]} 1

force {SW[9]} 0
run 10ns




# 0 + F -> store in register, start clk cycle
force {SW[0]} 1
force {SW[1]} 1
force {SW[2]} 1
force {SW[3]} 1

force {SW[8]} 0

force {KEY[1]} 1
force {KEY[2]} 1
force {KEY[3]} 1

force {KEY[0]} 0

force {SW[9]} 1
run 10ns




# Done 0 + F -> stored in register
# Done clk cycle
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0

force {SW[8]} 0

force {KEY[1]} 1
force {KEY[2]} 1
force {KEY[3]} 1

force {KEY[0]} 1

force {SW[9]} 1
run 10ns




# Check ALU Case 5: ALUout = { B, ~A }
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0

force {SW[8]} 0

force {KEY[1]} 0
force {KEY[2]} 1
force {KEY[3]} 0

force {KEY[0]} 1

force {SW[9]} 1
run 10ns




# Check ALU Case 6: ALUout = { A ^ B, A ~^ B }
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0

force {SW[8]} 0

force {KEY[1]} 1
force {KEY[2]} 0
force {KEY[3]} 0

force {KEY[0]} 1

force {SW[9]} 1
run 10ns




# Check ALU Case 7: ALUout = stored register value
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0

force {SW[8]} 0

force {KEY[1]} 0
force {KEY[2]} 0
force {KEY[3]} 0

force {KEY[0]} 1

force {SW[9]} 1
run 10ns