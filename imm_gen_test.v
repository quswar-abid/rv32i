module imm_gen_test;

    reg [31:0] instruction;
    reg [2:0] ImmSel;
    wire [31:0] immediate;

    imm_gen #(.DWIDTH(32)) dut (.instruction(instruction[31:7]),
                                .ImmSel(ImmSel),
                                .immediate(immediate)
                                );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;

        #5 instruction = 32'h000102b3;
        #5 instruction = 32'h000102b3; ImmSel = 0;
        #5 instruction = 32'h00900093; ImmSel = 0;

        // #5 instruction = 32'h


        #20 $finish;
    end
    
endmodule