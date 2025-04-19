`default_nettype none
`ifndef params_guard
`define params_guard

parameter INSTR_WIDTH=32;//Default line of single TYPICAL instr={func,targ,op1,op2}
parameter BUS_WIDTH=8;//Length of func & data mem addr
parameter DATA_WIDTH=8;//Length of data
parameter OPCODE_WIDTH=16;//Length of function opcodes
parameter IP_WIDTH=32;//Length of address to a single line of code

`endif