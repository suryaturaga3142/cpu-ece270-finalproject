`default_nettype none
`include "params.svh"
`include "sequencer.sv"
`include "line_mem.sv"
`include "alu.sv"
`include "instr_mem.sv"
`include "ram.sv"
`include "core.sv"
`ifndef cpu_guard
`define cpu_guard

/*
CPU module. Wrapper for the entire processor.
Code loaded into file line_mem.sv
User inputs trigger the synchronizer module.
*/

module cpu(
    input logic clk, 
    input logic start, 
    input logic rstn,
    output logic [DATA_WIDTH-1:0] ram0x00, ram0x01, ram0x02, ram0x03, ram0x04,
    output SequencerState q
);

// Synchronizer internal signals
//SequencerState q; 
logic err, finish;

// Line memory internal signals
logic line_mem_en;
logic [IP_WIDTH-1:0] ip; 
logic [LINE_WIDTH-1:0] output_line; 

// ALU internal signals
logic alu_en, ip_update_en; 
logic [DATA_WIDTH-1:0] val1, val2; 
logic [BUS_WIDTH-1:0] addr1, addr2; 
logic [OPCODE_WIDTH-1:0] opcode;
logic [DATA_WIDTH-1:0] result; 
logic calc_done, update_ip;

// Instruction internal memory signals
logic [BUS_WIDTH-1:0] addr_instr; 
logic instr_mem_en;

// RAM memory internal signals
logic [1:0] read_write_en;
logic [BUS_WIDTH-1:0] addr_rd;
logic [BUS_WIDTH-1:0] addr_wr;
logic [DATA_WIDTH-1:0] data_wr;
logic [DATA_WIDTH-1:0] data_rd;
logic busy; //Ignored by core due to synchronizer


sequencer synchronizer(
    .clk        (clk), 
    .rstn       (rstn), 
    .start      (start), 
    .nxt_line   (calc_done), 
    .err        (err), 
    .finish     (finish),
    .q          (q)
);

line_mem line_memory(
    .en    (line_mem_en), 
    .ip    (ip),
    .line  (output_line)
); 

alu cpu_alu(
    .clk          (clk), 
    .rstn         (rstn), 
    .en           (alu_en),
    .ip_update_en (ip_update_en),
    .q            (q),
    .value1       (val1), 
    .value2       (val2),
    .addr1        (addr1),
    .addr2        (addr2),
    .opcode       (opcode), 
    .result       (result),
    .update_ip    (update_ip),
    .calc_done    (calc_done), 
    .err          (err), 
    .finish       (finish)
);

instr_mem instruction_memory(
    .addr_instr (addr_instr),
    .en         (instr_mem_en), 
    .opcode     (opcode)
);

ram ram_memory(
    .clk         (clk),
    .addr_rd     (addr_rd),
    .addr_wr     (addr_wr),
    .rd_en       (read_write_en[0]),
    .wr_en       (read_write_en[1]),
    .data_wr     (data_wr),
    .data_rd     (data_rd),
    .ram0x00     (ram0x00),
    .ram0x01     (ram0x01),
    .ram0x02     (ram0x02),
    .ram0x03     (ram0x03),
    .ram0x04     (ram0x04)
);

core cpu_core(
    .clk            (clk), 
    .rstn           (rstn), 
    .q              (q),
    .line           (output_line), 
    .ip             (ip), 
    .line_mem_en    (line_mem_en),
    .opcode         (opcode),
    .instr_addr     (addr_instr), 
    .instr_mem_en   (instr_mem_en), 
    .ram_busy       (busy),
    .data_rd        (data_rd), 
    .data_wr        (data_wr), 
    .addr_rd        (addr_rd), 
    .addr_wr        (addr_wr),
    .ram_wr_en      (read_write_en[1]),
    .ram_rd_en      (read_write_en[0]),
    .value1         (val1),
    .value2         (val2),
    .addr1          (addr1), 
    .addr2          (addr2),
    .result         (result), 
    .update_ip      (update_ip),
    .alu_en         (alu_en),
    .ip_update_en   (ip_update_en)
); 

endmodule

`endif