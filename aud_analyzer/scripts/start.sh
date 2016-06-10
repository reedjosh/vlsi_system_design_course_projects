
    # Compile Design
    #do system.do
    # Load Design
    cd ../mpd 
    ## vsim -t 100ps -L cycloneive_ver -L altera_mf_ver work.uart_tb -do ../scripts/sim.do  </dev/tty1 >/dev/null &
    vsim -t 100ps work.top_tb -do ../scripts/sim.do  </dev/tty1 >/dev/null &
    # Set Stimulus
