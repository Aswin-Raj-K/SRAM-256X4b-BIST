`timescale 1ns / 1ps
`include "parameters.vh"

module Decoder #(parameter [7:0]PATTERN=8'b000001111)
(input data_in, output [`SRAM_WORD_WIDTH-1:0] data_out);
    
    reg [`SRAM_WORD_WIDTH-1:0] pattern [`MC_TEST_PATTERN_COUNT-1:0];
   
    assign data_out = data_in?PATTERN[7:4]:PATTERN[3:0];
endmodule



