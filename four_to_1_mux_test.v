module four_to_1_mux_test;

    reg [1:0] WBSel;
    wire [31:0] output_1;

    four_to_1_mux #(.DWIDTH(32)) dut (.Sel(WBSel),
                                      .input_1(32'd1),
                                      .input_2(32'd2),
                                      .input_3(32'd3),
                                      .input_4(32'd4),
                                      .output_1(output_1)
                                      );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;

        WBSel = 0;

        #5 WBSel++;
        #5 WBSel++;
        #5 WBSel++;
        #5 WBSel++;
        #5 WBSel++;
        #5 WBSel++;
        #5 WBSel++;
        #5 WBSel++;
        

        $finish;
    end
    
endmodule