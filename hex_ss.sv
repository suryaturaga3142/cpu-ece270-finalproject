`default_nettype none
`include "params.svh"
`ifndef hex_ss_guard
`define hex_ss_guard

/*
Converts a single hex digit into a single seven segment digit display signal.
*/

module hex_ss (
    input logic [3:0] hex,
    output logic [7:0] ss
);

always_comb begin : ssLogic
    case (hex)
        4'h0: ss = 8'h3f;
        4'h1: ss = 8'h06;
        4'h2: ss = 8'h5b;
        4'h3: ss = 8'h4f;
        4'h4: ss = 8'h76;
        4'h5: ss = 8'h6d;
        4'h6: ss = 8'h7d;
        4'h7: ss = 8'h07;
        4'h8: ss = 8'h7f;
        4'h9: ss = 8'h67;
        4'ha: ss = 8'h77;
        4'hb: ss = 8'h7c;
        4'hc: ss = 8'h39;
        4'hd: ss = 8'h5e;
        4'he: ss = 8'h79;
        4'hf: ss = 8'h71;
        default: ss = 8'h00;
    endcase
end

endmodule