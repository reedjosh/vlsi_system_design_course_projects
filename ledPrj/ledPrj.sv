//==========================================
//=============================== top ======
//==========================================
module ledPrj(  input  logic [3:0] switches,
                output logic [7:0] leds     );
    
    assign leds[3:0] = switches;
    assign leds[7:4] = switches;

    endmodule


