`timescale 1ns/1ps

module cpu_tb;

logic clk, rstn, start;

cpu dut(
    .clk(clk),
    .rstn(rstn),
    .start(start)
);

initial clk = 1'b0;
always #5 clk = ~clk;

initial begin : testing
    rstn = 1'b1;
    start = 1'b0;
    #5 $finish;
end

initial begin
    #10000 $finish;
end

initial begin
    $dumpfile("cpu_tb.vcd");
    $dumpvars(1, cpu_tb);
end

endmodule