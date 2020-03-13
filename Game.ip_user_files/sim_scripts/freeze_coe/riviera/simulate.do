onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+freeze_coe -L xil_defaultlib -L xpm -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.freeze_coe xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {freeze_coe.udo}

run -all

endsim

quit -force
