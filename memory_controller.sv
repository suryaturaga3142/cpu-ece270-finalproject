
module memory_controller(
    input  logic  clk,
    input  logic  rst_n,
    input  logic  start_write,     
    input  logic  start_read,     
    input  logic [8:0]  addr,            
    input  logic [7:0]  write_data,      
    input  logic [7:0]  ram_dout,        
    output logic [8:0]  waddr,
    output logic [8:0]  raddr,
    output logic [7:0]  din,
    output logic [7:0]  read_data,
    output logic  write_en,
    output logic  busy,
    output logic  done
)

typedef enum data_type {  } name;





endmodule 

