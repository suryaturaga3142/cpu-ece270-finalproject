`default_nettype none

`include "params.svh"

`ifndef instr_mem_guard
`define instr_mem_guard

module instr_mem (
    input logic [BUS_WIDTH-1:0] addr_instr,
    input logic en,
    output logic [OPCODE_WIDTH-1:0] opcode
);

logic [OPCODE_WIDTH-1:0] mem [2**BUS_WIDTH-1:0];
//Define opcodes here

always_latch begin : assignOpcode
    if(en) begin
        opcode = mem[addr_instr];
    end
end

endmodule

`endif