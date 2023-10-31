# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog Morse_Code_Encoder_Ver2.v

#load simulation using mux as the top level simulation module
vsim Morse_Code_Encoder_Ver2

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/Morse_Code_Encoder_Ver2/CLOCK_50}
add wave {/Morse_Code_Encoder_Ver2/counter}
add wave {/Morse_Code_Encoder_Ver2/SW}
add wave {/Morse_Code_Encoder_Ver2/code_select}
add wave {/Morse_Code_Encoder_Ver2/morse_code}
add wave {/Morse_Code_Encoder_Ver2/KEY}
add wave {/Morse_Code_Encoder_Ver2/show_code}
add wave {/Morse_Code_Encoder_Ver2/button_rshift}
add wave {/Morse_Code_Encoder_Ver2/button_counter}
add wave {/Morse_Code_Encoder_Ver2/morse_count}
add wave {/Morse_Code_Encoder_Ver2/asynch_reset}
add wave {/Morse_Code_Encoder_Ver2/enable_pulse}
add wave {/Morse_Code_Encoder_Ver2/LEDR}
add wave {/Morse_Code_Encoder_Ver2/morse_output}


# Select Letter I to display
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0

force CLOCK_50 0, 1 1ns -repeat 2ns

force {KEY[0]} 1
force {KEY[1]} 1
run 100000100ns



#Simulate button press to display, then release
force {KEY[0]} 1
force {KEY[1]} 0
run 50000000ns

force {KEY[0]} 1
force {KEY[1]} 1
run 350000000ns



# Select letter N
force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 1
force {KEY[0]} 1
force {KEY[1]} 1
run 120000000ns




#Simulate button press to display, then release
force {KEY[0]} 1
force {KEY[1]} 0
run 150000000ns

force {KEY[0]} 1
force {KEY[1]} 1
run 500000000ns
