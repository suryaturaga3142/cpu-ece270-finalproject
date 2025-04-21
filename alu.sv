`default_nettype none
`include "params.svh"
`ifndef alu_guard
`define alu_guard

/*
ALU module to handle all calculations. Registers and flags are loaded in SREAD state.
All calcs done in SCALC state, outputs result when ready w/ multicycle operations.
opcode[7:0] breakdown:
7   - Finish signal
6   - 0=Arithmetic, 1=Control
5:2 - Function choose
1   - 0 uses value2, 1 uses &value2=addr2
0   - 0 uses value1, 1 uses &value1=addr1
*/

module alu (
    input logic clk, rstn, en,
    input logic [DATA_WIDTH-1:0] value1, value2,
    input logic [BUS_WIDTH-1:0] addr1, addr2,
    input logic [OPCODE_WIDTH-1:0] opcode,
    output logic [DATA_WIDTH-1:0] result,
    output logic calc_done, err, finish
);
logic [DATA_WIDTH-1:0] op1, op2, nxt_result;
assign op1 = opcode[0] ? addr1 : value1;
assign op2 = opcode[1] ? addr2 : value2;
assign finish = opcode[7];

always_ff @( posedge clk, negedge rstn ) begin : nxtStateAssignment
    if (!rstn) begin
        result <= 0;
    end else begin
        result <= en ? nxt_result : result;
    end
end

always_comb begin : arithmeticAssignment
    if (~finish) begin
        err = 1'b0;
        calc_done = 1'b1;
        case (opcode[5:3])
            3'b000: nxt_result = opcode[2] ?   op1 ^ op2  : op1 + op2;
            3'b001: nxt_result = opcode[2] ?   op1 | op2  : op1 - op2;
            3'b010: nxt_result = opcode[2] ? ~(op1 | op2) : op1 << op2;
            3'b011: nxt_result = opcode[2] ?   op1 & op2  : op1 >> op2;
            3'b100: nxt_result = opcode[2] ? ~(op1 & op2) : (op1 > op2)  ? 8'hff : 8'h00;
            default:nxt_result = opcode[2] ? ~(op1 ^ op2) : (op1 == op2) ? 8'hff : 8'h00;
        endcase
    end else begin
        nxt_result = result;
        err = 1'b0;
        calc_done = 1'b1;
    end
end

endmodule

`endif 