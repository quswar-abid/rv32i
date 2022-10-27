module pc_inc_test;
    reg [31:0] ip;
    wire [31:0] op;

    pc_inc #(.DWIDTH(32)) dut (.input_pc(ip),
                               .output_pc(op)
                               );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
        ip = 0;
        #10 ip = 4;
        #10 ip = 8;
        #10 ip = 4;
        #10 ip = 5;
        #10 ip = 6;
        $finish;
    end


endmodule