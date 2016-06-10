  
    # Add Signals to Waveform
    restart -f -nowave
    add wave /top_tb/uut1/\*
    #add wave /top_tb/uut1/tx_1/\*
    #add wave /top_tb/uut1/rx_1/\*
    add wave -position end  sim:/top_tb/uut1/receive_buffer
    add wave -position end  sim:/top_tb/uut1/send_buffer

    # Run simulation
    run 20 us
    wave zoom full
