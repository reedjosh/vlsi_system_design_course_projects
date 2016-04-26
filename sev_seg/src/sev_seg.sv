//==========================================
//=============================== top ======
//==========================================
module sev_seg( input                 clk, reset, 
                input           [7:0] buttons,
                output unsigned [6:0] LEDs, 
                output                pwm,
                output          [0:2] sel );

    logic clk1;
    logic clk2;

    pll_leds pll_leds_inst ( .inclk0 ( clk  ),
        	                 .c2     ( clk1 ) );

    // clock counter divides clk4 by 10
    clk_cntr cc3 ( 
       .reset    ( reset ),
       .cnt_to   (  5    ), 
       .clk      ( clk1  ),
       .clk_o    ( clk2  ) );

    seg_driver disp ( 
        .clk        ( clk1  ),   // refresh rate is 1/4 input clk
        .reset      ( reset ),   
        .num        ( 15    ),   // num to display
        .strobe     ( 1'b1  ),   // update immediately
        .LEDs       ( LEDs  ),   // sev_seg out
        .sel        ( sel   ) ); // segment select bits

    endmodule

//==========================================
//============================== clk_cntr ==
//==========================================
module clk_cntr( input  logic reset, clk,
                 input  int   cnt_to,
                 output logic clk_o );

    logic unsigned [20:0] cnt;

    always_ff @(posedge clk, negedge reset) 
        if (~reset) begin
            clk_o <= 0;
            cnt <= 0; 
            end
        else if (cnt >= cnt_to) begin
            clk_o <= ~clk_o;
            cnt <= 0; 
            end
        else cnt <= cnt+1;

    endmodule

//==========================================
//============================ seg_driver ==
//==========================================
module seg_driver( input  logic                 clk, reset, strobe,
                   input  logic unsigned [15:0] num,
                   output logic unsigned [6:0]  LEDs, 
                   output logic          [2:0]  sel );

    logic unsigned [3:0] segs [3:0];
    logic [1:0] state, next_state;
    
    //== Digit Parsing ======================
    // Includes a check for numbers above
    // what can be displayed
    // Also incorporates a strobe 
    always_ff @(posedge clk, negedge reset) 
        if (~reset) segs <= '{default:'0};
        else 
            if (strobe)
                if (num > 9999) segs <= '{default:'{default:9}};
                else begin
                    segs[0] <=  num      % 10;
                    segs[1] <= (num/10)  % 10;
                    segs[2] <= (num/100) % 10;
                    segs[3] <=  num/1000;
                    end

    //== Seg Decoding =======================
    // Digit multiplexing is done by dereferencing
    // the segs array with the value of state.
    always_comb
	    case( segs[state] ) //GFE_DCBA
            0:        LEDs=7'b100_0000;
            1:        LEDs=7'b111_1001;
            2:        LEDs=7'b010_0100;
            3:        LEDs=7'b011_0000;
            4:        LEDs=7'b001_1001;
            5:        LEDs=7'b001_0010;
            6:        LEDs=7'b000_0010;
            7:        LEDs=7'b111_1000;
            8:        LEDs=7'b000_0000;
            9:        LEDs=7'b001_1000;
            default:  LEDs=7'b100_0000;
            endcase

    //== State ==============================
    // 4 states total - one for each digit
    always_ff @(posedge clk, negedge reset) 
        if (~reset) state <= 00;
        else        state <= next_state;

    always_comb
        case(state)
            0: next_state=2'b01;
            1: next_state=2'b10;
            2: next_state=2'b11;
            3: next_state=2'b00;
            default: next_state=00;
            endcase

    //== Digit Selects =======================
    always_comb
        case(state)
            0: sel=3'b000;
            1: sel=3'b001;
            2: sel=3'b011;
            3: sel=3'b100;
            default: sel=3'b000;
            endcase

    endmodule
