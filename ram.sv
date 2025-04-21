`default_nettype none
`include "params.svh"
`ifndef ram_guard
`define ram_guard

module ram (
    input logic wclk, rclk, write_en,
    input logic [DATA_WIDTH-1:0] din,
    input logic [BUS_WIDTH-1:0] waddr, raddr,
    output logic [DATA_WIDTH-1:0] dout
);//256x8
 logic [DATA_WIDTH-1:0] mem [(1<<BUS_WIDTH)-1:0];

 always @(posedge wclk) // Write memory.
 begin
    if (write_en)
        mem[waddr] <= din; // Using write address bus.
    end
    always @(posedge rclk) // Read memory.
    begin
        dout <= mem[raddr]; // Using read address bus.
 end
 
endmodule

`endif