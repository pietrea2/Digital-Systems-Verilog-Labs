# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog fullALU.v

#load simulation using mux as the top level simulation module
vsim fullALU

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

#adding A + B using Ripple Carry Adder
force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0

force {SW[4]} 1
force {SW[5]} 1
force {SW[6]} 0
force {SW[7]} 0

force {KEY[0]} 1
force {KEY[1]} 1
force {KEY[2]} 1
run 10ns

#adding A + B using + operator
force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0

force {SW[4]} 1
force {SW[5]} 1
force {SW[6]} 0
force {SW[7]} 0

force {KEY[0]} 0
force {KEY[1]} 1
force {KEY[2]} 1
run 10ns

#A NAND B in the lower four bits of ALUout and A NOR B in the upper four bits
force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0

force {SW[4]} 1
force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 0

force {KEY[0]} 1
force {KEY[1]} 0
force {KEY[2]} 1
run 10ns

#Output 8’b11000000 if at least 1 of the 8 bits in the two inputs is 1
force {SW[0]} 1
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 0

force {SW[4]} 1
force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 0

force {KEY[0]} 0
force {KEY[1]} 0
force {KEY[2]} 1
run 10ns

#Output 8’b00111111 if exactly 2 bits of the A switches is 1, and exactly 3 bits of the B switches are 1
force {SW[0]} 1
force {SW[1]} 1
force {SW[2]} 1
force {SW[3]} 0

force {SW[4]} 1
force {SW[5]} 1
force {SW[6]} 0
force {SW[7]} 0

force {KEY[0]} 1
force {KEY[1]} 1
force {KEY[2]} 0
run 10ns

#Display the B switches in the most sig 4 bits of output, and complement of A in least sig bits
force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0

force {SW[4]} 1
force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 0

force {KEY[0]} 0
force {KEY[1]} 1
force {KEY[2]} 0
run 10ns

#A XNOR B in lower 4 bits, A XOR in upper four bits
force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0

force {SW[4]} 1
force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 0

force {KEY[0]} 1
force {KEY[1]} 0
force {KEY[2]} 0
run 10ns