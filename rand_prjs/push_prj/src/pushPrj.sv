//==========================================
//=============================== top ======
//==========================================
module pushPrj( input  logic [7:0]          buttons,
                input  logic                switch,
                output logic unsigned [7:0] leds     );
    
    
    always_comb
        if (switch) begin
            leds [7:4] <= 0;
            casez (~buttons)
                8'b1??????? : leds[3:0] <= 8;
                8'b?1?????? : leds[3:0] <= 7;
                8'b??1????? : leds[3:0] <= 6;
                8'b???1???? : leds[3:0] <= 5;
                8'b????1??? : leds[3:0] <= 4;
                8'b?????1?? : leds[3:0] <= 3;
                8'b??????1? : leds[3:0] <= 2;
                8'b???????1 : leds[3:0] <= 1;
                default     : leds[3:0] <= 0;
                endcase
            end
        else begin
            leds [3:0] <= 0;
            if      (~buttons[7]) leds[7:4] <= 8;
            else if (~buttons[6]) leds[7:4] <= 7;
            else if (~buttons[5]) leds[7:4] <= 6;
            else if (~buttons[4]) leds[7:4] <= 5;
            else if (~buttons[3]) leds[7:4] <= 4;
            else if (~buttons[2]) leds[7:4] <= 3;
            else if (~buttons[1]) leds[7:4] <= 2;
            else if (~buttons[0]) leds[7:4] <= 1;
            else                  leds[7:4] <= 0;
            end

    
    endmodule

