// ADC implementation
// By Joshua Reed
// Created Spring 2016
// Designed for the DEO-Nano

// ADC -> ADC128S022CIMTX
//
//  | Pin Number |  ADC_Function  | SPI Name |
//  |            |                |          |
//  | PIN_A10    |  Chip Select   | CS       |
//  | PIN_B10    |  Data In(ADC)  | MOSI     |
//  | PIN_A9     |  Data Out(ADC) | MISO     |
//  | PIN_B14    |  Serial Clock  | SCK      |
//
// Analog In 1 is pin 25 of the 2x13 pin header
//
// SCLK will run at 1/2 of the input clock

module adc( input  logic clk, reset, MISO,
            input  logic unsigned [2:0] addr,
            output logic ready, MOSI, SCLK,
            output logic unsigned [11:0] data );

    logic unsigned [3:0] cnt;
    logic unsigned [15:0] MOSI_sr; // Shift register
    logic unsigned [15:0] MISO_sr; // Shift register

    // 0-15 counter with rollover
    always_ff@( posedge clk, negedge reset )
        if (~reset) begin
            cnt <= 0;
            end
        else begin
            if (cnt == 15) cnt <= 0;
            else cnt <= cnt+1;
            end

    // spi comms & shift regs
    always_ff@( posedge clk, negedge reset )
        if (~reset) begin
            ready <= 0;
            data <= 0;
            MISO_sr <= 0;
            MOSI_sr <= 0;
            end
        else 
            case(cnt) 
               15 : begin // setup MOSI_sr
                    MOSI_sr <= {2'b00,addr,10'b0000000000};
                    data <= MISO_sr[15:4]; // latch data bits
                    ready <= 1; // inicate good data
                    end
                default : begin
                    MOSI_sr <= MOSI_sr >> 1;
                    MISO_sr <= {MISO_sr[15:1], MISO};
                    ready <= 0;
                    end
                endcase
    
    assign SCLK = cnt[0];     
    assign MOSI = MOSI_sr[0];

    endmodule


//module adc_tb( ); // no signals -- tb
//
//    logic clk, reset, MISO;
//    logic ready, MOSI, SCLK;
//    logic unsigned [11:0] data;
//
//    initial begin
//        $display(       " <<              >> ");
//        $display(       " <<              >> ");
//        $display(       " <<              >> ");
//        $display(       " <<              >> ");
//        $display(       " <<              >> ");
//        $display(       " << Sim Starting >> ");
//        $display(       " <<              >> ");
//        $display(       " <<              >> ");
//        $display(       " <<              >> ");
//        $display(       " <<              >> ");
//        clk = 0;
//        reset = 0;
//        #20 reset = 1;
//        end
//
//    always #500us clk = ~clk; // invert 500us
//
//    adc uut(
//        .clk   ( clk         ), 
//        .reset ( reset       ), 
//        .MISO  ( 1'b1        ), 
//        .addr  ( 3'b011      ),
//        .ready (             ),
//        .MOSI  (             ), 
//        .SCLK  (             ), 
//        .data  (             ) );
//
//    endmodule















