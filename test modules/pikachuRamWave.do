vlib work

vlog pikachu3021x3.v

vsim -L altera_mf_ver -L work work.pikachu3021x3

log {/*}
add wave {/*}

force clock 1 0, 0 2500 -repeat 5000 -cancel 100000

#10000100100 - 1060

force {address[0]} 0
force {address[1]} 0
force {address[2]} 1
force {address[3]} 0
force {address[4]} 0
force {address[5]} 1
force {address[6]} 0
force {address[7]} 0
force {address[8]} 0
force {address[9]} 0
force {address[10]} 1
force {address[11]} 0
force {data[0]} 0
force {data[1]} 0
force {data[2]} 0
force {wren} 0
run 10ns

#10000100101 - 1061
force {address[0]} 1
force {address[1]} 0
force {address[2]} 1
force {address[3]} 0
force {address[4]} 0
force {address[5]} 1
force {address[6]} 0
force {address[7]} 0
force {address[8]} 0
force {address[9]} 0
force {address[10]} 1
force {address[11]} 0
force {data[0]} 0
force {data[1]} 0
force {data[2]} 0
force {wren} 0
run 10ns

#10000100110 - 1062
force {address[0]} 0
force {address[1]} 1
force {address[2]} 1
force {address[3]} 0
force {address[4]} 0
force {address[5]} 1
force {address[6]} 0
force {address[7]} 0
force {address[8]} 0
force {address[9]} 0
force {address[10]} 1
force {address[11]} 0
force {data[0]} 0
force {data[1]} 0
force {data[2]} 0
force {wren} 0
run 10ns

#10000100111 - 1063
force {address[0]} 1
force {address[1]} 1
force {address[2]} 1
force {address[3]} 0
force {address[4]} 0
force {address[5]} 1
force {address[6]} 0
force {address[7]} 0
force {address[8]} 0
force {address[9]} 0
force {address[10]} 1
force {address[11]} 0
force {data[0]} 0
force {data[1]} 0
force {data[2]} 0
force {wren} 0
run 10ns