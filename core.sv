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
    input SequencerState q,

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
    output logic [DATA_WIDTH-1:0] value1, value2,
    output logic [BUS_WIDTH-1:0] addr1, addr2,
    input logic [DATA_WIDTH-1:0] result,
    input logic update_ip,
    output logic alu_en, ip_update_en
);
// Hardwiring section. Ignoring ram_busy from RAM
assign instr_addr = line[31:24];
assign addr1      = line[15: 8];
assign addr2      = line[ 7: 0];
assign data_wr    = result;      //Hardcoding bc single cycle calculation

logic [DATA_WIDTH-1:0] nxt_value1, nxt_value2;
logic [BUS_WIDTH-1:0] nxt_addr_rd, nxt_addr_wr;
logic [IP_WIDTH-1:0] nxt_ip;
logic [4:0] enables, nxt_enables;
assign {line_mem_en, instr_mem_en, ram_rd_en, alu_en, ram_wr_en} = enables;
assign ip_update_en = (q === SWRITE);

always_ff @( posedge clk, negedge rstn ) begin : nextStateAssignment
    if (!rstn) begin
        enables <= 5'b00000;
        value1 <= 8'h00;
        value2 <= 8'h00;
        addr_rd <= 8'h00;
        ip <= 8'h00;
    end else begin
        enables <= nxt_enables;
        value1 <= nxt_value1;
        value2 <= nxt_value2;
        addr_rd <= nxt_addr_rd;
        addr_wr <= nxt_addr_wr;
        ip <= nxt_ip;
    end
end

assign nxt_value1 = (q == SR2) ? data_rd : value1;
assign nxt_value2 = (q == SR3) ? data_rd : value2;
assign nxt_addr_rd = (q == SRST || q == SNXT) ? addr1 : (q == SR1) ? addr2 : addr_rd;
assign nxt_addr_wr = (q == SCALC) ? line[23:16] : addr_wr;
assign nxt_ip = (q == SWRITE) ? (update_ip == 1'b1) ? addr_wr : ip + 1 : ip;

always_comb begin : nxtStateLogic
    case (q)
        SRST: nxt_enables = 5'b10100;
        SR1:  nxt_enables = 5'b01100;
        SR2:  nxt_enables = 5'b00100;
        SR3:  nxt_enables = 5'b00100;
        SR4:  nxt_enables = 5'b00010;
        SCALC:nxt_enables = { 4'b0001, ~opcode[6] };
        SWRITE: nxt_enables=5'b10010;
        SNXT :nxt_enables = 5'b10100;
        default: nxt_enables = 5'b00000;
    endcase
end

endmodule

`endif