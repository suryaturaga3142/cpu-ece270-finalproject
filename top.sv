module top (
    input logic CLK, // FPGA clock
    input logic SW1, // SW1 on FPGA board - used for reset
    input logic SW2, // SW2 on FPGA board - used for start signal
);
    
cpuinst cpu(
    .clk        (CLK), 
    .start      (SW2), 
    .rstn       (SW1) // Active low reset
);

endmodule