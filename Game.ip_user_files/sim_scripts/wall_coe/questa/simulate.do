onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib wall_coe_opt

do {wave.do}

view wave
view structure
view signals

do {wall_coe.udo}

run -all

quit -force
