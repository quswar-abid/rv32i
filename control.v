module control (instruction, PCSel, ImmSel, RegWEn, BrUn, BrEq, BrLT, BSel, ASel, ALUSel, MemRW, WBSel, TypeSel);
    parameter DWIDTH = 64;

    input [DWIDTH-1:0] instruction;
    input BrEq;
    input BrLT;

    output              BrUn;
    output reg          PCSel;
    output reg [2:0]    ImmSel;
    output              RegWEn;
    output              BSel;
    output              ASel;
    output reg [4:0]    ALUSel;
    output              MemRW;
    output     [2:0]    TypeSel;
    output reg [1:0]    WBSel;

    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;


    assign opcode = instruction[6:0];
    assign funct3 = instruction[14:12];
    assign funct7 = instruction[31:25];


    // assign PCSel = (opcode==7'h63 & (BrLt)) |                    //SB type
    //                (opcode==7'h6F) |                    //UJ type
    //                (opcode==7'h67 & funct3==3'b000);    // I type (jalr only)

    always @(*) begin
        case(opcode)
            7'h67: begin
                if(funct3==3'b000) begin// I type (jalr only)
                    PCSel = 1'b1;
                end
            end
            7'h6F: begin                //UJ type
                PCSel = 1'b1;
            end
            7'h63: begin                //SB-type
                case(funct3)
                    3'd0: PCSel = BrEq;                     //BEQ
                    3'd1: PCSel = ~BrEq;                    //BNE
                    3'd4: PCSel = ~BrUn & BrLT;             //BLT
                    3'd5: PCSel = ~BrUn & (~BrLT | BrEq);   //BGE
                    3'd6: PCSel = BrUn & (BrLT);            //BLTU
                    3'd7: PCSel = BrUn & (~BrLT | BrEq);    //BGEU
                endcase
            end
            default: PCSel = 1'b0;
        endcase
    end

    always @(*) begin
        case(opcode)                                    //all opcodes except R-type
            7'h03: ImmSel = 3'd0;                       // I-type
            7'h13: begin
                if(funct3==1 | funct3==5) begin
                    ImmSel = 3'd5;                      // I-type(with shift ops.)
                end else begin
                    ImmSel = 3'd0;                      // I-type
                end
            end
            7'h17: ImmSel = 3'd3;                       // U-type
            7'h1B: begin
                if(funct3==1 | funct3==5) begin
                    ImmSel = 3'd5;                      // I-type(with shift ops.)
                end else begin
                    ImmSel = 3'd0;                      // I-type
                end
            end
            7'h23: ImmSel = 3'd1;                       // S-type
            7'h37: ImmSel = 3'd3;                       // U-type
            7'h63: ImmSel = 3'd2;                       //SB-type
            7'h67: ImmSel = 3'd0;                       // I-type
            7'h6F: ImmSel = 3'd4;                       //UJ-type
        endcase
    end

    assign RegWEn = (opcode == 7'h03) |                 //all opcodes except S-type & SB-type RISCV instructions
                    (opcode == 7'h13) |
                    (opcode == 7'h17) |
                    (opcode == 7'h1B) |
                    (opcode == 7'h33) |
                    (opcode == 7'h37) |
                    (opcode == 7'h3B) |
                    (opcode == 7'h67) |
                    (opcode == 7'h6F);

    assign MemRW = (opcode==7'h23);                     //Single bit MemRW asserted only for store instructions of S-type
    assign TypeSel = funct3;                            //lb/lh/lw/ld occur in order in both load & store

    always @(*) begin
        case(opcode)                                    //0 for DMEM, 1 for ALU, 2 for PC+4
            7'h03: WBSel = 2'd0;                        //I-type instructions consisting of lb/lh/lw/ld/lbu/lhu/lwu load instructions - hence from DMEM
            7'h13: WBSel = 2'd1;                        //I-type instructions consisting of immediate arithmetic ops - hence from ALU
            7'h17: WBSel = 2'd1;                        //Handle AUIPC (U-type) instruction - hence from ALU
            7'h1B: WBSel = 2'd1;                        //Handle arithmetic instructions with immediate of word size - hence from ALU
            7'h33: WBSel = 2'd1;                        //Handle R-type instructions that involve register operands - hence from ALU
            7'h37: WBSel = 2'd1;                        //Handle LUI (U-type) instruction - hence from ALU
            7'h3B: WBSel = 2'd1;                        //Handle R-type instructions that involve register operands - hence from ALU
            7'h67: WBSel = 2'd2;                        //Handle JALR (I-type) where R[rd] = PC + 4 - hence from PC+4
            7'h6F: WBSel = 2'd2;                        //Handle JALR (I-type) where R[rd] = PC + 4 - hence from PC+4
        endcase
    end

    assign BrUn = (opcode==7'h63) &                     //Branch Unsigned (BrUn) asserted only on 
                  ((funct3==3'd6)|(funct3==3'd7));

    assign ASel = (opcode==7'h63) |                     //SB-type instructions
                  (opcode==7'h17) |                     //U-type (AUIPC) instruction
                  (opcode==7'h6F);                      //UJ-type (JAL) instruction

    assign BSel = (opcode==7'h03) |                     //I-type instructions (and others that use immediate values from instructions as following)
                  (opcode==7'h13) |                     //I-type instructions
                  (opcode==7'h17) |                     //U-type (AUIPC) instruction
                  (opcode==7'h1B) |                     //I-type instructions
                  (opcode==7'h23) |                     //S-type instructions
                  (opcode==7'h37) |                     //U-type (LUI) instruction
                  (opcode==7'h63) |                     //SB-type instruction
                  (opcode==7'h67) |                     //I-type (JALR) instruction
                  (opcode==7'h6F);                      //UJ-type (JAL) instruction


    //output ALUSel based on deconstructed instruction
    always @(*) begin
        case(opcode)
            7'b0110011: begin
                case(funct3)
                    3'b000: begin
                        case (funct7)
                            7'b0000000: begin
                                ALUSel = 5'b00000;//ADD
                            end
                            7'b0100000: begin
                                ALUSel = 5'b00001;//SUB
                            end
                        endcase
                    end
                    3'b001: begin
                        ALUSel = 5'b00010;        //SLL
                    end
                    3'b010: begin
                        ALUSel = 5'b00011;        //SLT
                    end
                    3'b011: begin
                        ALUSel = 5'b00100;        //SLTU
                    end
                    3'b100: begin
                        ALUSel = 5'b00101;        //XOR
                    end
                    3'b101: begin
                        case(funct7)
                            7'b0000000: begin
                                ALUSel = 5'b00110;//SRL
                            end
                            7'b0100000: begin
                                ALUSel = 5'b00111;//SRA
                            end
                        endcase
                    end
                    3'b110: begin
                        ALUSel = 5'b01000;        //OR
                    end
                    3'b111: begin
                        ALUSel = 5'b01001;        //AND
                    end
                endcase
            end
            7'b0111011: begin
                case(funct3)
                    3'b000: begin
                        case(funct7)
                            7'b0000000: begin
                                ALUSel = 5'b01010;//ADDW
                            end
                            7'b0100000: begin
                                ALUSel = 5'b01011;//SUBW
                            end
                        endcase
                    end
                    3'b001: begin
                        ALUSel = 5'b01100;        //SLLW
                    end
                    3'b101: begin
                        case(funct7)
                            7'b0000000: begin
                                ALUSel = 5'b01101;//SRLW
                            end
                            7'b0100000: begin
                                ALUSel = 5'b01110;//SRAW
                            end
                        endcase
                    end
                endcase
            end
            7'b0010011: begin
                case(funct3)
                    3'b000: begin
                        ALUSel = 5'b01111;      //ADDI
                    end
                    3'b001: begin
                        case(funct7)
                            7'b0000000: begin
                                ALUSel = 5'b10000;//SLLI
                            end
                        endcase
                    end
                    3'b010: begin
                        ALUSel = 5'b10001;      //SLTI
                    end
                    3'b011: begin
                        ALUSel = 5'b10010;      //SLTIU
                    end
                    3'b100: begin
                        ALUSel = 5'b10011;      //XORI
                    end
                    3'b101: begin
                        case(funct7)
                            7'b0000000: begin
                                ALUSel = 5'b10100;//SRLI
                            end
                            7'b0100000: begin
                                ALUSel = 5'b10101;//SRAI
                            end
                        endcase
                    end
                    3'b110: begin
                        ALUSel = 5'b10110;//ORI
                    end
                    3'b111: begin
                        ALUSel = 5'b10111;//ANDI
                    end
                endcase
            end
            7'b0011011: begin
                case(funct3)
                    3'b000: begin
                        ALUSel = 5'b11000;//ADDIW
                    end
                    3'b001: begin
                        ALUSel = 5'b11001;//SLLIW
                    end
                    3'b010: begin
                        ALUSel = 5'b11010;//SRLIW
                    end
                    3'b011: begin
                        ALUSel = 5'b11011;//SRAIW
                    end
                endcase
            end
            7'b1100111: begin
                case(funct3)
                    3'b000: begin
                        ALUSel = 5'b11100;//JALR
                    end 
                endcase
            end
            7'b0010111: begin
                ALUSel = 5'b11111;
            end
            7'b0110111: begin
                ALUSel = 5'b11111;
            end
            7'b1100011: begin
                ALUSel = 5'b11111;
            end
        endcase
    end


    
endmodule
