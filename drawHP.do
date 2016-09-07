vlib work

vlog drawHP.v
vlog HP5069x3.v

vsim -L altera_mf_ver -L work work.drawHP

log {/*}
add wave {/*}

force clock_all 1 0, 0 1 -repeat 2 -cancel 100000

force {enable_all} 0
force {reset_all} 0
run 10ns

force {enable_all} 1
force {reset_all} 1
run 90ns