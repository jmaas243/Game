onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+player1_coe -L xil_defaultlib -L xpm -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.player1_coe xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {player1_coe.udo}

run -all

endsim

quit -force
