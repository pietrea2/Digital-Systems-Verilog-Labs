# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog Morse_Code_Encoder.v

#load simulation using mux as the top level simulation module
vsim Morse_Code_Encoder

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/Morse_Code_Encoder/CLOCK_50}
add wave {/Morse_Code_Encoder/counter}
add wave {/Morse_Code_Encoder/SW}
add wave {/Morse_Code_Encoder/code_select}
add wave {/Morse_Code_Encoder/morse_code}
add wave {/Morse_Code_Encoder/KEY}
add wave {/Morse_Code_Encoder/show_code}
add wave {/Morse_Code_Encoder/asynch_reset}
add wave {/Morse_Code_Encoder/enable_pulse}
add wave {/Morse_Code_Encoder/LEDR}
add wave {/Morse_Code_Encoder/morse_output}


force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0

force CLOCK_50 0, 1 1ns -repeat 2ns

force {KEY[0]} 1
force {KEY[1]} 1
run 100ns



# Press button to display letter I
force {KEY[0]} 1
force {KEY[1]} 0
run 200500010ns



# Switch to selecting letter L
force {SW[0]} 1
force {SW[1]} 1
force {SW[2]} 0
force {KEY[0]} 1
force {KEY[1]} 1
run 50000010ns



# Display Letter L
force {KEY[0]} 1
force {KEY[1]} 0
run 400000010ns

force {KEY[0]} 1
force {KEY[1]} 0
run 25000010ns



# Test ASYNCH RESET
force {KEY[0]} 0
force {KEY[1]} 0
run 25000010ns



force {KEY[0]} 1
force {KEY[1]} 1
run 100000010ns




