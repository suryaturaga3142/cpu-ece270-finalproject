`timescale 1ps/1ps

module ram_tb;
    
logic clk, rstn;
logic [7:0] addr_rd, addr_wr, data_rd, data_wr;
logic rd_en, wr_en;

ram dut (
    .clk(clk), .rstn(rstn),
    .addr_rd(addr_rd), .addr_wr(addr_wr),
    .data_wr(data_wr),
    .rd_en(rd_en), .wr_en(wr_en),
    .data_rd(data_rd)
);

initial begin : testing
    {rstn, rd_en, wr_en} = 3'b000;
    #20 rstn = 1'b1;
    wr_en = 1'b1;
    addr_wr = 8'h00;
    data_wr = 8'haf;
    #20 wr_en = 1'b1;
    rd_en = 1'b1;
    data_wr = 8'hff;
    addr_rd = 8'h00;
    #20
    $finish;
end

initial begin : clkGen
    clk = 1'b0;
    while (1) begin
        #10 clk = ~clk;
    end
end

initial begin : runtime
    #1000 $finish;
end

initial begin : gtkwave
    $dumpfile("ram_tb.vcd");
    $dumpvars(1, ram_tb);
end

endmodule