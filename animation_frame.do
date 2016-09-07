vlib work

vlog FinalProject.v

vsim animation_frame

log {/*}
add wave {/*}

force clock 1 0, 0 10 -repeat 20 -cancel 100000

force {reset} 1
force {enable} 1
run 10ns

force {reset} 0
force {enable} 1
run 90ns