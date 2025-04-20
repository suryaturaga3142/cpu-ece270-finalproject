`default_nettype none
`include "params.svh"
`ifndef alu_guard
`define alu_guard

/*
ALU module to handle all calculations. Registers and flags are loaded in SREAD state.
All calcs done in SCALC state, outputs result when ready w/ multicycle operations.
*/

module alu (
    input logic clk, rstn, en,
    input logic [DATA_WIDTH-1:0] value1, value2,
    input logic [BUS_WIDTH-1:0] addr1, addr2,
    input logic [OPCODE_WIDTH-1:0] opcode,
    output logic [DATA_WIDTH-1:0] result,
    output logic calc_done, err
);

// Code ALU here

endmodule

`endif 