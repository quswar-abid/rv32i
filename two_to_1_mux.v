`timescale 1ns/1ns

module two_to_1_mux #(parameter DWIDTH = 64) (Sel, input_1, input_2, output_1);

    input Sel;
    input [DWIDTH-1:0] input_1;
    input [DWIDTH-1:0] input_2;
    output[DWIDTH-1:0] output_1;

    assign output_1 = ~Sel ? input_1 : input_2;
endmodule