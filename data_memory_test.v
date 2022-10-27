module data_memory_test;

    reg clk, rst, MemRW;
    reg [31:0] Addr, DataW;
    reg [2:0] type;
    wire [31:0] DataR;


    data_memory #(.DWIDTH(32), .AWIDTH(10)) dut (.*);

    integer i;


    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;

        clk = 1;
        rst = 1;
        MemRW = 0;

        Addr = 0;
        DataW = 0;

        #10 rst = 0;

        #10 type = 0;
        #10 Addr++;
        #10 Addr++;
        #10 Addr++;
        #10 Addr++;
        #10 Addr++;

        #10 type++;
        #10 Addr++;
        #10 Addr++;
        #10 Addr++;
        #10 Addr++;
        #10 Addr++;

        #10 type++;
        #10 Addr++;
        #10 Addr++;
        #10 Addr++;
        #10 Addr++;
        #10 Addr++;

        #10 type++;
        #10 Addr++;
        #10 Addr++;
        #10 Addr++;
        #10 Addr++;
        #10 Addr++;
        
        #10 type++;
        #10 Addr++;
        #10 Addr++;
        #10 Addr++;
        #10 Addr++;
        #10 Addr++;

        #10 type++;
        #10 Addr++;
        #10 Addr++;
        #10 Addr++;
        #10 Addr++;
        #10 Addr++;

        #10 type++;
        #10 Addr++;
        #10 Addr++;
        #10 Addr++;
        #10 Addr++;
        #10 Addr++;

        MemRW = 1;
        type = 2;

        for (i=0; i<1024; i++) begin
            #10 DataW = i;
            Addr = i;
        end
    
        MemRW = 0;
        type = 5;

        for (i=0; i<1024; i++) begin
            #10 Addr = i;
        end

        #100 $finish;



    end

    always #5 clk = ~clk;




endmodule