  
    # Compile Design
    #do system.do
    # Load Design
    cd ../mpd 
    vsim -t ns -L cycloneive_ver -L altera_mf_ver work.sine_gen -do ../scripts/sim.do 
    # Set Stimulus
