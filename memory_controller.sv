`include "params.svh"


module memory_controller(
    input  logic  clk,
    input  logic  rst,
    input  logic [2:0]  write_read,          
    input  logic [BUS_WIDTH-1:0]  addr,            
    input  logic [BUS_WIDTH-1:0]  write_data,      
    input  logic [BUS_WIDTH-1:0]  ram_dout, 
       
    output logic [BUS_WIDTH-1:0]  waddr,
    output logic [BUS_WIDTH-1:0]  raddr,
    output logic [BUS_WIDTH-1:0]  din,
    output logic [BUS_WIDTH-1:0]  read_data,
    output logic  write_en,
    output logic  busy,
);

typedef enum [2:0] {IDLE, WRITE, READ} memory_state;
memory_state curr_state, next_state; 

always_ff @(posedge clk or posedge rst) begin
    if(rst) begin
        curr_state <= IDLE; 
    end else begin
        curr_state <= next_state; 
    end 
end

always_comb begin
    case(curr_state) 
        IDLE: begin
            if(write_read[1] == 1'b1 && write_read[0] == 1'b0) begin
                next_state = WRITE; 
            end else if(write_read[1] == 1'b0 && write_read[0] == 1'b1) begin
                next_state = READ; 
            end else begin
                next_state = IDLE:  
            end 
        end

        WRITE : next_state = IDLE; 

        READ : next_state = IDLE; 
    
        default : next_state = IDLE: 
    endcase
end

assign write_en = (state == WRITE) ? 1'b1 : 1'b0; 
assign waddr = addr; 
assign raddr = addr;
assign din = write_data; 
assign read_data = (state == READ) ? ram_dout : 2'h00; 
assign busy = (state != IDLE); 





endmodule 

