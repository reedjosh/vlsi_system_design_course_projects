//==========================================
//=============================== top ======
//==========================================
module ledPrj( input        clk, reset,
               input  [7:0] buttons,
               output [7:0] leds);
    
    logic clk0;
    logic clk1;
    logic clk2;
    logic clk3;
    logic clk4;
    logic clk5;

    logic unsigned [3:0] temp0;
    logic unsigned [3:0] temp1;
    logic unsigned [3:0] temp2;
    logic unsigned [3:0] temp3;
    logic unsigned [3:0] temp4;
    logic unsigned [3:0] temp5;

    pll_leds pll_leds_inst ( .inclk0 ( clk  ),
        	                 .c0     ( clk0 ),
        	                 .c1     ( clk1 ),
        	                 .c2     ( clk2 ) );

    // one hot rotate left on clk0 
    always_ff @(posedge clk0, negedge reset)
        if (~reset) temp0 <= 1;
        else temp0 <= {temp0[2:0], temp0[3]};

    // one hot rotate left on clk1 
    always_ff @(posedge clk1, negedge reset)
        if (~reset) temp1 <= 1;
        else temp1 <= {temp1[2:0], temp1[3]};
    
    // one hot rotate left on clk2
    always_ff @(posedge clk2, negedge reset)
        if (~reset) temp2 <= 1;
        else temp2 <= {temp2[2:0], temp2[3]};

    // one hot rotate left on clk3
    always_ff @(posedge clk3, negedge reset)
        if (~reset) temp3 <= 1;
        else temp3 <= {temp3[2:0], temp3[3]};

    // one hot rotate left on clk4
    always_ff @(posedge clk4, negedge reset)
        if (~reset) temp4 <= 1;
        else temp4 <= {temp4[2:0], temp4[3]};

    // one hot rotate left on clk5
    always_ff @(posedge clk5, negedge reset)
        if (~reset) temp5 <= 1;
        else temp5 <= {temp5[2:0], temp5[3]};

    // priority encoder
    always_comb    
        casez (~buttons)
            8'b??1????? : leds[3:0] <= 0;
            8'b???1???? : leds[3:0] <= temp5;
            8'b????1??? : leds[3:0] <= temp4;
            8'b?????1?? : leds[3:0] <= temp3;
            8'b??????1? : leds[3:0] <= temp2;
            8'b???????1 : leds[3:0] <= temp1;
            default     : leds[3:0] <= temp0;
            endcase

    // clock counter divides clk2 by 10
    clk_cntr cc1 ( 
       .reset    ( reset   ),
       .cnt_to   ( 5       ), 
       .clk      ( clk2    ),
       .clk_o    ( clk3    ) );

    // clock counter divides clk3 by 10
    clk_cntr cc2 ( 
       .reset    ( reset   ),
       .cnt_to   ( 5       ), 
       .clk      ( clk3    ),
       .clk_o    ( clk4    ) );

    // clock counter divides clk4 by 10
    clk_cntr cc3 ( 
       .reset    ( reset   ),
       .cnt_to   ( 5       ), 
       .clk      ( clk4    ),
       .clk_o    ( clk5    ) );

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
