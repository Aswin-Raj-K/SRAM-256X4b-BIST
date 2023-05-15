`timescale 1ns / 1ps
module Mux2_1 #(parameter DATA_WIDTH = 4)(output [DATA_WIDTH-1:0] out, input [DATA_WIDTH-1:0]data0, data1, 
input sel);

 assign out = sel ? data1 : data0;
 
endmodule
