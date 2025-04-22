`default_nettype none
`include "params.svh"
`ifndef line_mem_guard
`define line_mem_guard

/*
Memory file to hold all lines of code to execute by CPU.
Instruction pointer points to line of code.
*/

module line_mem (
    input logic en,
    input logic [IP_WIDTH-1:0] ip,
    output logic [LINE_WIDTH-1:0] line
);

logic [LINE_WIDTH-1:0] code [(1<<BUS_WIDTH)-1:0];
assign code[0] = 32'h03002336;
assign code[1] = 32'h02000011;
assign code[2] = 32'hf0000000;
assign code[3] = 32'h00000000;

assign code[NUM_LINES] = 32'hffffffff;

always_latch begin : lineAssignment
    if(en) begin
        line = code[ip];
    end
end

endmodule

`endif