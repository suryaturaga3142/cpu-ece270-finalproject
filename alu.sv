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
    input logic clk, rstn, en, ip_update_en,
    input logic [DATA_WIDTH-1:0] value1, value2,
    input logic [BUS_WIDTH-1:0] addr1, addr2,
    input logic [OPCODE_WIDTH-1:0] opcode,
    output logic [DATA_WIDTH-1:0] result,
    //output logic [IP_WIDTH-1:0] nxt_ip,
    output logic calc_done, update_ip, err, finish
);
logic [DATA_WIDTH-1:0] op1, op2, nxt_result;
//logic [IP_WIDTH-1:0] update_nxt_ip;
logic nxt_calc_done, nxt_update_ip;
assign op1 = opcode[0] ? addr1 : value1;
assign op2 = opcode[1] ? addr2 : value2;
assign finish = opcode[7];

assign err = 1'b0;

always_ff @( posedge clk, negedge rstn ) begin : nxtStateAssignment
    if (!rstn) begin
        result <= '0;
        calc_done <= 1'b0;
        update_ip <= 1'b0;
        //nxt_ip <= '0;
    end else begin
        result <= en ? nxt_result : result;
        calc_done <= en ? nxt_calc_done : calc_done;
        update_ip <= en ? nxt_update_ip : update_ip;
        //nxt_ip <= ip_update_en ? update_nxt_ip : nxt_ip;
    end
end

always_comb begin : arithmeticAssignment
    if (~finish) begin
        nxt_calc_done = 1'b1;
        if (~opcode[6]) begin
            //update_nxt_ip = nxt_ip + 1;
            nxt_update_ip = 1'b0;
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
            case (opcode[5:3])
                3'b000: nxt_update_ip = 1'b1;
                3'b001: nxt_update_ip = (op1 === 8'hff);
                3'b010: nxt_update_ip = (op1 == op2);
                3'b011: nxt_update_ip = (op1 > op2);
                default: nxt_update_ip = 1'b1;
            endcase
        end
    end else begin
        nxt_result = result;
        nxt_calc_done = 1'b1;
        nxt_update_ip = 1'b0;
        //update_nxt_ip = nxt_ip;
    end
end

endmodule

`endif 