//==========================================
//=========================== sine_gen =====
//==========================================
module sine_gen( input  logic                clk, reset,
                 output logic unsigned [7:0] dac );

    logic unsigned [7:0] addr, val;
    enum {up, down} cnt_state, sine_state;
    logic clk_10_khz;

    pll_10_khz	pll_10_khz_inst (
    	.inclk0 ( clk        ),
    	.c0     ( clk_10_khz ) );

    assign adc = val;

    always_ff @(posedge clk_10_khz, negedge reset) begin
        if (~reset) begin
            addr = 0;
            end
        else begin
            if      (addr == 254) cnt_state <= down;
            else if (addr == 1)   cnt_state <= up;
            case(sine_state)
                up   : if (addr == 1 && cnt_state == down)   sine_state <= down;
                down : if (addr == 1 && cnt_state == down) sine_state <= up;
                endcase
            case(cnt_state)
                up :   addr <= addr+1;
                down : addr <= addr-1;
                endcase
            end
        end

    always_comb
        case(sine_state)
            up   : dac <= val;
            down : dac <= 255-val;
            endcase

    sine_rom sine (
    	.addr ( addr ),
    	.clk  ( clk  ),
    	.val  ( val  ) );

    endmodule


//module sine_gen_tb ( );
//
//    logic reset, clk;
//
//    initial begin
//        clk = 0;
//        reset = 0;
//        #10;
//        reset = 1;
//        end
//    
//    always #5 clk = ~clk;
//
//    sine_gen uut (
//        .clk   ( clk ),
//        .reset ( reset ) );
//
//    endmodule

    

    
