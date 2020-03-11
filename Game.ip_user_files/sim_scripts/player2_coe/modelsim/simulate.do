onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -L xil_defaultlib -L xpm -L unisims_ver -L unimacro_ver -L secureip -lib xil_defaultlib xil_defaultlib.player2_coe xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {player2_coe.udo}

run -all

quit -force
