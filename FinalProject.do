vlib work

vlog FinalProject.v
vlog quick_attack.v
vlog drawPikachu.v

vsim -L altera_mf_ver -L work work.FinalProject

log {/*}
add wave {/*}

force CLOCK_50 1 0, 0 1 -repeat 2 -cancel 100000

force {KEY[0]} 1
run 10ns

force {KEY[0]} 0
run 90ns