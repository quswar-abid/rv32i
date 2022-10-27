`timescale 1ns/1ns

module pc_test;
    reg [31:0] data_in; 
    reg clk, rst;
    wire [31:0] data_out;


    pc #(.DWIDTH(32)) dut (.data_in(data_in),
                           .clk(clk),
                           .rst(rst),
                           .data_out(data_out)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
        clk = 1;
        rst = 1;
        #10 rst = 0;
        #10 data_in <= 0;
        #10 data_in <= 4;
        #10 data_in <= 5;
        #10 data_in <= 6;
        rst = 1;
        #10 rst = 0;

        #10 data_in <= 8;
        #10 data_in <= 7;
        #10 data_in <= 6;
        #10 data_in <= 5;
        // #10 data_in++;
        // #10 data_in++;
        // #10 data_in++;
        // #10 data_in++;
        // #10 data_in++;
        // rst = 1;
        // #10 rst = 0; data_in = 0;
        // #10 data_in++;
        // #10 data_in++;
        // #10 data_in++;
        // #10 data_in++;
        // #10 data_in++;
        // #10 data_in++;
        // rst = 1;
        // #10 rst = 0; data_in = 0;
        // #10 data_in++;
        // #10 data_in++;
        // #10 data_in++;
        // #10 data_in++;
        // #10 data_in++;
        // #10 data_in++;
        // rst = 1;
        // #10 rst = 0; data_in = 0;
        // #10 data_in++;
        // #10 data_in++;
        // #10 data_in++;
        // #10 data_in++;
        // #10 data_in++;
        // #10 data_in++;
        #1000 $finish;
    end

    always #5 clk = ~clk;

    // always @(posedge clk) begin
    //     data_in++;
    // end



endmodule