# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog poly_function.v

#load simulation using mux as the top level simulation module
vsim poly_function

#log all signals and add some signals to waveform window
log {/*}
add wave {/SW}
add wave {/KEY}
add wave {/CLOCK_50}

add wave {/u0/data_result}

add wave {/u0/C0/current_state}
add wave {/u0/C0/next_state}

add wave {/u0/data_in}
add wave {/u0/D0/a}
add wave {/u0/D0/b}
add wave {/u0/D0/c}
add wave {/u0/D0/x}
add wave {/u0/D0/alu_out}
add wave {/u0/D0/alu_a}
add wave {/u0/D0/alu_b}


add wave {/u0/ld_a}
add wave {/u0/ld_b}
add wave {/u0/ld_c}
add wave {/u0/ld_x}
add wave {/u0/ld_alu_out}
add wave {/u0/alu_select_a}
add wave {/u0/alu_select_b}
add wave {/u0/alu_op}
add wave {/u0/ld_r}



# KEY[0] = synch active low reset
# KEY[1] = go signal (clk)
# SW[7:0] = data in



# Perform RESET
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0
force {SW[4]} 0
force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 0

force {KEY[0]} 0
force {KEY[1]} 1

force CLOCK_50 0, 1 1ns -repeat 2ns
run 5ns




# Done RESET
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0
force {SW[4]} 0
force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 0

force {KEY[0]} 1
force {KEY[1]} 1
run 5ns



# Data in = 5 (reg_a)
force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 1
force {SW[3]} 0
force {SW[4]} 0
force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 0

force {KEY[0]} 1
force {KEY[1]} 1
run 5ns



# Data in = 5 (reg_a) start go press
force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 1
force {SW[3]} 0
force {SW[4]} 0
force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 0

force {KEY[0]} 1
force {KEY[1]} 0
run 5ns




# Data in = 4 (reg_b)
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 1
force {SW[3]} 0
force {SW[4]} 0
force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 0

force {KEY[0]} 1
force {KEY[1]} 1
run 5ns




# Data in = 4 start go press
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 1
force {SW[3]} 0
force {SW[4]} 0
force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 0

force {KEY[0]} 1
force {KEY[1]} 0
run 5ns




# Data in = 3 (reg_c)
force {SW[0]} 1
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 0
force {SW[4]} 0
force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 0

force {KEY[0]} 1
force {KEY[1]} 1
run 5ns



# Data in = 3 (reg_c) start go press
force {SW[0]} 1
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 0
force {SW[4]} 0
force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 0

force {KEY[0]} 1
force {KEY[1]} 0
run 5ns



# Data in = 2 (reg_x)
force {SW[0]} 0
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 0
force {SW[4]} 0
force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 0

force {KEY[0]} 1
force {KEY[1]} 1
run 5ns



# Data in = 2 (reg_x) start go press
force {SW[0]} 0
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 0
force {SW[4]} 0
force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 0

force {KEY[0]} 1
force {KEY[1]} 0
run 5ns



# Cycles begin
force {SW[0]} 0
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 0
force {SW[4]} 0
force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 0

force {KEY[0]} 1
force {KEY[1]} 1
run 15ns

