module generic_memory_test;

    reg [31:0] data_in;
    reg [31:0] addr;
    reg clk, rst, WE;
    wire [31:0] data_out;


    instruction_memory #(.AWIDTH(10), .DWIDTH(32)) dut (.data_in(data_in),
                                                        .addr(addr),
                                                        .clk(clk),
                                                        .WE(WE),
                                                        .rst(rst),
                                                        .data_out(data_out)
                                                        );
    
    integer i;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;


        addr = 0;

        clk = 1;
        rst = 1;
        WE = 0;

        #10 rst = 0;
        WE = 1;

        for (i=0; i<2**10; i+=4) begin
            // dut.Data_Mem[i] = i;
            #10data_in <= i;
            addr <= i;
        end
        
        WE = 0;

        for (i=0; i<2**10; i+=4) begin
            // dut.Data_Mem[i] = i;
            #10data_in <= 32'hdead_beaf;
            addr <= i;
        end

        // data_in = 32'hdead_beaf;

        // #1000 WE = 0; addr = 0;

        #5000 $finish;
    end

    always #5 clk = ~clk;

    // always @(posedge clk) begin
    //     addr+=4;
    //     data_in++;
    // end


endmodule