`include "params.svh"

module RAM_wrapper(
    input logic [1:0] en, 
    input logic clk, 
    input logic rstn,
    input logic [BUS_WIDTH-1:0] addr_rd,
    input logic [BUS_WIDTH-1:0] addr_w, 
    input logic [BUS_WIDTH-1:0] dread, 
    input logic [BUS_WIDTH-1:0] dwrite,
 
    output logic [BUS_WIDTH-1:0] dout, 
    output logic busy
);


logic [BUS_WIDTH-1:0] addr;
logic [BUS_WIDTH-1:0] write_data;
logic [BUS_WIDTH-1:0] read_data;
logic [BUS_WIDTH-1:0] ram_dout;
logic [BUS_WIDTH-1:0] waddr, raddr, din;
logic  write_en;


assign addr = (en[1] && !en[0]) ? addr_w : addr_rd;
assign write_data = dwrite;
assign dout = read_data;
 

memory_controller memory_fsm(
    .clk        (clk),
    .rstn       (rstn),
    .write_read (en),
    .addr       (addr),
    .write_data (write_data),
    .ram_dout   (ram_dout),

    .waddr      (waddr),
    .raddr      (raddr),
    .din        (din),
    .read_data  (read_data),
    .write_en   (write_en),
    .busy       (busy)
);

ram bram(
    .din        (din),
    .write_en   (write_en),
    .waddr      (waddr),
    .wclk       (clk),
    .raddr      (raddr),
    .rclk       (clk),
    .dout       (ram_dout)
);



endmodule