onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib player2_coe_opt

do {wave.do}

view wave
view structure
view signals

do {player2_coe.udo}

run -all

quit -force
