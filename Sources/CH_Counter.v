`timescale 1ns / 1ps
`include "parameters.vh"

module CH_Counter
(input clk, cen, rst,
output [`CH_COUNTER_WIDTH - 1: 0] counter_out,
output cout);

reg [`CH_COUNTER_WIDTH - 1: 0] counter;

always @(posedge clk) begin
    if (rst)
        counter <= 0;
    else if (cen)
            counter <= counter + 1;
    else
        counter <= counter;
end

assign counter_out = {counter[`SRAM_ADDR_WIDTH+1]^counter[0], ~counter[`SRAM_ADDR_WIDTH], counter[`SRAM_ADDR_WIDTH-1:0]};

assign cout = counter[`CH_COUNTER_WIDTH-1];

endmodule