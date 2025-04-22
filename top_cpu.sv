`include "cpu.sv"

module top_cpu (
    input logic CLK,
    input logic SW1, SW2
);
cpu dut(
    .clk(CLK),
    .rstn(SW1), .start(SW2)
);


endmodule