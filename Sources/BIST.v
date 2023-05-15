`timescale 1ns / 1ps
`include "parameters.vh"
`include "Controller.v"
`include "Decoder.v"
`include "BL_Counter.v"
`include "CH_Counter.v"
`include "MA_Counter.v"
`include "MC_Counter.v"
`include "Register.v"
`include "Mux2_1.v"
`include "Mux4_1.v"
`include "SinglePortRam.v"
`include "Comparator.v"
module BIST(
input clk, start, rst, we,
input [`SRAM_WORD_WIDTH-1:0]data_in,
input [`SRAM_ADDR_WIDTH-1:0]data_addr,
input [1:0]test_sel,
output fail,test_done,
output [`SRAM_ADDR_WIDTH-1:0]fail_addr,
output [`SRAM_WORD_WIDTH-1:0]data_out);


wire [`SRAM_ADDR_WIDTH-1:0]sram_addr, addr;
wire [`SRAM_WORD_WIDTH-1:0]sram_data_out, sram_data_in,decoder_out,decoder_delayed_out;
wire [`COUNTER_WIDTH-1:0] counter_out, bl_counter_out,ch_counter_out,mc_counter_out,ma_counter_out;
wire counter_cout,bl_counter_cout, ch_counter_cout,mc_counter_cout,ma_counter_cout, controller_muxSel, decoder_in, counter_rwbar;
wire comp_out, count_enable;
wire [3:0] mux41_cen,mux41_rst;

assign test_done = counter_cout;

assign addr = counter_out[`SRAM_ADDR_WIDTH-1:0];
assign decoder_in = counter_out[`BL_COUNTER_WIDTH-1 :`SRAM_ADDR_WIDTH+1];
assign counter_rwbar = counter_out[`SRAM_ADDR_WIDTH];
assign data_out = sram_data_out;

Controller CNTRL (.start(start), .rst(rst), .clk(clk), .cout(counter_cout), .muxSel(muxSel), .cen(count_enable));
BIST_Decoder DEC(.sel(test_sel), .data_in(decoder_in),.data_out(decoder_out));
Mux4_1 #(4)MUX41_CEN(.data0(4'b0001),.data1(4'b0010),.data2(4'b0100),.data3(4'b1000),.sel(test_sel),.out(mux41_cen));
Mux4_1 #(4)MUX41_RST(.data0(4'b1110),.data1(4'b1101),.data2(4'b1011),.data3(4'b0111),.sel(test_sel),.out(mux41_rst));

Mux4_1 #(`COUNTER_WIDTH)MUX41_COUNTER(.data0(bl_counter_out),.data1(ch_counter_out),.data2(mc_counter_out),.data3(ma_counter_out),.sel(test_sel),.out(counter_out));
Mux4_1 #(4)MUX41_COUT(.data0(bl_counter_cout),.data1(ch_counter_cout),.data2(mc_counter_cout),.data3(ma_counter_cout),.sel(test_sel),.out(counter_cout));

BL_Counter BL_COUNTER (.clk(clk), .cen(mux41_cen[0] & count_enable), .rst(mux41_rst[0] | rst), .counter_out(bl_counter_out),.cout(bl_counter_cout));
CH_Counter CH_COUNTER (.clk(clk), .cen(mux41_cen[1] & count_enable), .rst(mux41_rst[1] | rst), .counter_out(ch_counter_out),.cout(ch_counter_cout));
MC_Counter MC_COUNTER (.clk(clk), .cen(mux41_cen[2] & count_enable), .rst(mux41_rst[2] | rst), .counter_out(mc_counter_out),.cout(mc_counter_cout));
MA_Counter MA_COUNTER (.clk(clk), .cen(mux41_cen[3] & count_enable), .rst(mux41_rst[3] | rst), .counter_out(ma_counter_out),.cout(ma_counter_cout));

Register #(`SRAM_WORD_WIDTH) REGA(.clk(clk), .data_in(decoder_out), .data_out(decoder_delayed_out));
Register #(`SRAM_ADDR_WIDTH) REGB(.clk(clk), .data_in(sram_addr), .data_out(fail_addr));

Mux2_1 #(`SRAM_WORD_WIDTH) MUX21_DATA (.data0(data_in),.data1(decoder_out),.sel(muxSel),.out(sram_data_in));
Mux2_1 #(`SRAM_ADDR_WIDTH) MUX21_ADDR (.data0(data_addr),.data1(addr),.sel(muxSel),.out(sram_addr));
Mux2_1 #(1) MUX21_WE (.data0(we),.data1(counter_rwbar),.sel(muxSel),.out(sram_we));

SinglePortRam RAM (.data_in(sram_data_in),.addr(sram_addr),.we(sram_we), .clk(clk),.data_out(sram_data_out));
Comparator COMP (.data1(sram_data_out), .data2(decoder_delayed_out),.out(comp_out));

assign fail = (muxSel && sram_we && comp_out !== 1'bx)?(comp_out?0:1):0;


endmodule
