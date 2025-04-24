`default_nettype none
`include "params.svh"
`ifndef sequencer_guard
`define sequencer_guard

/*
Sequencer to control state of CPU. Uses active high start, nxt_instr, and error signals.
Stays in SCALC to allow multicycle operations.
*/

module sequencer (
    input logic clk, rstn, start, nxt_line, err, finish,
    output SequencerState q
);

SequencerState nxt_q;
always_ff @( posedge clk, negedge rstn ) begin : nxtStateAssignment
    if (!rstn) begin
        q <= SRST;
    end else if (err) begin
        q <= SERR;
    end else begin
        q <= nxt_q;
    end
end
always_comb begin : nxtStateLogic
    case (q)
        SRST:    nxt_q = (start === 1'b1) ? SR1 : SRST;
        SR1:     nxt_q = SR2;
        SR2:     nxt_q = SR3;
        SR3:     nxt_q = SR4;
        SR4:     nxt_q = SCALC;
        SCALC:   nxt_q = (finish == 1'b1) ? SFINISH : (nxt_line == 1'b1) ? SWRITE : SCALC;
        SWRITE:  nxt_q = SNXT;
        SNXT:    nxt_q = SR1;
        default: nxt_q = q; //SFINISH -> SFINISH, SERR -> SERR
    endcase
end
endmodule

`endif