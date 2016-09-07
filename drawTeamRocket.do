vlib work

vlog drawTeamRocket.v
vlog teamrocket4970x3.v

vsim -L altera_mf_ver -L work work.drawTeamRocket

log {/*}
add wave {/*}

force clock_all 1 0, 0 10 -repeat 20 -cancel 100000
#force clock 1 0, 0 1000 -repeat 2000 -cancel 100000

force {reset_all} 0
force {enable_all} 0
run 10ns

force {reset_all} 1
force {enable_all} 1
force {x_[8]} 0
force {x_[7]} 0
force {x_[6]} 0
force {x_[5]} 0
force {x_[4]} 0
force {x_[3]} 0
force {x_[2]} 0
force {x_[1]} 0
force {x_[0]} 0
force {y_[7]} 0
force {y_[6]} 0
force {y_[5]} 0
force {y_[4]} 0
force {y_[3]} 0
force {y_[2]} 0
force {y_[1]} 0
force {y_[0]} 0
run 90ns