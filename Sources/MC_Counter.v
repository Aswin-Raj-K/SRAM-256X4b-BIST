`timescale 1ns / 1ps
`include "parameters.vh"

module MC_Counter
#(parameter PATTERN_WIDTH = $clog2(`MC_TEST_PATTERN_COUNT))(input clk, cen, rst,
output [`SRAM_ADDR_WIDTH + PATTERN_WIDTH : 0] counter_out,
output reg cout);

reg [`SRAM_ADDR_WIDTH + 2 :0]addr;
reg [PATTERN_WIDTH-1:0]decode;
wire [2:0]stage;
wire [`SRAM_ADDR_WIDTH-1:0]delay_wire;

reg we;
reg pass;
reg [`SRAM_ADDR_WIDTH-1:0]delay;
assign stage = addr[`SRAM_ADDR_WIDTH + 2 : `SRAM_ADDR_WIDTH];

always @(posedge clk) begin
    if (rst)
    begin
        we <= 1;
        addr <= 0;
        decode <= 0;
        pass <= 0;
	cout <= 0;
    end
    else if (cen)
    begin
        case(stage)
        //w0
        0:begin
            decode <= 0; 
            we <= 1;
            if(addr[`SRAM_ADDR_WIDTH-1:0] == 255)
                pass <= 0;
            addr <= addr + 1;
          end
         //ro w1
        1:begin
            we <= pass;
            decode <= pass;
            
            if(addr[`SRAM_ADDR_WIDTH-1:0] == 255 && pass == 1)
            begin
                pass <= 0;
                addr <= addr + 1;
            end
            
            else if(pass == 1)
            begin
                pass <= 0;
                addr <= addr + 1;
            end
            else begin
                pass <= pass + 1;
                addr <= addr;
            end
          end
          
          //r1 w0
         2:begin
            we <= pass;
            decode <= ~pass;
            if(addr[`SRAM_ADDR_WIDTH-1:0] == 255 && pass == 1)
            begin
                pass <= 0;
                addr <= addr + 1;
            end
            else if(pass == 1)
            begin
                pass <= 0;
                addr <= addr + 1;
            end
            else
            begin
                pass <= pass + 1;
                addr <= addr;
            end
          end
          //r0 w1
         3:begin
            we <= pass;
            decode <= pass;
            if(addr[`SRAM_ADDR_WIDTH-1:0] == 255 && pass == 1)
            begin
                pass <= 0;
                addr <= addr + 1;
            end
            else if(pass == 1)
            begin
                pass <= 0;
                addr <= addr + 1;
            end
            else
            begin
                pass <= pass + 1;
                addr <= addr;
            end
          end
          
         //r1 w0
         4:begin
            we <= pass;
            decode <= ~pass;
            if(addr[`SRAM_ADDR_WIDTH-1:0] == 255 && pass == 1)
            begin
                pass <= 0;
                addr <= addr + 1;
            end
            else if(pass == 1)
            begin
                pass <= 0;
                addr <= addr + 1;
            end
            else
            begin
                pass <= pass + 1;
                addr <= addr;
            end
          end
           //r0
         5:begin
            we <= pass;
            decode <= pass;
            if(addr[`SRAM_ADDR_WIDTH-1:0] == 255 && pass == 0)
            begin
                pass <= 0;
                addr <= addr + 1;
            end
            else if(pass == 0)
            begin
                pass <= 0;
                addr <= addr + 1;
            end
            else
            begin
                pass <= pass + 1;
                addr <= addr;
            end
          end
          default : begin
                        we <= 0;
                        addr <= addr;
                        decode <= 0;
                        cout <= 1;
                    end
          
        endcase
    end
    delay <= delay_wire;
end
assign delay_wire = (stage<3)?addr[`SRAM_ADDR_WIDTH-1:0]:`SRAM_DEPTH - 1 - addr[`SRAM_ADDR_WIDTH-1:0];
assign counter_out[`SRAM_ADDR_WIDTH-1:0] = delay;//[7:0]
assign counter_out[`SRAM_ADDR_WIDTH] = we;//[8]
assign counter_out[`SRAM_ADDR_WIDTH + PATTERN_WIDTH :`SRAM_ADDR_WIDTH+1] = decode;//[10:9]

endmodule