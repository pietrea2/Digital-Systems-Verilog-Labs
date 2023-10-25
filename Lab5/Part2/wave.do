# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog Rate_HEX_Counter.v

#load simulation using mux as the top level simulation module
vsim Rate_HEX_Counter

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/Rate_HEX_Counter/SW}
add wave {/Rate_HEX_Counter/CLOCK_50}
add wave {/Rate_HEX_Counter/countBound}
add wave {/Rate_HEX_Counter/counter}
add wave {/Rate_HEX_Counter/enable_pulse}
add wave {/Rate_HEX_Counter/HEX_count}



force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
force {SW[9]} 0
force CLOCK_50 0
run 1ns

force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
force {SW[9]} 0
force CLOCK_50 1
run 1ns


force CLOCK_50 0, 1 1ns -repeat 2ns
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
force {SW[9]} 1
run 1ns

force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 1
force {SW[9]} 1
run 25000000ns

force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 0
force {SW[9]} 1
run 50000010ns

