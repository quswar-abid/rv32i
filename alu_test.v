module alu_test;

    reg [31:0] i_1, i_2;
    wire [31:0] o;
    reg [3:0] ALUSel;

    alu #(.DWIDTH(32)) dut(.alu_sel(ALUSel),
                        .alu_input_A(i_1),
                        .alu_input_B(i_2),
                        .alu_output(o)
                        );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
        
        i_1 = 10;
        i_2 = 10;
        ALUSel = 0;

        #5 ALUSel++;
        #5 ALUSel++;
        #5 ALUSel++;
        #5 ALUSel++;
        #5 ALUSel++;
        #5 ALUSel++;
        #5 ALUSel++;
        #5 ALUSel++;
        #5 ALUSel++;
        #5 ALUSel++;
        #5 ALUSel++;
        #5 ALUSel++;
        #5 ALUSel++;
        #5 ALUSel++;
        #5 ALUSel++;
        #5 ALUSel++;
        #5 ALUSel++;
        #5 ALUSel++;
        #5 ALUSel++;
        #5 ALUSel++;
        

        $finish;
        
    end



endmodule