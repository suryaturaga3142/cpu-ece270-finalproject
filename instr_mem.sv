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

logic [OPCODE_WIDTH-1:0] mem [(1<<BUS_WIDTH)-1:0];
assign opcode = addr_instr;


endmodule

`endif