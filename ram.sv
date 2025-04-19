`default_nettype none

`include "params.svh"

`ifndef ram_guard
`define ram_guard

/*
Uses FPGA BRAM. Reads and writes to data 8 bits wide with bus width 8 bits.
Prefers read enable over write to prevent conflict.
*/

module ram (
    input logic clk, rstn,
    input logic [BUS_WIDTH-1:0] addr_rd, addr_wr, 
    input logic [DATA_WIDTH-1:0] data_wr,
    input logic rd_en, wr_en,
    output logic [DATA_WIDTH-1:0] data_rd
);
logic [DATA_WIDTH-1:0] memory [2**BUS_WIDTH - 1:0];
logic [DATA_WIDTH-1:0] nxt_data_rd;

always_ff @( posedge clk, negedge rstn ) begin : resetAndRead
    if (!rstn) begin
        for (int i = 0; i <= 2**BUS_WIDTH - 1; i = i + 1) begin
            memory[i] = 0;
        end
    end else begin
        data_rd <= nxt_data_rd;
    end
end

assign nxt_data_rd = (rd_en) ? memory[2**addr_rd-1] : (wr_en) ? data_rd : 0;
always_latch begin : writing
    if (wr_en && !rd_en) begin
        memory[2**addr_wr-1] = data_wr;
    end
end

endmodule

`endif