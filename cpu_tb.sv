`timescale 1ps/1ps

module cpu_tb;

logic clk, rstn, start;
logic [DATA_WIDTH-1:0] ram0x00, ram0x01, ram0x02, ram0x03, ram0x04;
SequencerState q;

cpu dut(
    .clk(clk),
    .rstn(rstn),
    .start(start),
    .ram0x00     (ram0x00),
    .ram0x01     (ram0x01),
    .ram0x02     (ram0x02),
    .ram0x03     (ram0x03),
    .ram0x04     (ram0x04),
    .q(q)
);

initial clk = 1'b0;
always #1 clk = ~clk;

initial begin : testing
    {rstn, start} = 2'b00;
    #2 {rstn, start} = 2'b11;
    #2 start = 1'b0;
end

initial begin
    #1000 $finish;
end

initial begin
    $dumpfile("cpu_tb.vcd");
    $dumpvars(0, cpu_tb);
end

endmodule