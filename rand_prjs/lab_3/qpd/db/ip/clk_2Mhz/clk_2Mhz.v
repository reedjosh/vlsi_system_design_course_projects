// clk_2Mhz.v

// Generated using ACDS version 15.1 185

`timescale 1 ps / 1 ps
module clk_2Mhz (
		input  wire  inclk,  //  altclkctrl_input.inclk
		output wire  outclk  // altclkctrl_output.outclk
	);

	clk_2Mhz_altclkctrl_0 altclkctrl_0 (
		.inclk  (inclk),  //  altclkctrl_input.inclk
		.outclk (outclk)  // altclkctrl_output.outclk
	);

endmodule
