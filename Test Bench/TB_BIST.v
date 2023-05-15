`timescale 1ns / 1ps
`include "parameters.vh"

module TB_BIST#(parameter HALF_CLK_PERIOD = `CLK_PERIOD/2, BIST_ALGO = 0)();

reg [`SRAM_WORD_WIDTH-1:0] data_in;
reg [`SRAM_ADDR_WIDTH-1:0] data_addr;

reg we, start;
reg rst, clk;
wire [`SRAM_WORD_WIDTH-1:0] data_out;
wire fail;
wire [`SRAM_ADDR_WIDTH-1:0] fail_addr;

initial begin
    clk = 1;
end

   BIST UUT (.clk(clk), .start(start), .rst(rst), .we(we), .data_in(data_in), .data_addr(data_addr),.test_sel(BIST_ALGO),.fail(fail),.fail_addr(fail_addr),.data_out(data_out));

always #HALF_CLK_PERIOD clk = ~clk;

initial begin
    we = 0;
    start = 0;
    data_addr = 0;
    data_in = 0;
    rst = 1;

    repeat(2)#`CLK_PERIOD;

    rst = 0;
    start = 1;
    
    #`CLK_PERIOD;
    while(UUT.CNTRL.current!=`DONE)//waiting for the testing to finish
        #`CLK_PERIOD;
    
    $finish;
    
end

endmodule
