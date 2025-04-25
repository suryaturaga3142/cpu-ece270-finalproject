`default_nettype none
`include "cpu.sv"
`include "hex_ss.sv"

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
logic [7:0] ram0x00, ram0x01, ram0x02, ram0x03, ram0x04;
SequencerState q;

cpu dut (
    .clk(hz100), .rstn(~pb[1]), .start(pb[0]),
    .ram0x00(ram0x00),
    .ram0x01(ram0x01),
    .ram0x02(ram0x02),
    .ram0x03(ram0x03),
    .ram0x04(ram0x04),
    .q(q)
);

assign right = ram0x00;
assign left = ram0x01;
assign {ss2, ss5} = 16'h0000;

always_comb begin : stateRGB
    case (q)
        SRST:    {red, green, blue} = 3'b001;
        SERR:    {red, green, blue} = 3'b100;
        SFINISH: {red, green, blue} = 3'b010;
        default: {red, green, blue} = 3'b110;
    endcase
end

hex_ss ram0x02ones (
    .hex(ram0x02[3:0]),
    .ss(ss0)
);
hex_ss ram0x02tens (
    .hex(ram0x02[7:4]),
    .ss(ss1)
);
hex_ss ram0x03ones (
    .hex(ram0x03[3:0]),
    .ss(ss3)
);
hex_ss ram0x03tens (
    .hex(ram0x03[7:4]),
    .ss(ss4)
);
hex_ss ram0x04ones (
    .hex(ram0x04[3:0]),
    .ss(ss6)
);
hex_ss ram0x04tens (
    .hex(ram0x04[7:4]),
    .ss(ss7)
);

endmodule