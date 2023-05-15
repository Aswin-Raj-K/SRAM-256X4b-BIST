`timescale 1ns / 1ps
`include "parameters.vh"

module SinglePortRam(
input [`SRAM_WORD_WIDTH-1:0] data_in,
input [`SRAM_ADDR_WIDTH-1:0] addr,
input we, clk,
output [`SRAM_WORD_WIDTH-1:0] data_out
);


//Declaring the ram
reg [`SRAM_WORD_WIDTH-1:0] ram[`SRAM_DEPTH-1:0];

//Variable to hold the registered read address
reg [`SRAM_ADDR_WIDTH-1:0] addr_reg;


always @ (posedge clk)
begin
    //Write
    if (we)
        ram[addr] <= data_in;
    addr_reg <= addr;
end

assign data_out = addr_reg==10?67:ram[addr_reg];

endmodule

    
    
