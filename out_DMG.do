vlib work

vlog damage.v

vsim out_DMG

log {/*}
add wave {/*}

force clock 1 0, 0 500 -repeat 1000 -cancel 100000

force {in} 000
force {enable_DMG_reg} 0
run 1 ns

#simulating going through an attack loop
force {in} 000
force {enable_DMG_reg} 1
run 1 ns

force {in} 000
force {enable_DMG_reg} 0
run 1 ns

force {in} 000
force {enable_DMG_reg} 0
run 1 ns

force {in} 001
force {enable_DMG_reg} 1
run 1 ns

force {in} 000
force {enable_DMG_reg} 0
run 1 ns

force {in} 001
force {enable_DMG_reg} 1
run 1 ns