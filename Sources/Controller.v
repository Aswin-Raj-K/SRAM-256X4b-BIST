`timescale 1ns / 1ps
`include "parameters.vh"

module Controller(input start, rst, clk, cout, output muxSel, cen);
 
reg [$clog2(`NO_OF_STATES)-1:0]current;
always @ (posedge clk) begin
    if (rst)
        current <= `RESET;
    else
        case(current)
            `RESET: if (start)
                        current <= `TEST;
                    else
                        current <= `RESET;
                        
            `TEST: if (cout)
                        current <= `DONE;
                   else
                        current <= `TEST;
                        
            `DONE: current <= `DONE;
            
            default:
                    current <= `RESET;
        endcase
end

assign muxSel = (current == `TEST) ? 1'b1 : 1'b0;
assign cen = (current == `TEST) ? 1'b1 : 1'b0;


endmodule
