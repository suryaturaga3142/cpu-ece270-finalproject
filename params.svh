`default_nettype none
`ifndef params_guard
`define params_guard

parameter LINE_WIDTH=32;   //Default length of single TYPICAL line={instr,targ,op1,op2}
parameter BUS_WIDTH=8;     //Length of func & data mem addr
parameter DATA_WIDTH=8;    //Length of data EQUAL TO BUS_WIDTH
parameter OPCODE_WIDTH=16; //Length of function opcodes
parameter IP_WIDTH=32;     //Length of address to a single line of code

// States enum for sequencer
typedef enum logic [2:0] { SRST, SREAD, SREG, SCALC, SWRITE, SFINISH, SERR } SequencerState;

`endif
