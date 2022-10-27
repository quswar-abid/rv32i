module regfile (rst, clk, RegWEn, AddrA, AddrB, AddrD, DataA, DataB, DataD);

    parameter DWIDTH = 32;
    parameter AWIDTH = 5;

    input clk, rst;
    input RegWEn;

    input [AWIDTH-1:0] AddrA;
    input [AWIDTH-1:0] AddrB;
    input [AWIDTH-1:0] AddrD;

    input [DWIDTH-1:0] DataD;

    output [DWIDTH-1:0] DataA;
    output [DWIDTH-1:0] DataB;
    
    reg [DWIDTH-1:0] memory [(2**AWIDTH)-1:0];

    integer i;

    always @(posedge clk or rst) begin
        if (rst) begin
            for (i=0; i<2**AWIDTH; i++) begin
                memory[i] = 0;
            end
        end else begin
            if (RegWEn & (AddrD>0)) begin
                memory[AddrD] = DataD;
            end
        end
    end
    

    assign DataA = memory[AddrA];
    assign DataB = memory[AddrB];

    // always @(*) begin //regfile.v:38: warning: @* found no sensitivities so it will never trigger.
    //     memory[0] <= 0;
    // end

endmodule