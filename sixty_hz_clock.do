vlib work

vlog FinalProject.v

vsim sixty_hz_clock

log {/*}
add wave {/*}

force clock 1 0, 0 100 -repeat 200 -cancel 100000

force {reset} 1
force {enable_sixty} 1
run 10ns

force {reset} 0
force {enable_sixty} 1
run 90ns