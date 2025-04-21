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
always_ff @( posedge clk, negedge rstn ) begin : fflogic
    if (!rstn) begin
        q <= SRST;
    end else if (err) begin
        q <= SERR;
    end else begin
        q <= nxt_q;
    end
end
always_comb begin : nextStateLogic
    case (q)
        SRST:    nxt_q = (start) ? SREAD : SRST;
        SREAD:   nxt_q = SLOAD1;
        SLOAD1:  nxt_q = SLOAD2;
        SLOAD2:  nxt_q = SCALC;
        SCALC:   nxt_q = (finish) ? SFINISH : (nxt_instr) ? SWRITE : SCALC;
        SWRITE:  nxt_q = SREAD;
        default: nxt_q = q; //SFINISH -> SFINISH, SERR -> SERR
    endcase
end
endmodule

`endif