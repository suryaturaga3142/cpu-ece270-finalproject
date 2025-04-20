`default_nettype none
`include "params.svh"
`ifndef core_guard
`define core_guard
include "sequencer.sv"
include "instr_mem.sv"
include "memory_controller.sv"
include "core.sv"
include "alu.sv"
include "RAM_wrapper.sv"

module cpu_wrapper (
  input logic [LINE_WIDTH-1:0] input_total,
  output logic [BUS_WIDTH-1:0] output_total
);

endmodule
