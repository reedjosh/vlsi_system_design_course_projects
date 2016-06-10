vsim
transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/josh/Documents/vsys/sine_gen/qpd {/home/josh/Documents/vsys/sine_gen/qpd/pll_10_khz.v}
vlog -vlog01compat -work work +incdir+/home/josh/Documents/vsys/sine_gen/qpd/db {/home/josh/Documents/vsys/sine_gen/qpd/db/pll_10_khz_altpll.v}
vlog -sv -work work +incdir+/home/josh/Documents/vsys/sine_gen/scripts {/home/josh/Documents/vsys/sine_gen/scripts/sine_rom.sv}
vlog -sv -work work +incdir+/home/josh/Documents/vsys/sine_gen/src {/home/josh/Documents/vsys/sine_gen/src/sine_gen.sv}

