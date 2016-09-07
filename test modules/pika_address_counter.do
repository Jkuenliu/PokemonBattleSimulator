vlib work

vlog FinalProject.v

vsim pika_address_counter

log {/*}
add wave {/*}

force clock 1 0, 0 10 -repeat 20 -cancel 100000

force {reset_c} 1
run 10ns

force {reset_c} 0
run 90ns