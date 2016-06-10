//altpll c0_high=30 c0_initial=1 c0_low=30 c0_mode="EVEN" c0_ph=0 CBX_DECLARE_ALL_CONNECTED_PORTS="OFF" charge_pump_current_bits=1 clk0_counter="C0" compensate_clock="CLK0" device_family="Cyclone IV E" inclk0_input_frequency=20000 intended_device_family="Cyclone IV E" loop_filter_c_bits=0 loop_filter_r_bits=27 lpm_hint="CBX_MODULE_PREFIX=pll_10_khz" m=12 m_initial=1 m_ph=0 n=1 operation_mode="normal" pll_type="AUTO" port_clk0="PORT_USED" port_clk1="PORT_UNUSED" port_clk2="PORT_UNUSED" port_clk3="PORT_UNUSED" port_clk4="PORT_UNUSED" port_clk5="PORT_UNUSED" port_extclk0="PORT_UNUSED" port_extclk1="PORT_UNUSED" port_extclk2="PORT_UNUSED" port_extclk3="PORT_UNUSED" port_inclk1="PORT_UNUSED" port_phasecounterselect="PORT_UNUSED" port_phasedone="PORT_UNUSED" port_scandata="PORT_UNUSED" port_scandataout="PORT_UNUSED" vco_post_scale=2 width_clock=5 clk inclk CARRY_CHAIN="MANUAL" CARRY_CHAIN_LENGTH=48
//VERSION_BEGIN 15.1 cbx_altclkbuf 2015:10:14:18:59:15:SJ cbx_altiobuf_bidir 2015:10:14:18:59:15:SJ cbx_altiobuf_in 2015:10:14:18:59:15:SJ cbx_altiobuf_out 2015:10:14:18:59:15:SJ cbx_altpll 2015:10:14:18:59:15:SJ cbx_cycloneii 2015:10:14:18:59:15:SJ cbx_lpm_add_sub 2015:10:14:18:59:15:SJ cbx_lpm_compare 2015:10:14:18:59:15:SJ cbx_lpm_counter 2015:10:14:18:59:15:SJ cbx_lpm_decode 2015:10:14:18:59:15:SJ cbx_lpm_mux 2015:10:14:18:59:15:SJ cbx_mgl 2015:10:21:19:02:34:SJ cbx_nadder 2015:10:14:18:59:15:SJ cbx_stratix 2015:10:14:18:59:15:SJ cbx_stratixii 2015:10:14:18:59:15:SJ cbx_stratixiii 2015:10:14:18:59:15:SJ cbx_stratixv 2015:10:14:18:59:15:SJ cbx_util_mgl 2015:10:14:18:59:15:SJ  VERSION_END
//CBXI_INSTANCE_NAME="sine_gen_pll_10_khz_pll_10_khz_inst_altpll_altpll_component"
// synthesis VERILOG_INPUT_VERSION VERILOG_2001
// altera message_off 10463



// Copyright (C) 1991-2015 Altera Corporation. All rights reserved.
//  Your use of Altera Corporation's design tools, logic functions 
//  and other software and tools, and its AMPP partner logic 
//  functions, and any output files from any of the foregoing 
//  (including device programming or simulation files), and any 
//  associated documentation or information are expressly subject 
//  to the terms and conditions of the Altera Program License 
//  Subscription Agreement, the Altera Quartus Prime License Agreement,
//  the Altera MegaCore Function License Agreement, or other 
//  applicable license agreement, including, without limitation, 
//  that your use is for the sole purpose of programming logic 
//  devices manufactured by Altera and sold by Altera or its 
//  authorized distributors.  Please refer to the applicable 
//  agreement for further details.



//synthesis_resources = cycloneive_pll 1 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  pll_10_khz_altpll
	( 
	clk,
	inclk) /* synthesis synthesis_clearbox=1 */;
	output   [4:0]  clk;
	input   [1:0]  inclk;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_off
`endif
	tri0   [1:0]  inclk;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_on
`endif

	wire  [4:0]   wire_pll1_clk;
	wire  wire_pll1_fbout;

	cycloneive_pll   pll1
	( 
	.activeclock(),
	.clk(wire_pll1_clk),
	.clkbad(),
	.fbin(wire_pll1_fbout),
	.fbout(wire_pll1_fbout),
	.inclk(inclk),
	.locked(),
	.phasedone(),
	.scandataout(),
	.scandone(),
	.vcooverrange(),
	.vcounderrange()
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.areset(1'b0),
	.clkswitch(1'b0),
	.configupdate(1'b0),
	.pfdena(1'b1),
	.phasecounterselect({3{1'b0}}),
	.phasestep(1'b0),
	.phaseupdown(1'b0),
	.scanclk(1'b0),
	.scanclkena(1'b1),
	.scandata(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	);
	defparam
		pll1.c0_high = 30,
		pll1.c0_initial = 1,
		pll1.c0_low = 30,
		pll1.c0_mode = "even",
		pll1.c0_ph = 0,
		pll1.charge_pump_current_bits = 1,
		pll1.clk0_counter = "c0",
		pll1.compensate_clock = "clk0",
		pll1.inclk0_input_frequency = 20000,
		pll1.loop_filter_c_bits = 0,
		pll1.loop_filter_r_bits = 27,
		pll1.m = 12,
		pll1.m_initial = 1,
		pll1.m_ph = 0,
		pll1.n = 1,
		pll1.operation_mode = "normal",
		pll1.pll_type = "auto",
		pll1.vco_post_scale = 2,
		pll1.lpm_type = "cycloneive_pll";
	assign
		clk = {wire_pll1_clk[4:0]};
endmodule //pll_10_khz_altpll
//VALID FILE
