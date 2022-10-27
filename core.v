module core #(
    parameter DWIDTH = 32
) (
    clock, start, reset 
);
    input clock, start, reset;

    wire clk;
    assign clk = clock;// & start;

    // wire rst;

    //controller section: wires coming in and out of controller
    wire [DWIDTH-1:0]   wire_inst;
    wire                wire_PCSel;
    wire [2:0]          wire_ImmSel;
    wire                wire_RegWEn;
    wire                wire_BrUn;
    wire                wire_BrEq;
    wire                wire_BrLt;
    wire                wire_BSel;
    wire                wire_ASel;
    wire [4:0]          wire_ALUSel;
    wire                wire_MemRW;
    wire [2:0]          wire_TypeSel;
    wire [1:0]          wire_WBSel;

    //datapath section: other wires in datapath (except wire_inst which I already declared in controller section)
    wire [DWIDTH-1:0] wire_alu;
    wire [DWIDTH-1:0] wire_pcPlus4;
    wire [DWIDTH-1:0] wire_pcMux;
    wire [DWIDTH-1:0] wire_pc;
    wire [DWIDTH-1:0] wire_imm;
    wire [DWIDTH-1:0] wire_regRS1;
    wire [DWIDTH-1:0] wire_regRS2;
    wire [DWIDTH-1:0] wire_mem;
    wire [DWIDTH-1:0] wire_wb;
    wire [DWIDTH-1:0] wire_aMux;
    wire [DWIDTH-1:0] wire_bMux;
    // wire wire_;
    



    branch_comp             #(.DWIDTH(DWIDTH)) module_branch_comp
                                               (.DataA(wire_regRS1),
                                                .DataB(wire_regRS2),
                                                .BrUn(wire_BrUn),
                                                .BrEq(wire_BrEq),
                                                .BrLt(wire_BrLt)
                                                );
    imm_gen                 #(.DWIDTH(DWIDTH)) module_imm_gen
                                               (.instruction(wire_inst[31:7]),
                                                .ImmSel(wire_ImmSel),
                                                .immediate(wire_imm)
                                                );
    alu                     #(.DWIDTH(DWIDTH)) module_alu
                                               (.alu_sel(wire_ALUSel),
                                                .alu_input_A(wire_aMux),
                                                .alu_input_B(wire_bMux),
                                                .alu_output(wire_alu)
                                                );
    instruction_memory      #(.DWIDTH(DWIDTH)) module_instruction_memory
                                               (.data_in(32'b0),
                                                .addr(wire_pc),
                                                .clk(clk),
                                                .WE(1'b0),
                                                .rst(reset),
                                                .data_out(wire_inst)
                                                );
    data_memory             #(.DWIDTH(DWIDTH)) module_data_memory  
                                               (.DataW(wire_regRS2),
                                                .Addr(wire_alu),
                                                .clk(clk),
                                                .MemRW(wire_MemRW),
                                                .rst(reset),
                                                .DataR(wire_mem),
                                                .type(wire_TypeSel)
                                                );
    pc_inc                  #(.DWIDTH(DWIDTH)) module_pc_inc
                                               (.input_pc(wire_pc),
                                                .output_pc(wire_pcPlus4)
                                                );
    regfile                 #(.DWIDTH(DWIDTH)) module_regfile
                                               (.rst(reset),
                                                .clk(clk),
                                                .RegWEn(wire_RegWEn),
                                                .AddrA(wire_inst[19:15]),
                                                .AddrB(wire_inst[24:20]),
                                                .AddrD(wire_inst[11:7]),
                                                .DataA(wire_regRS1),
                                                .DataB(wire_regRS2),
                                                .DataD(wire_wb)
                                                );
    control                 #(.DWIDTH(DWIDTH)) module_control
                                               (.instruction(wire_inst),
                                                .PCSel(wire_PCSel),
                                                .ImmSel(wire_ImmSel),
                                                .RegWEn(wire_RegWEn),
                                                .BrUn(wire_BrUn),
                                                .BrEq(wire_BrEq),
                                                .BrLT(wire_BrLt),
                                                .BSel(wire_BSel),
                                                .ASel(wire_ASel),
                                                .ALUSel(wire_ALUSel),
                                                .MemRW(wire_MemRW),
                                                .WBSel(wire_WBSel),
                                                .TypeSel(wire_TypeSel)
                                                );
    four_to_1_mux           #(.DWIDTH(DWIDTH)) module_wbMux
                                               (.Sel(wire_WBSel),
                                                .input_1(wire_mem),
                                                .input_2(wire_alu),
                                                .input_3(wire_pcPlus4),
                                                .input_4(32'b0),
                                                .output_1(wire_wb)
                                                );
    pc                      #(.DWIDTH(DWIDTH)) module_pc
                                               (.data_in(wire_pcMux),
                                                .clk(clk),
                                                .rst(reset),
                                                .data_out(wire_pc)
                                                );
    two_to_1_mux            #(.DWIDTH(DWIDTH)) module_pcMux
                                               (.Sel(wire_PCSel),
                                                .input_1(wire_pcPlus4),
                                                .input_2(wire_alu),
                                                .output_1(wire_pcMux)
                                                );
    two_to_1_mux            #(.DWIDTH(DWIDTH)) module_aMux
                                               (.Sel(wire_ASel),
                                                .input_1(wire_regRS1),
                                                .input_2(wire_pc),
                                                .output_1(wire_aMux));
    two_to_1_mux            #(.DWIDTH(DWIDTH)) module_bMux
                                              (.Sel(wire_BSel),
                                               .input_1(wire_regRS2),
                                               .input_2(wire_imm),
                                               .output_1(wire_bMux)
                                               );

    
    
endmodule