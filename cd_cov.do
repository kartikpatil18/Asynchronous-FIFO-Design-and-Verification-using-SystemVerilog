vlog list.svh
vopt tb +cover=fcbest -o CONCURRENT
vsim -coverage CONCURRENT
coverage save -onexit CON.ucdb
add wave -r sim:/tb/pif/*
run -all
