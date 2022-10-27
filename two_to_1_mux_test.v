`timescale 1ns/1ns

module two_to_1_mux_test;

    reg Sel;
    reg [31:0] input_1;
    reg [31:0] input_2;
    output wire [31:0] output_1;

    two_to_1_mux #(.DWIDTH(32)) dut (.*);

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
        Sel = 0;
        input_1 = 32'hdead_beaf;
        input_2 = 32'h0000_0000;
        #20 Sel = 0;
        #20 Sel = 1;
        #20 Sel = 1;
        #20 Sel = 0;
        #20 Sel = 1;
        #20 Sel = 0;
        #20 Sel = 1;
        #20 Sel = 0;
        #20 Sel = 1;
        #20 Sel = 0;
        #20 Sel = 1;
        #20 Sel = 0;
        #20 Sel = 1;
        #100 $finish;
    end
endmodule