`timescale 1ns / 1ps
`include "parameters.vh"

module Comparator
(input[`SRAM_WORD_WIDTH-1:0] data1, data2,
output out);
    
    
    assign out = data1 == data2;
    
endmodule



