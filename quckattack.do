vlib work

vlog FinalProject.v

#quickattack
vsim -L altera_mf_ver -L work work.datapath

log {/*}
add wave {/*}

force clock 1 0, 0 1000 -repeat 2000 -cancel 100000

#reset
force {reset_all} 1
force {enable_draw_pika} 0
force {enable_animate} 0
force {enable_p_qa} 0
force {choose_colour} 0
force {choose_x_mode} 0
force {choose_y_mode} 0
run 10ns

#draw
force {reset_all} 0
force {enable_draw_pika} 1
force {enable_animate} 0
force {enable_p_qa} 0
force {choose_colour} 0
force {choose_x_mode} 0
force {choose_y_mode} 0
run 10ns

#idle
force {reset_all} 0
force {enable_draw_pika} 0
force {enable_animate} 1
force {enable_p_qa} 0
force {choose_colour} 0
force {choose_x_mode} 0
force {choose_y_mode} 0
run 10ns

#erase
force {reset_all} 0
force {enable_draw_pika} 1
force {enable_animate} 0
force {enable_p_qa} 0
force {choose_colour} 1
force {choose_x_mode} 0
force {choose_y_mode} 0
run 10ns

#change x and y
force {reset_all} 0
force {enable_draw_pika} 0
force {enable_animate} 0
force {enable_p_qa} 1
force {choose_colour} 0
force {choose_x_mode} 0
force {choose_y_mode} 0
run 1ns

force {reset_all} 0
force {enable_draw_pika} 0
force {enable_animate} 0
force {enable_p_qa} 1
force {choose_colour} 0
force {choose_x_mode} 0
force {choose_y_mode} 0
run 1ns

force {reset_all} 0
force {enable_draw_pika} 0
force {enable_animate} 0
force {enable_p_qa} 1
force {choose_colour} 0
force {choose_x_mode} 0
force {choose_y_mode} 0
run 1ns