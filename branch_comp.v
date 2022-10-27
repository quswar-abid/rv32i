module branch_comp #(
    parameter DWIDTH = 64
) (
    DataA, DataB, BrUn, BrEq, BrLt
);

    input [DWIDTH-1:0] DataA;
    input [DWIDTH-1:0] DataB;
    input BrUn;
    output BrEq;
    output reg BrLt;

    assign BrEq = DataA==DataB;

    // assign BrLt = BrUn? (DataA<DataB) : ($signed(A)<$signed(B));

    always @(*) begin
        case(BrUn)
            0: BrLt = $signed(DataA) < $signed(DataB);
            1: BrLt = DataA < DataB;
        endcase
    end
    
endmodule