    
    # Compile Design
    #do system.do
    # Load Design
    cd ../mpd 
    vsim -t ps -L cycloneive_ver -L altera_mf_ver work.sine_gen_tb 
    # Set Stimulus
    force -freeze sim:/system/sys_clk 1 0, 0 {10 ns} -r 20 ns
    force -freeze sim:/system/sys_reset 1
    force -freeze sim:/system/sys_reset 0 100 ns, 1 {200 ns}
    # Run simulation
    run 2 us
