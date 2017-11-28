////////////////////////////////////////////////////////////
// Bluetooth HC-05 Implementation
// By Joshua Reed
// Created Spring 2016
////////////////////////////////////////////////////////////
//
// DE0 Information
// 
// LEDS are active high.
//


////////////////////////////////////////////////////////////
// Functions, Tasks, and Types
////////////////////////////////////////////////////////////
// Char type.
typedef struct{
    logic [7:0] data;
    logic       val;
    } char;

// Char array.
typedef char char_arr [7:0];

// Insert an element at the right side of a register. 
task insert_right(inout char_arr arr, input logic [7:0] data, input logic val );
    arr[7:1] = arr[6:0];
    arr[0].data = data;
    arr[0].val = val;
    return;
    endtask
    
// Insert an element at the left side of a register. 
task insert_left(inout char_arr arr, input logic [7:0] data, input logic val );
    arr[6:0] =  arr[7:$right(arr)+1];
    arr[7].data = data;
    return;
    endtask

////////////////////////////////////////////////////////////
// TOP
////////////////////////////////////////////////////////////
module top(input  logic clk, reset, rx, increment,
           output logic unsigned [7:0] leds,
           output logic tx);

    logic rx_clk, baud_clk;
    logic tx_done, prev_tx_done;
    logic rx_drdy, prev_rx_drdy;
    logic send_next_byte;
    logic load_next_byte;
    logic send;
    const char init [7:0] = '{default:'{"Z", 0}, 2:'{"1", 1'b1}, 3:'{"2", 1'b1}, 4:'{"3", 1'b1} };

    assign leds = 200;
        
    char_arr receive_buffer;
    char_arr send_buffer;
    logic [7:0] received_byte;

    // sequential logic 
    always_ff@(posedge rx_clk, negedge reset) begin
        if (~reset) send_buffer = init;
        else if (receive_buffer[7].data == "R") begin
            send_buffer = init;
            insert_right(receive_buffer, 0, 1'b0);
            end
        else if (send_next_byte || send_buffer[7].val == 1'b0) insert_right(send_buffer, 0, 1'b0);
          
        if (~reset) receive_buffer = '{ default:'{" ", 1'b0} };
        else if (load_next_byte) insert_left(receive_buffer, received_byte, 1'b1);
       
        if(~reset) prev_tx_done <= 0;
        else prev_tx_done <= tx_done;

        if(~reset) prev_rx_drdy <= 0;
        else prev_rx_drdy <= rx_drdy;

        if(~reset) send <= 0;
        else if (send_buffer[6].val == 1) send <= 1;
        else if (tx_done == 0) send <= 0;

        end

    // combinational logic 
    always_comb begin
        if (tx_done == 1 && prev_tx_done == 0) send_next_byte <= 1;
        
else                                   send_next_byte <= 0;

        if (rx_drdy == 1 && prev_rx_drdy == 0) load_next_byte <= 1;
        else                                   load_next_byte <= 0;

        end
    

    // uart pll
    baud_gen pll(
	    .inclk0 ( clk      ),
	    .c0     ( baud_clk ), //   9600hz baud clk
	    .c1     ( rx_clk ) ); // 153600hz rx clock
	  
    // 9600 baud uart 
    uart uart_inst( 
        .baud_clk ( baud_clk ),
        .rx_clk   ( rx_clk   ),
        .reset    ( reset    ),
        .send     ( send     ), // set to 1 to send data
        .rx_drdy  ( rx_drdy  ),
        .rx       ( rx       ),
        .tx       ( tx       ),
        .to_send  ( send_buffer[7].data ),
        .tx_done  ( tx_done  ),
        .received ( received_byte ) );


    endmodule

    
////////////////////////////////////////////////////////////
// uart 
////////////////////////////////////////////////////////////
module uart( input  logic                baud_clk, rx_clk, reset, rx, send,
             input  logic unsigned [7:0] to_send,
             output logic                rx_drdy, tx, tx_done,
             output logic unsigned [7:0] received );

    // uart receiver 
    rx rx_1( 
        .clk            ( rx_clk ), // faster clock for data recovery
        .reset          ( reset        ),
        .rx             ( rx           ),
        .rx_drdy        ( rx_drdy      ),
        .received       ( received     ) );

    // uart transmitter
    tx tx_1( 
        .clk      ( baud_clk ), 
        .reset    ( reset    ),
        .send     ( send     ),
        .to_send  ( to_send  ),
        .tx       ( tx       ),
        .tx_done  ( tx_done  ) );

    endmodule

    //////////
    // instantiation template
    //////////
    // uart uart_inst( 
    //     .baud_clk(),
    //     .rx_clk(),
    //     .reset(),
    //     .rx(),
    //     .go(),
    //     .to_send()
    //     .tx(),
    //     .tx_done(),
    //     .received() );
    //


////////////////////////////////////////////////////////////
// tx module
////////////////////////////////////////////////////////////
module tx( input  logic          clk, reset, send, 
           input  unsigned [7:0] to_send, 
           output logic          tx, tx_done ); 
    
    logic unsigned [3:0] cnt;
    logic unsigned [7:0] send_reg;

    // data send_reg control
    always_ff@(posedge clk, negedge reset)
        if (~reset) send_reg <= 0;
        else if (cnt == 9) send_reg <= to_send; // load 
        else send_reg <= {send_reg[0], send_reg[7:1]};  // rotate

    // count down timer 
    always_ff@(posedge clk, negedge reset)
        if (~reset) cnt <= 0; // tx_done countdown timer
        else if (send && cnt == 0) cnt <= 9; // reload count down timer
        else if (cnt != 4'b0) cnt <= cnt - 4'b1; // count down

    // data out (tx) enabling
    always_comb  
        case(cnt) 
            0 : tx <= 1; // stop bit
            9 : tx <= 0; // start bit
            default : tx <= send_reg[0];
            endcase

    //always_comb  
    //    if (cnt != 0) sending <= 1;
    //    else          sending <= 0;

    always_comb 
        if (cnt == 0) tx_done <= 1;
        else          tx_done <= 0;

    endmodule

    //////////
    // instantiation template
    //////////
    // tx tx_1( 
    //     .clk      ( ), 
    //     .reset    ( ),
    //     .go       ( ),
    //     .to_send  ( ),
    //     .tx       ( ),
    //     .tx_done     ( ) );
    //
      

////////////////////////////////////////////////////////////
// rx module
////////////////////////////////////////////////////////////
module rx( input  logic                clk, reset, rx,
           output logic                rx_drdy,
           output logic unsigned [7:0] received );
    
    logic trg, msg_trg, start, stop;
    logic [175:0] sipo; // serial in par out
    logic unsigned [7:0] cnt, prev_cnt;
    logic [13:0] ones   = '{14{1'b1}};
    logic [13:0] zeroes = '{14{1'b0}};

    // shift in rx values
    always_ff@(posedge clk, negedge reset)
        if (~reset) sipo <= '{default:1'b0};
        else sipo <= {sipo[174:0], rx};

    // countdown timer to prevent re-triggering
    always_ff@(posedge clk, negedge reset)
        if (~reset) cnt <= 0;
        else if (trg) cnt <= 158; // hold off -- msg triggered
        else if (cnt != 0) cnt <= cnt - 8'b1;

    always_ff@(posedge clk, negedge reset)
        if (~reset) prev_cnt <= 0;
        else prev_cnt <= cnt; // track countdown reached

    // register data
    // TODO build in a voting system
    always_ff@(posedge clk, negedge reset) 
        if (~reset) received <= 0;
        else if (trg) 
            for(int i=0; i<8; i++) received[7-i] <= sipo[i*16+23]; // 23, 39, 55, etc...
                
    // 'hold off' trg enable
    always_comb
        if (cnt == 0) trg <= msg_trg; // allow message triggering
        else          trg <= 0; // 'hold off' message triggering

    // valid start bit 
    always_comb 
        if (sipo[174:161] == ones  &&  
            sipo[158:145] == zeroes)  start = 1;
        else                          start = 0; 

    // valid stop bit    
    always_comb
        if (sipo[14:1] == ones) stop <= 1;
        else                    stop <= 0;

    // trigger message
    always_comb
        if (start && stop) msg_trg <= 1;
        else               msg_trg <= 0;

    // trigger message
    always_comb
        if (cnt == 0 && prev_cnt == 1) rx_drdy <= 1;
        else                           rx_drdy <= 0;

    endmodule

    //////////
    // notes 
    //////////
    // each bit position is 14 bits
    // checked by computing ( start_idx - end_idx + 1) % 16 = 14
    // TODO write this cleaner
    // 

    //////////
    // instantiation template
    //////////
    // rx rx_1( 
    //     .clk      ( ), // faster clock for data recovery
    //     .reset    ( ),
    //     .rx       ( ),
    //     .received ( )  );
    //



////////////////////////////////////////////////////////////
// testbench
////////////////////////////////////////////////////////////
//module top_tb( ); // no signals -- tb
//
//    logic clk, reset, go;
//    logic loopback1;
//    logic loopback2;
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
//        #20ns reset = 1;
//        go = 0; 
//        #12ns go = 1;
//        end
//
//    always #10ns clk = ~clk; // 50 MHz
//
//    const char init1 [7:0] = '{ default:'{"Z", 0}, 0:'{"A", 1}, 1:'{"B",1}, 2:'{"C",1} };  
//    const char init2 [7:0] = '{ default:'{"", 0}, 0:'{"R", 1'b1} , 1:'{"B",1}, 2:'{"C",1}};
//
//    top uut1(
//        .clk     ( clk         ), 
//        .reset   ( reset       ), 
//        //.init    ( init1       ),
//        .tx      ( loopback1   ),
//        .rx      ( loopback2   ) );
//
//    top uut2(
//        .clk     ( clk         ), 
//        .reset   ( reset       ), 
//        //.init    ( init2       ), 
//        .tx      ( loopback2   ),
//        .rx      ( loopback1   ) );
//
//    endmodule
 
      
      
////////////////////////////////////////////////////////////
// clock counter
////////////////////////////////////////////////////////////
module clk_cntr( input  logic clk, reset,
                 input  int   cnt_to,
                 output logic clk_o );

    logic unsigned [20:0] cnt;

    always_ff @(posedge clk, negedge reset) 
        if (~reset) cnt <= 0; 
        else if (cnt == 0) cnt <= cnt_to-1; 
        else cnt <= cnt - 1;

    // alternate the clock
    always_ff @(posedge clk, negedge reset) 
        if (~reset) clk_o <= 0;
        else if (cnt == 0) clk_o <= ~clk_o;

    endmodule

    //////////
    // instantiation template
    //////////
    // clk_cntr cc(
    //     .clk      ( ), 
    //     .reset    ( ),
    //     .cnt_to   ( ),
    //     .clk_o    ( )  );
    //













