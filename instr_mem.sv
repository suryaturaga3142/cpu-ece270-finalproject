`default_nettype none
`include "params.svh"
`ifndef instr_mem_guard
`define instr_mem_guard

/*
Instruction memory to store all opcodes. Send in address and get opcode.
*/

module instr_mem (
    input logic [BUS_WIDTH-1:0] addr_instr,
    input logic en,
    output logic [OPCODE_WIDTH-1:0] opcode
);

logic [OPCODE_WIDTH-1:0] mem [2**BUS_WIDTH-1:0];
//Define opcodes here
assign mem[0] = 8'h00;
assign mem[1] = 8'h00;
assign mem[2] = 8'h00;

always_latch begin : assignOpcode
    if(en) begin
        opcode = addr_instr; //mem[addr_instr];
    end
end

endmodule

`endif