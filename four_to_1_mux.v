`timescale 1ns/1ns

module four_to_1_mux #(parameter DWIDTH = 64) (Sel, input_1, input_2, input_3, input_4, output_1);

    input [1:0] Sel;
    input [DWIDTH-1:0] input_1;
    input [DWIDTH-1:0] input_2;
    input [DWIDTH-1:0] input_3;
    input [DWIDTH-1:0] input_4;
    output reg [DWIDTH-1:0] output_1;

    always @(*) begin
        case(Sel)
            2'd0: output_1 = input_1;
            2'd1: output_1 = input_2;
            2'd2: output_1 = input_3;
            2'd3: output_1 = input_4;
        endcase
    end

endmodule