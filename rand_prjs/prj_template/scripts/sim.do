  
    # Set Stimulus
    force /sev_seg/clk     0   0 ns, 1 {10 ns} -r 20 ns
    force /sev_seg/reset   0 100 ns, 1 {200 ns}
    force /sev_seg/encoder 0 100 ns, 1 {200 ns}
    # Add Signals to Waveform
    add wave *
    # Run simulation
    run 2 us
