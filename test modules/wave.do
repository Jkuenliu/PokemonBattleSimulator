onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /datapath/clock
add wave -noupdate /datapath/reset_all
add wave -noupdate /datapath/enable_pc_xy
add wave -noupdate /datapath/enable_pac
add wave -noupdate /datapath/done_pikachu
add wave -noupdate /datapath/out_x
add wave -noupdate /datapath/out_y
add wave -noupdate /datapath/out_colour
add wave -noupdate /datapath/pika_address
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {53357 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 204
configure wave -valuecolwidth 241
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {33869 ps} {103481 ps}
