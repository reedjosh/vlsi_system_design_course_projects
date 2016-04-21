//==========================================
//=========================== sine_gen =====
//==========================================
module sine_gen( input  logic                clk, reset,
                 output logic unsigned [7:0] adc );

    logic unsigned [7:0] addr, val;
    logic unsigned [1:0] cnt;
    logic clk_10_mhz;

    assign adc = val;

    always_ff @(posedge clk_10_mhz, negedge reset) begin
        if (~reset) begin
            addr = 0;
            //cnt <= 0;
            end
        else addr <= addr + 1;
          //  case(cnt) 
          //      0 : begin
          //          addr <= addr + 1;
          //          end
          //      1 : begin
          //          addr <= addr + 1;
          //          end
          //      2 : begin
          //          addr <= addr + 1;
          //          end
          //      3 : begin
          //          addr <= addr + 1;
          //          end
          //  endcase
        end

    clk_10_mhz	clk_10_mhz_inst (
    	.areset ( reset      ),
    	.inclk0 ( clk        ),
    	.c0     ( clk_10_mhz ) );

  //  rom_1 sine(
  //  	.address ( addr ),
  //  	.clock   ( clk  ),
  //  	.q       ( val  ) );
    
    sine_rom sine2 (
    	.addr ( addr ),
    	.clk  ( clk_10_mhz  ),
    	.val  ( val  ) );

endmodule
