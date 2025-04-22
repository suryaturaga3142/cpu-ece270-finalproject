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
    output logic [DATA_WIDTH-1:0] output_data0x00, output_data0x01
);

logic [DATA_WIDTH-1:0] memory [(1<<BUS_WIDTH) - 1:0];
logic [DATA_WIDTH-1:0] nxt_data_rd;
assign output_data0x00 = memory[0];
assign output_data0x01 = memory[1];

always_ff @( posedge clk ) begin : resetAndRead
    data_rd <= nxt_data_rd;
end

assign nxt_data_rd = (rd_en === 1'b1) ? memory[(1<<addr_rd)-1] : data_rd;

///*
//For Synthesis
always @* begin
    if (wr_en && !rd_en) memory[(1<<addr_wr)-1] = data_wr;
end
//*/

//For simulation
/*
always_latch begin : writing
    if (wr_en && !rd_en) begin
        memory[(1<<addr_wr)-1] = data_wr;
    end
end
*/

endmodule

`endif