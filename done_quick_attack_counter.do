vlib work

vlog quick_attack.v

vsim done_quick_attack_counter

log {/*}
add wave {/*}

force clock 1 0, 0 1000 -repeat 2000 -cancel 100000

force {pulse} 0
force {enable} 0
force {reset} 0
run 10 ns

force {pulse} 1
force {enable} 1
force {reset} 1
run 10 ns

force {pulse} 0
force {enable} 0
force {reset} 1
run 10 ns

force {pulse} 1
force {enable} 1
force {reset} 1
run 10 ns

force {pulse} 0
force {enable} 0
force {reset} 1
run 10 ns

force {pulse} 1
force {enable} 1
force {reset} 1
run 10 ns

force {pulse} 0
force {enable} 0
force {reset} 1
run 10 ns

force {pulse} 1
force {enable} 1
force {reset} 1
run 10 ns

force {pulse} 0
force {enable} 0
force {reset} 1
run 10 ns