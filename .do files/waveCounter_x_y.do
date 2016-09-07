vlib work

vlog counter_x_y.v

vsim pika_counter_x_y

log {/*}
add wave {/*}

force clock 1 0, 0 10 -repeat 20 -cancel 100000

force {reset_c} 1
run 10ns

force {reset_c} 0
run 90ns