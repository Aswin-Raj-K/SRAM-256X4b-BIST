`timescale 1ns / 1ps
`include "parameters.vh"
`include "Controller.v"
`include "Decoder.v"
`include "MA_Counter.v"
`include "Register.v"
`include "Mux2_1.v"
`include "SinglePortRam.v"
`include "Comparator.v"

module MA_BIST(
input clk, start, rst, we,
input [`SRAM_WORD_WIDTH-1:0]data_in,
input [`SRAM_ADDR_WIDTH-1:0]data_addr,
output fail,
output [`SRAM_ADDR_WIDTH-1:0]fail_addr,
output [`SRAM_WORD_WIDTH-1:0]data_out);


wire [`SRAM_ADDR_WIDTH-1:0]sram_addr, addr;
wire [`SRAM_WORD_WIDTH-1:0]sram_data_out, sram_data_in,decoder_out,decoder_delayed_out;
wire [`MA_COUNTER_WIDTH-1:0] counter_out;
wire counter_cout, controller_muxSel, decoder_in, counter_rwbar;
wire comp_out, count_enable;

assign addr = counter_out[`SRAM_ADDR_WIDTH-1:0];
assign decoder_in = counter_out[`MA_COUNTER_WIDTH-1 :`SRAM_ADDR_WIDTH+1];
assign counter_rwbar = counter_out[`SRAM_ADDR_WIDTH];
assign data_out = sram_data_out;

Controller CNTRL (.start(start), .rst(rst), .clk(clk), .cout(counter_cout), .muxSel(muxSel), .cen(count_enable));
Decoder DEC (.data_in(decoder_in),.data_out(decoder_out));
MA_Counter COUNTER (.clk(clk), .cen(count_enable), .rst(rst), .counter_out(counter_out),.cout(counter_cout));


Register #(`SRAM_WORD_WIDTH) REGA(.clk(clk), .data_in(decoder_out), .data_out(decoder_delayed_out));
Register #(`SRAM_ADDR_WIDTH) REGB(.clk(clk), .data_in(sram_addr), .data_out(fail_addr));
Mux2_1 #(`SRAM_WORD_WIDTH) MUX_DATA (.data0(data_in),.data1(decoder_out),.sel(muxSel),.out(sram_data_in));
Mux2_1 #(`SRAM_ADDR_WIDTH) MUX_ADDR (.data0(data_addr),.data1(addr),.sel(muxSel),.out(sram_addr));
Mux2_1 #(1) MUX_WE (.data0(we),.data1(counter_rwbar),.sel(muxSel),.out(sram_we));

SinglePortRam RAM (.data_in(sram_data_in),.addr(sram_addr),.we(sram_we), .clk(clk),.data_out(sram_data_out));
Comparator COMP (.data1(sram_data_out), .data2(decoder_delayed_out),.out(comp_out));

assign fail = (muxSel && sram_we && comp_out !== 1'bx)?(comp_out?0:1):0;


endmodule
