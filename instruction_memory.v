`timescale 1ns/1ns
module instruction_memory #(
  parameter  AWIDTH = 10, DWIDTH = 32
) (
  data_in, addr, clk, WE, rst, data_out
);
  
  input [DWIDTH-1:0] data_in;
  input [DWIDTH-1:0] addr;
  input clk,WE,rst;
  output [DWIDTH-1:0] data_out;
  
  integer  i;

  reg [7:0] memory [(2**AWIDTH)-1:0];

  assign data_out = {memory[addr+3], memory[addr+2], memory[addr+1], memory[addr+0]};
  // always @(*) begin
  //   //data_out <= {memory[addr+3], memory[addr+2], memory[addr+1], memory[addr+0]};
  //   data_out[7:0] <= memory[addr+0];
  //   data_out[15:8] <= memory[addr+1];
  //   data_out[23:16] <= memory[addr+2];
  //   data_out[31:24] <= memory[addr+3];
  // end
  
  
  always @(posedge clk or rst) begin
    if (rst) begin
      for(i=0; i<(2**AWIDTH); i=i+1)
        memory[i] = 8'b0;
    end else begin
      if (WE) begin
        memory[addr+0] <= data_in[7:0];
        memory[addr+1] <= data_in[15:8];
        memory[addr+2] <= data_in[23:16];
        memory[addr+3] <= data_in[31:24];
      end
    end
  end
    
    
endmodule
