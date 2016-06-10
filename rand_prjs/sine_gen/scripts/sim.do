  
    # Set Stimulus
    force /sine_gen/clk 0 0 ns, 1 {10 ns} -r 20 ns
    force sim:/sine_gen/reset 0 100 ns, 1 {200 ns}
    # Add Signals to Waveform
    add wave *
    # Run simulation
    run 2 us
