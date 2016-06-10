  
    # Compile Design
    #do system.do
    # Load Design
    cd ../mpd 
    vsim -t ps -L cycloneive_ver -L altera_mf_ver work.sev_seg -do ../scripts/sim.do
    # Set Stimulus
