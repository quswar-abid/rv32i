module alu(alu_sel, alu_input_A, alu_input_B, alu_output);

    parameter DWIDTH=64;
    input [4:0] alu_sel;
    input [DWIDTH-1:0] alu_input_A;
    input [DWIDTH-1:0] alu_input_B;
    output reg [DWIDTH-1:0] alu_output;
    always @(*) begin
        case(alu_sel)
            //R-type instructions
            5'b00000: alu_output = alu_input_A + alu_input_B;                                //ADD
            5'b00001: alu_output = alu_input_A - alu_input_B;                                //SUB
            5'b00010: alu_output = alu_input_A << alu_input_B;                               //SLL
            5'b00011: alu_output = ($signed(alu_input_A) < $signed(alu_input_B)) ? 1 : 0;    //SLT
            5'b00100: alu_output = (alu_input_A < alu_input_B) ? 1 : 0;                      //SLTU
            5'b00101: alu_output = alu_input_A ^ alu_input_B;                                //XOR
            5'b00110: alu_output = alu_input_A >> alu_input_B;                               //SRL
            5'b00111: alu_output = $signed(alu_input_A) >>> alu_input_B;                     //SRA
            5'b01000: alu_output = alu_input_A | alu_input_B;                                //OR
            5'b01001: alu_output = alu_input_A & alu_input_B;                                //AND
            5'b01010: alu_output = alu_input_A[31:0] + alu_input_B[31:0];                    //ADDW
            5'b01011: alu_output = alu_input_A[31:0] - alu_input_B[31:0];                    //SUBW
            5'b01100: alu_output = alu_input_A[31:0] << alu_input_B[31:0];                   //SLLW
            5'b01101: alu_output = alu_input_A[31:0] >> alu_input_B[31:0];                   //SRLW
            5'b01110: alu_output = $signed(alu_input_A[31:0]) >>> alu_input_B[31:0];         //SRAW
            //I-type instructions
            5'b01111: alu_output = $signed(alu_input_A) + $signed(alu_input_B);              //ADDI
            5'b10000: alu_output = alu_input_A << alu_input_B;                               //SLLI
            5'b10001: alu_output = ($signed(alu_input_A) < $signed(alu_input_B)) ? 1 : 0;    //SLTI
            5'b10010: alu_output = (alu_input_A < alu_input_B) ? 1 : 0;                      //SLTIU 
            5'b10011: alu_output = alu_input_A ^ alu_input_B;                                //XORI
            5'b10100: alu_output = alu_input_A >> alu_input_B;                               //SRLI
            5'b10101: alu_output = $signed(alu_input_A) >>> alu_input_B;                     //SRAI
            5'b10110: alu_output = alu_input_A | alu_input_B;                                //ORI    
            5'b10111: alu_output = alu_input_A & alu_input_B;                                //ANDI
            5'b11000: alu_output[31:0] = alu_input_A[31:0] + alu_input_B[31:0];              //ADDIW
            5'b11001: alu_output[31:0] = alu_input_A[31:0] << alu_input_B[31:0];             //SLLIW
            5'b11010: alu_output[31:0] = alu_input_A[31:0] >> alu_input_B[31:0];             //SRLIW
            5'b11011: alu_output[31:0] = $signed(alu_input_A[31:0]) >>> alu_input_B[31:0];   //SRAIW
            5'b11100: alu_output = alu_input_A + alu_input_B;                                //JALR
            //U/UJ/SB-type instructions
            5'b11111: alu_output = alu_input_A + alu_input_B;                                //For all U/UJ/SB type instructions
            /*
            //U-type instruction
            5'b11100: alu_output = alu_input_A + alu_input_B;                                //AUIPC
            5'b11101: alu_output = alu_input_A + alu_input_B;                                //LUI
            //UJ-type instruction
            5'b11110: alu_output = alu_input_A + alu_input_B;                                //JAL
            5'b11111: alu_output =
            */ 
        endcase
    end
endmodule