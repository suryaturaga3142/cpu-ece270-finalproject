`include "cpu.sv"

module cpu_top (
    input logic HWCLK,
    input logic [1:0] PB,
    output logic [7:0] RIGHT, LEFT, SS7, SS6, SS5, SS4, SS3, SS2, SS1, SS0
);

cpu dut (
    .clk(HWCLK),
    .rstn(~PB[1]),
    .start(PB[0]),
    .ram0x00(RIGHT[7:0]),
    .ram0x01(LEFT[7:0])
    //BCD conv to 2 SS digits in hex per ram var
);

endmodule