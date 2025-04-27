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
assign line = code[ip];


// Code to multiply 5 x 6 through repeated addition
assign code[0] = 32'h03000000; //set sum = 0
assign code[1] = 32'h03010000; //set c = 0
assign code[2] = 32'h03020600; //set y = 6
assign code[3] = 32'h03030500; //set x = 5
assign code[4] = 32'h50080102; //beq 0x08, c, y
assign code[5] = 32'h00000003; //add sum, sum, x
assign code[6] = 32'h02010101; //add c, c, 1
assign code[7] = 32'h40040000; //jump 0x04
assign code[8] = 32'hffffffff; //end

/*
// Code for ecelabs7. Finds the GCD of a and b. To check, use a = code[0][7:4], b = code[1][7:4]
assign code[0] = 32'h0300ff00; //set a = ff
assign code[1] = 32'h03010800; //set b = 08
assign code[2] = 32'h03020000; //set gcd = 0
assign code[3] = 32'h02030000; //set ram0x03 = a
assign code[4] = 32'h02040100; //set ram0x04 = b
assign code[5] = 32'h500b0001; //beq 0x09 a, b
assign code[6] = 32'h58090001; //bgt 0x07 a, b
assign code[7] = 32'h08010100; //sub b, b, a
assign code[8] = 32'h40050000; //jump 0x03
assign code[9] = 32'h08000001; //sub a, a, b
assign code[10]= 32'h40050000; //jump 0x03
assign code[11]= 32'h00020200; //add gcd, gcd, a
assign code[12]= 32'hffffffff; //end
*/

/*
// Small test code to set two values.
assign code[0] = 32'h03000010; //set x = 10
assign code[1] = 32'h03010055; //set y = 55
assign code[2] = 32'hf0000000; //end
*/

endmodule

`endif