`timescale 1ns / 1ps

module Mux4_1 #(parameter DATA_WIDTH = 8)
  (input [DATA_WIDTH-1:0] data0,
   input [DATA_WIDTH-1:0] data1,
   input [DATA_WIDTH-1:0] data2,
   input [DATA_WIDTH-1:0] data3,
   input [1:0] sel,
   output [DATA_WIDTH-1:0] out);
    
    
   assign out = (sel == 2'b00) ? data0 :
             (sel == 2'b01) ? data1 :
             (sel == 2'b10) ? data2 :
                              data3;


endmodule