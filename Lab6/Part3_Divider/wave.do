# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog Divider_Function.v

#load simulation using mux as the top level simulation module
vsim Divider_Function

#log all signals and add some signals to waveform window
log {/*}
add wave {/SW}
add wave {/KEY}
add wave {/CLOCK_50}


add wave {/u0/data_result}
add wave {/LEDR}
add wave {/HEX0}
add wave {/HEX1}


add wave {/u0/C0/current_state}
add wave {/u0/C0/next_state}

add wave {/resetn}
add wave {/go}


add wave {/u0/data_in}
add wave {/u0/D0/divisor}
add wave {/u0/D0/regA}
add wave {/u0/D0/dividend}
add wave {/u0/D0/left_shift_msb}


add wave {/u0/ld_divisor_dividend}
add wave {/u0/left_shift}
add wave {/u0/add}
add wave {/u0/sub}
add wave {/u0/set_q0}
add wave {/u0/regA_msb}
add wave {/u0/dividend_msb}


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
force {KEY[2]} 1

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
force {KEY[2]} 1
run 5ns



# Set Divisor and Dividend input
force {SW[0]} 1
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 0
force {SW[4]} 1
force {SW[5]} 1
force {SW[6]} 1
force {SW[7]} 0

force {KEY[0]} 1
force {KEY[1]} 1
force {KEY[2]} 1
run 5ns



# Start go press
force {SW[0]} 1
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 0
force {SW[4]} 1
force {SW[5]} 1
force {SW[6]} 1
force {SW[7]} 0

force {KEY[0]} 1
force {KEY[1]} 0
force {KEY[2]} 1
run 5ns




# Release go button, start division
force {SW[0]} 1
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 0
force {SW[4]} 1
force {SW[5]} 1
force {SW[6]} 1
force {SW[7]} 0

force {KEY[0]} 1
force {KEY[1]} 1
force {KEY[2]} 1
run 30ns



# Start next division
force {SW[0]} 0
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 0
force {SW[4]} 1
force {SW[5]} 1
force {SW[6]} 0
force {SW[7]} 0

force {KEY[0]} 1
force {KEY[1]} 1
force {KEY[2]} 0
run 5ns


# Start next division
force {SW[0]} 0
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 0
force {SW[4]} 1
force {SW[5]} 1
force {SW[6]} 0
force {SW[7]} 0

force {KEY[0]} 1
force {KEY[1]} 1
force {KEY[2]} 1
run 5ns


# Start go press
force {SW[0]} 0
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 0
force {SW[4]} 1
force {SW[5]} 1
force {SW[6]} 0
force {SW[7]} 0

force {KEY[0]} 1
force {KEY[1]} 0
force {KEY[2]} 1
run 5ns




# Release go button, start division
force {SW[0]} 0
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 0
force {SW[4]} 1
force {SW[5]} 1
force {SW[6]} 0
force {SW[7]} 0

force {KEY[0]} 1
force {KEY[1]} 1
force {KEY[2]} 1
run 36ns




