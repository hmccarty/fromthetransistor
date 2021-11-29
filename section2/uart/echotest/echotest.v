////////////////////////////////////////////////////////////////////////////////
//
// Filename: 	echotest.v
// {{{
// Project:	wbuart32, a full featured UART with simulator
//
// Purpose:	To test that the txuart and rxuart modules work properly, by
//		echoing the input directly to the output.
//
//	This module may be run as either a DUMBECHO, simply forwarding the input
//	wire to the output with a touch of clock in between, or it can run as
//	a smarter echo routine that decodes text before returning it.  The
//	difference depends upon whether or not OPT_DUMBECHO is defined, as 
//	discussed below.
//
//	With some modifications (discussed below), this RTL should be able to
//	run as a top-level testing file, requiring only the transmit and receive
//	UART pins and the clock to work.
//
//	DON'T FORGET TO TURN OFF HARDWARE FLOW CONTROL!  ... or this'll never
//	work.  If you want to run with hardware flow control on, add another
//	wire to this module in order to set o_cts to 1'b1.
//
//
// Creator:	Dan Gisselquist, Ph.D.
//		Gisselquist Technology, LLC
//
////////////////////////////////////////////////////////////////////////////////
// }}}
// Copyright (C) 2015-2021, Gisselquist Technology, LLC
// {{{
// This program is free software (firmware): you can redistribute it and/or
// modify it under the terms of  the GNU General Public License as published
// by the Free Software Foundation, either version 3 of the License, or (at
// your option) any later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTIBILITY or
// FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
// for more details.
//
// You should have received a copy of the GNU General Public License along
// with this program.  (It's in the $(ROOT)/doc directory, run make with no
// target there if the PDF file isn't present.)  If not, see
// <http://www.gnu.org/licenses/> for a copy.
//
// License:	GPL, v3, as defined and found on www.gnu.org,
//		http://www.gnu.org/licenses/gpl.html
//
//
////////////////////////////////////////////////////////////////////////////////

/* verilator lint_off MULTITOP */

`include "../txuart.v"
`include "../rxuart.v"

`define	OPT_DUMBECHO

module	echotest(
		input		i_clk,
		input		i_uart_rx,
		output	wire	o_uart_tx
	);

`ifdef	OPT_DUMBECHO
	reg	r_uart_tx;

	initial	r_uart_tx = 1'b1;
	always @(posedge i_clk)
		r_uart_tx <= i_uart_rx;
	assign	o_uart_tx = r_uart_tx;
`else
	wire rx_stb;
	wire [7:0] rx_data;
	rxuart receiver(i_clk, i_uart_rx, rx_stb, rx_data);

	wire tx_busy;
	txuart transmitter(i_clk, rx_stb, rx_data, o_uart_tx, tx_busy);
`endif
endmodule

