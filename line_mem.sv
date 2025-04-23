`default_nettype none
`include "params.svh"
`ifndef line_mem_guard
`define line_mem_guard

/*
Memory file to hold all lines of code to execute by CPU.
Instruction pointer points to line of code.
*/

module line_mem (
    input logic en,
    input logic [IP_WIDTH-1:0] ip,
    output logic [LINE_WIDTH-1:0] line
);

logic [LINE_WIDTH-1:0] code [(1<<BUS_WIDTH)-1:0];

/* Code to multiply 5 x 6 through repeated addition
assign code[0] = 32'h03000000; //set sum = 0
assign code[1] = 32'h03010000; //set c = 0
assign code[2] = 32'h03020600; //set y = 6
assign code[3] = 32'h03030500; //set x = 5
assign code[4] = 32'h50080102; //beq 0x08, c, y
assign code[5] = 32'h00000003; //add sum, sum, x
assign code[6] = 32'h02010101; //add c, c, 1
assign code[7] = 32'h40040000; //jump 0x04
assign code[8] = 32'hffffffff; //end
*/

assign code[0] = 32'h03000f00; //set a = 0f
assign code[1] = 32'h03010600; //set b = 06
assign code[2] = 32'h03020000; //set gcd = 0
assign code[3] = 32'h50090001; //beq 0x09 a, b
assign code[4] = 32'h54070001; //bgt 0x07 a, b
assign code[5] = 32'h04010100; //sub b, b, a
assign code[6] = 32'h40030000; //jump 0x03
assign code[7] = 32'h04000001; //sub a, a, b
assign code[8] = 32'h40030000; //jump 0x03
assign code[9] = 32'h00020200; //add gcd, gcd, a
assign code[10]= 32'hffffffff; //end

/*
assign code[0] = 32'h03000010; //set x = 10
assign code[1] = 32'h03010055; //set y = 55
assign code[2] = 32'h40000000; //jump 0x00
*/
/*
//For synthesis
always @* begin
    if (en) line = code[ip];
end
*/

//For simulation
///*
always_latch begin : lineAssignment
    if(en) begin
        line = code[ip];
    end
end
//*/

endmodule

`endif