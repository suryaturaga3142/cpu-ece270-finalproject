`timescale 1ns/1ps
`include "params.svh"

module ram_testbench;

logic clk; 
logic rstn = 1; 

logic write_en;

logic [BUS_WIDTH-1:0] waddr, raddr; 
logic [DATA_WIDTH-1:0] din, dout; 

ram dut (
   .din      (din),
   .write_en (write_en),
   .waddr    (waddr),
   .wclk     (clk),
   .raddr    (raddr),
   .rclk     (clk),
   .dout     (dout)
);

initial clk = 0; 
always #5 clk = ~clk; // alternate between high and low every 5ns

initial begin : testing
    
    write_en = 0;
    waddr =  '0; 
    raddr = '0;
    din = '0; 


    $display("Writing to RAM"); 
    for(int i=0; i<4; i++) begin
        @(posedge clk); 
        write_en = 1;
        #1; 
        waddr  = i;
        din = i + 8'hA0;
        $display("Data written at : 0x%0h to 0x%0h", waddr,din); 
    end

    @(posedge clk); 
    write_en <= 0; 

    $display("Finished writing to RAM");

    for(int i=1; i<5; i++) begin
        @(posedge clk); 
        raddr <= i;
        #1; 
        $display("The address is : 0x%0h, and the value at that address is 0x%0h", i-1, dout); 
    end

    $display("tb is done");
    $finish; 

end


initial begin : gtkwave
    $dumpfile("ram_tb.vcd");
    $dumpvars(1, ram_testbench);
end

endmodule 