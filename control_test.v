/*
    Paste the following code in RIPES and get the hex:
    add x5, x2, x0
    sub x5, x2, x0
    sll x5, x2, x0
    slt x5, x2, x0
    sltu x5, x2, x0
    xor x5, x2, x0
    srl x5, x2, x0
    sra x5, x2, x0
    or x5, x2, x0
    and x5, x2, x0
    addw x5, x2, x0
    subw x5, x2, x0
    sllw x5, x2, x0
    srlw x5, x2, x0
    sraw x5, x2, x0
*/

module control_test_R;

    reg [31:0] inst;
    wire [3:0] alu_sel;
    wire PCSel, RegWEn, BrUn;
    wire [2:0] ImmSel;
    reg BrEq, BrLT;
    wire BSel, ASel, MemRW;
    wire [1:0] WBSel;
    wire [2:0] TypeSel;

    control #(.DWIDTH(32)) dut (.instruction(inst),
                                .PCSel(PCSel),
                                .ImmSel(ImmSel),
                                .RegWEn(RegWEn),
                                .BrUn(BrUn),
                                .BrEq(BrEq),
                                .BrLT(BrLT),
                                .BSel(BSel),
                                .ASel(ASel),
                                .ALUSel(alu_sel),
                                .MemRW(MemRW),
                                .WBSel(WBSel),
                                .TypeSel(TypeSel)
                                );


    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;

        #5 inst = 32'h000102b3;
        #5 inst = 32'h400102b3;
        #5 inst = 32'h000112b3;
        #5 inst = 32'h000122b3;
        #5 inst = 32'h000132b3;
        #5 inst = 32'h000142b3;
        #5 inst = 32'h000152b3;
        #5 inst = 32'h400152b3;
        #5 inst = 32'h000162b3;
        #5 inst = 32'h000172b3;


        #5 inst = 32'h00500113;
        #5 inst = 32'h00C00193;
        #5 inst = 32'hFF718393;
        #5 inst = 32'h0023E233;
        #5 inst = 32'h0041F2B3;
        #5 inst = 32'h004282B3;
        #5 inst = 32'h02728863;
        #5 inst = 32'h0041A233;
        #5 inst = 32'h00020463;
        #5 inst = 32'h00000293;
        #5 inst = 32'h0023A233;
        #5 inst = 32'h005203B3;
        #5 inst = 32'h402383B3;
        #5 inst = 32'h0471AA23;
        #5 inst = 32'h06002103;
        #5 inst = 32'h005104B3;
        #5 inst = 32'h008001EF;
        #5 inst = 32'h00100113;
        #5 inst = 32'h00910133;
        #5 inst = 32'h0221A023;
        #5 inst = 32'h00210063;
        #5 inst = 32'h00000000;

        // #5 inst = 32'h;
        // #5 inst = 32'h;
        // #5 inst = 32'h;



        $finish;

    end
endmodule