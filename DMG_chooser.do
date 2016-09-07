vlib work

vlog damage.v

vsim DMG_chooser

log {/*}
add wave {/*}

force clock 1 0, 0 500 -repeat 1000 -cancel 100000

force {in_qa} 1
force {in_vt} 0
force {in_tb} 0
run 10 ns

force {in_qa} 0
force {in_vt} 1
force {in_tb} 0
run 10 ns

force {in_qa} 0
force {in_vt} 0
force {in_tb} 1
run 10 ns

force {in_qa} 0
force {in_vt} 0
force {in_tb} 0
run 10 ns