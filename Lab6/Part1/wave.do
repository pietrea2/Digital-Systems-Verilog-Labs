# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog sequence_detector.v

#load simulation using mux as the top level simulation module
vsim sequence_detector

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
#add wave {/sequence_detector/KEY[0]}
#add wave {/sequence_detector/SW[0]}
#add wave {/sequence_detector/SW[1]}
add wave {/sequence_detector/clock}
add wave {/sequence_detector/resetn}
add wave {/sequence_detector/w}
add wave {/sequence_detector/y_Q}
add wave {/sequence_detector/Y_D}
add wave {/sequence_detector/LEDR}
add wave {/sequence_detector/out_light}

# SW[0] = active-low reset
# SW[1] = input signal


force {SW[0]} 1
force {SW[1]} 0
force {KEY[0]} 1
run 1ns

# input 0
force {SW[0]} 1
force {SW[1]} 0
force {KEY[0]} 0
run 1ns

force {SW[0]} 1
force {SW[1]} 0
force {KEY[0]} 1
run 1ns

# input 1
force {SW[0]} 1
force {SW[1]} 1
force {KEY[0]} 0
run 1ns

force {SW[0]} 1
force {SW[1]} 1
force {KEY[0]} 1
run 1ns

# input 1
force {SW[0]} 1
force {SW[1]} 1
force {KEY[0]} 0
run 1ns

force {SW[0]} 1
force {SW[1]} 1
force {KEY[0]} 1
run 1ns

# input 0
force {SW[0]} 1
force {SW[1]} 0
force {KEY[0]} 0
run 1ns

force {SW[0]} 1
force {SW[1]} 0
force {KEY[0]} 1
run 1ns

# input final 1 for sequence
force {SW[0]} 1
force {SW[1]} 1
force {KEY[0]} 0
run 1ns

force {SW[0]} 1
force {SW[1]} 1
force {KEY[0]} 1
run 1ns


force {SW[0]} 1
force {SW[1]} 1
force {KEY[0]} 0
run 1ns

force {SW[0]} 1
force {SW[1]} 1
force {KEY[0]} 1
run 1ns

force {SW[0]} 1
force {SW[1]} 1
force {KEY[0]} 0
run 1ns

force {SW[0]} 1
force {SW[1]} 1
force {KEY[0]} 1
run 1ns

force {SW[0]} 1
force {SW[1]} 1
force {KEY[0]} 0
run 1ns

force {SW[0]} 1
force {SW[1]} 1
force {KEY[0]} 1
run 1ns

force {SW[0]} 1
force {SW[1]} 1
force {KEY[0]} 0
run 1ns

force {SW[0]} 1
force {SW[1]} 1
force {KEY[0]} 1
run 1ns

# Test Reset (active low)
force {SW[0]} 0
force {SW[1]} 1
force {KEY[0]} 0
run 1ns

force {SW[0]} 1
force {SW[1]} 1
force {KEY[0]} 1
run 1ns




