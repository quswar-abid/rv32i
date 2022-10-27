module branch_comp_test;
    
    reg [31:0] DataA, DataB;
    reg BrUn;
    wire BrEq, BrLt;

    branch_comp #(.DWIDTH(32)) dut (.*);

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;

        DataA = 20;
        DataB = 10;

        #5 BrUn = 1;

        #5 DataA = -20; DataB = -10;
        #5 DataA = -20; DataB = 10;
        #5 DataA = 20; DataB = -10;
        #5 DataA = 20; DataB = 10;
        
        #5 BrUn = 0;

        #5 DataA = -20; DataB = -10;
        #5 DataA = -20; DataB = 10;
        #5 DataA = 20; DataB = -10;
        #5 DataA = 20; DataB = 10;

        #50 $finish;
    end
endmodule