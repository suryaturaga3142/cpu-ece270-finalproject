`default_nettype none
`include "params.svh"
`ifndef archive_ram_guard
`define archive_ram_guard

/*
Uses FPGA BRAM. Reads and writes to data 8 bits wide with bus width 8 bits.
Prefers read enable over write to prevent conflict.
*/

module ram (
    input logic clk,
    input logic [BUS_WIDTH-1:0] addr_rd, addr_wr, 
    input logic [DATA_WIDTH-1:0] data_wr,
    input logic rd_en, wr_en,
    output logic [DATA_WIDTH-1:0] data_rd,
    output logic [DATA_WIDTH-1:0] ram0x00, ram0x01, ram0x02, ram0x03, ram0x04
);

logic [DATA_WIDTH-1:0] memory [(1<<BUS_WIDTH)-1:0];
logic [DATA_WIDTH-1:0] nxt_data_rd, nxt_data_wr;
assign ram0x00 = memory[0];
assign ram0x01 = memory[1];
assign ram0x02 = memory[2];
assign ram0x03 = memory[3];
assign ram0x04 = memory[4];

always_ff @( posedge clk ) begin : resetAndRead
    data_rd <= nxt_data_rd;
    memory[addr_wr] <= nxt_data_wr;
end

assign nxt_data_rd = (rd_en === 1'b1) ? memory[addr_rd] : data_rd;
assign nxt_data_wr = (wr_en && !rd_en) ? data_wr : memory[addr_wr];

endmodule

`endif