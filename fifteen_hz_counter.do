vlib work

vlog FinalProject.v

vsim fifteen_hz_counter

log {/*}
add wave {/*}

force pulse 1 0, 0 100 -repeat 200 -cancel 100000

force {reset} 1
force {enable_fifteen} 1
run 10ns

force {reset} 0
force {enable_fifteen} 1
run 90ns