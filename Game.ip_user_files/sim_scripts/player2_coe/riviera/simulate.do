onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+player2_coe -L xil_defaultlib -L xpm -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.player2_coe xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {player2_coe.udo}

run -all

endsim

quit -force
