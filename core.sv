`default_nettype none
`include "params.svh"
`ifndef core_guard
`define core_guard

/*
Core module to interact with all parts of CPU. Uses sequencer to control ALU.
Reads lines and reads / writes to registers for execution control.
*/

module core (
    input logic clk, rstn, 

    /* Sequencer IO */
    input SequencerState q, output logic err,

    /* Line Memory IO */
    input logic [LINE_WIDTH-1:0] line,
    output logic [IP_WIDTH-1:0] ip,
    output logic line_mem_en,

    /* Instr Mem IO */
    input logic [OPCODE_WIDTH-1:0] opcode,
    output logic [BUS_WIDTH-1:0] instr_addr,
    output logic instr_mem_en,

    /* RAM IO */
    input logic ram_busy,
    input logic [DATA_WIDTH-1:0] data_rd,
    output logic [DATA_WIDTH-1:0] data_wr,
    output logic [BUS_WIDTH-1:0] addr_rd, addr_wr,
    output logic ram_wr_en, ram_rd_en,

    /* ALU IO */
    output logic [OPCODE_WIDTH-1:0] opcode_alu,
    output logic [DATA_WIDTH-1:0] value1, value2,
    output logic [BUS_WIDTH-1:0] addr1, addr2,
    input logic [DATA_WIDTH-1:0] result,
    output logic alu_en
);
// Hardwiring section. Ignoring ram_busy from RAM
assign err = 1'b0;
assign instr_addr = line[31:24];
assign addr_wr    = line[23:16]; //Hardcoding bc single cycle calculation
assign addr1      = line[15: 8];
assign addr2      = line[ 7: 0];
assign data_wr    = result;      //Hardcoding bc single cycle calculation
assign opcode     = opcode_alu;

logic [DATA_WIDTH-1:0] nxt_value1, nxt_value2;
logic [BUS_WIDTH-1:0] nxt_addr_rd;
logic [IP_WIDTH-1:0] nxt_ip;
logic enables [4:0], nxt_enables;
assign enables = {line_mem_en, instr_mem_en, ram_rd_en, ram_wr_en, alu_en};

always_ff @( posedge clk, negedge rstn ) begin : enableAssignment
    if (!rstn) begin
        enables <= 5'b00000;
        value1 <= DATA_WIDTH'h00;
        value2 <= DATA_WIDTH'h00;
        addr_rd <= BUS_WIDTH'h00;
        ip <= IP_WIDTH'h00;
    end else begin
        enables <= nxt_enables;
        value1 <= nxt_value1;
        value2 <= nxt_value2;
        addr_rd <= nxt_addr_rd;
        ip <= nxt_ip;
    end
end

always_comb begin : enableControl
    case (q)
        SRST  : nxt_enables = 5'b10000; //line_mem
        SREAD : nxt_enables = 5'b01100; //instr_mem, ram_rd
        SLOAD1: nxt_enables = 5'b00100; //ram_rd
        SLOAD2: nxt_enables = 5'b00100; //ram_rd (optional)
        SCALC : nxt_enables = 5'b00001; //alu
        SWRITE: nxt_enables = 5'b10010; //line_mem, ram_wr
        default:nxt_enables = 5'b00000; //off
    endcase
end

assign nxt_value1 = (q == SLOAD1) ? data_rd : value1;
assign nxt_value2 = (q == SLOAD2 | SCALC) ? data_rd : value2;
assign nxt_addr_rd = (q == SREAD) ? addr1 : (q == SLOAD1) ? addr2 : addr_rd;
assign nxt_ip = (q == SCALC) ? ip + 1 : ip;

endmodule

`endif