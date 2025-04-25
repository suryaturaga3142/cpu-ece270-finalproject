`default_nettype none
`include "cpu.sv"

module cpu_top (
    // IO Ports
    input logic hz100, reset, 
    input logic [20:0] pb,
    output logic [7:0] left, right,
        ss7, ss6, ss5, ss4, ss3, ss2, ss1, ss0,
    output logic red, green, blue,

    // UART Ports
    output logic [7:0] txdata,
    input logic [7:0] rxdata,
    output logic txclk, rxclk, 
    input logic txready, rxready
);

cpu dut (
    .clk(hz100), .rstn(~pb[1]), .start(pb[0]),
    .ram0x00(right[7:0]),
    .ram0x01(left[7:0])
    //Hex to BCD converters for rest.
);


endmodule