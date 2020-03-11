onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib player1_coe_opt

do {wave.do}

view wave
view structure
view signals

do {player1_coe.udo}

run -all

quit -force
