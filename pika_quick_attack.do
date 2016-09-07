vlib work

vlog quick_attack.v
vlog drawPikachu.v

vsim -L altera_mf_ver -L work work.quick_attack

log {/*}
add wave {/*}

force clock 1 0, 0 1 -repeat 2 -cancel 100000

#state reset
force {reset_all} 0
force {enable_animate} 0
force {enable_p_qa} 0
force {enable_draw_pika} 0
run 10ns

#state draw_pikachu
force {reset_all} 1
force {enable_animate} 0
force {enable_p_qa} 0
force {enable_draw_pika} 1
run 10ns

#state idle_p_qa
force {reset_all} 1
force {enable_animate} 1
force {enable_p_qa} 0
force {enable_draw_pika} 0
run 10ns

#state erase_pikachu
force {reset_all} 1
force {enable_animate} 0
force {enable_p_qa} 0
force {enable_draw_pika} 1
run 10ns

#state p_qa
force {reset_all} 1
force {enable_animate} 0
force {enable_p_qa} 0
force {enable_draw_pika} 1
run 10ns




#state draw_pikachu
force {reset_all} 1
force {enable_animate} 0
force {enable_p_qa} 0
force {enable_draw_pika} 1
run 10ns

#state idle_p_qa
force {reset_all} 1
force {enable_animate} 1
force {enable_p_qa} 0
force {enable_draw_pika} 0
run 10ns

#state erase_pikachu
force {reset_all} 1
force {enable_animate} 0
force {enable_p_qa} 0
force {enable_draw_pika} 1
run 10ns

#state p_qa
force {reset_all} 1
force {enable_animate} 0
force {enable_p_qa} 0
force {enable_draw_pika} 1
run 10ns

