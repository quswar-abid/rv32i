`timescale 1ns/1ns
module pc #(parameter DWIDTH = 64) (data_in, clk, rst, data_out);

  // parameter DWIDTH = 64;
  
  input [DWIDTH-1:0] data_in;
  input clk, rst;
  output reg [DWIDTH-1:0] data_out;
  
  always @(posedge clk ) begin
    if (rst) begin
        data_out = 0;
    end else begin
      data_out = data_in; 
    end
  end
    
    
endmodule
