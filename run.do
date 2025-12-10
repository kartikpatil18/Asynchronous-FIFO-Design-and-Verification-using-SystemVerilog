vlog list.svh
vsim -novopt -suppress 12110 tb
add wave -r sim:/tb/pif/*
run -all
