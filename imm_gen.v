module imm_gen #(
    parameter DWIDTH=32
) (
    instruction, ImmSel, immediate
);

    input [31:7] instruction;
    input [2:0] ImmSel;
    output reg [DWIDTH-1:0] immediate;

    always @(*) begin
        case (ImmSel)
            3'd0: begin                     //I-type
                immediate[11:0] = instruction[31:20];
                immediate[31:12] = {20{instruction[31]}};
            end

            3'd1: begin                     //S-type
                immediate[4:0] = instruction[11:7];
                immediate[11:5]= instruction[31:25];
                immediate[31:12] = {20{instruction[31]}};
            end

            3'd2: begin                     //SB-type
                immediate[0] = 1'b0;
                immediate[4:1]= instruction[11:8];
                immediate[10:5] = instruction[30:25];
                immediate[11] = instruction[7];
                immediate[12] = instruction[31];
                immediate[31:13]={19{instruction[31]}};
            end

            3'd3: begin                     //U-type
                immediate[31:12] = instruction[31:12];
                immediate[11:0] = 12'b0;
            end

            3'd4: begin                     //UJ-type
                immediate[0] = 1'b0;
                immediate[10:1] = instruction[30:21];
                immediate[11] = instruction[20];
                immediate[19:12] = instruction[19:12];
                immediate[20] = instruction[31];
                immediate[31:21] = {10{instruction[31]}};
            end
            3'd5: begin                     //I-type (with shift operations)
                immediate[4:0] = instruction[24:20];
                immediate[31:5] = {27{1'b0}};
            end
        endcase
    end
    
endmodule