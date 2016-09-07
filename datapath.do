vlib work

vlog FinalProject.v
vlog damage.v
vlog drawWhite.v
vlog drawHP.v
vlog drawMeowth.v
vlog drawPikachu.v
vlog drawTeamRocket.v
vlog drawTrainer.v
vlog quick_attack.v

vlog HP5069x3.v
vlog meowth3843x3.v
vlog pikachu3021x3.v
vlog teamrocket4970x3.v
vlog trainer3717x3.v

vsim -L altera_mf_ver -L work work.datapath

log {/*}
add wave {/*}

force clock 1 0, 0 10 -repeat 20 -cancel 100000
#force clock 1 0, 0 1000 -repeat 2000 -cancel 100000

force {reset_all} 1
force {enable_draw_pika} 0
run 10ns

force {reset_all} 0
force {enable_draw_pika} 1
run 90ns