module pc_inc #(
    parameter DWIDTH = 64
) (
    input_pc, output_pc
);
    input [DWIDTH-1:0] input_pc;
    output [DWIDTH-1:0] output_pc;
    
    assign output_pc = input_pc + 4;
    
endmodule