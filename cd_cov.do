vlog list.svh
vopt tb +cover=fcbest -o OVERFLOW
vsim -coverage OVERFLOW
coverage save -onexit OV.ucdb
add wave -r sim:/tb/pif/*
run -all

