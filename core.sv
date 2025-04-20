`default_nettype none
`include "params.svh"
`ifndef core_guard
`define core_guard

/*
Core module to interact with all parts of CPU. Uses sequencer to control ALU.
Reads lines and reads / writes to registers for execution control.
*/

module core (
    input logic clk, rst, 

    /* Sequencer IO */
    input SequencerState q, output logic err,

    /* Instr Mem IO */
    input logic [OPCODE_WIDTH-1:0] opcode,
    output logic [BUS_WIDTH-1:0] instr_addr,
    output logic instr_mem_en,

    /* Data Mem IO */
    input logic [DATA_WIDTH-1:0] data_rd,
    output logic [DATA_WIDTH-1:0] data_wr,
    output logic [BUS_WIDTH-1:0] addr_rd, addr_wr,
    output logic ram_en,

    /* ALU IO */
    output logic [OPCODE_WIDTH-1:0] opcode_alu,
    output logic [DATA_WIDTH-1:0] value1, value2,
    output logic [BUS_WIDTH-1:0] addr1, addr2,
    input logic [DATA_WIDTH-1:0] result,
    output logic alu_en
);
// Enable signals and registers for ip, ra, etc here. Eventually stack interaction too.
    
endmodule

`endif