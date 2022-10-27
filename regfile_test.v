`timescale 1ns/1ns

module regfile_test;

    parameter DWIDTH = 32;
    parameter AWIDTH = 5;

    reg clock, reset;
    reg write_enable;

    reg [AWIDTH-1:0] addr_A;
    reg [AWIDTH-1:0] addr_B;
    reg [AWIDTH-1:0] addr_D;

    reg [DWIDTH-1:0] data_D;

    wire [DWIDTH-1:0] data_A;
    wire [DWIDTH-1:0] data_B;
    
    regfile dut (.rst(reset),
                 .clk(clock),
                 .RegWEn(write_enable),
                 .AddrA(addr_A),
                 .AddrB(addr_B),
                 .AddrD(addr_D),
                 .DataA(data_A),
                 .DataB(data_B),
                 .DataD(data_D)
                 );

    integer i;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
        clock = 1;
        reset = 1;
        #10 reset = 0;
        write_enable = 1;
        addr_A = 0;
        addr_B = 0;
        addr_D = 15;
        data_D = 32'hdead_beaf;
        #10 write_enable = 0;
        for(i=0; i<2**AWIDTH; i++) begin
            #10 addr_A = i;
            addr_B = i;
        end
        #1000 $finish;
    end

    always #5 clock = ~clock;
endmodule