`timescale 1ps/1ps

module cpu_tb;

logic clk, rstn, start;
logic [DATA_WIDTH-1:0] output_data0x00, output_data0x01;

cpu dut(
    .clk(clk),
    .rstn(rstn),
    .start(start),
    .output_data0x00(output_data0x00),
    .output_data0x01(output_data0x01)
);

initial clk = 1'b0;
always #5 clk = ~clk;

initial begin : testing
    {rstn, start} = 2'b00;
    #20 {rstn, start} = 2'b11;
    #15 start = 1'b0;
end

initial begin
    #10000 $finish;
end

initial begin
    $dumpfile("cpu_tb.vcd");
    $dumpvars(0, cpu_tb);
end

endmodule