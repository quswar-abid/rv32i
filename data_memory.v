module data_memory #(
    parameter DWIDTH = 64, AWIDTH = 10
) (
    clk, rst, Addr, DataW, DataR, MemRW, type
);
    // parameter memory_size = 2**(AWIDTH-8);
    parameter memory_size = 2**12;

    input clk, rst;
    input [AWIDTH-1:0] Addr;
    input [DWIDTH-1:0] DataW;
    output reg [DWIDTH-1:0] DataR;
    input MemRW;
    input [2:0] type;
    reg [7:0] memory [memory_size-1 : 0];

    integer i;

    always @(*) begin               //Async. READ
        case(type)                  //0-5 -> lb, lh, lw, ld, lbu, lhu, lwu
            3'd0: begin             //load byte
                DataR[7:0] = memory[Addr];
                for (i=1; i<=DWIDTH/8; i++) begin
                    DataR[(i*8)+:8] = {8{DataR[7]}};
                end
                // DataR[DWIDTH-1:8] = memory[DWIDTH-8+1{DataR[7]}];
            end
            
            3'd1: begin             //load half
                DataR[7:0]  = memory[Addr];
                DataR[15:8] = memory[Addr+1];
                for (i=2; i<=DWIDTH/8; i++) begin
                    DataR[(i*8)+:8] = {8{DataR[15]}};
                end
            end
            
            3'd2: begin             //load word
                DataR[7:0]  = memory[Addr];
                DataR[15:8] = memory[Addr+1];
                DataR[23:16] = memory[Addr+2];
                DataR[31:24] = memory[Addr+3];
                for (i=4; i<=DWIDTH/8; i++) begin
                    DataR[(i*8)+:8] = {8{DataR[31]}};
                end
            end

            3'd3: begin             //load double
                DataR[63:0] = {memory[Addr+7], memory[Addr+6], memory[Addr+5], memory[Addr+4], memory[Addr+3], memory[Addr+2], memory[Addr+1], memory[Addr+0]};
                // DataR[64:0] = { memory[63:56], memory[55:48], memory[47:40], memory[39:32], memory[31:24], memory[23:16], memory[15:08], memory[07:00] };
            end

            3'd4: begin             //load byte unsigned
                DataR[7:0] = memory[Addr];
                for (i=1; i<=DWIDTH/8; i++) begin
                    DataR[(i*8)+:8] = {8{1'b0}};
                end
            end

            3'd5: begin             //load half unsigned
                DataR[7:0]  = memory[Addr];
                DataR[15:8] = memory[Addr+1];
                for (i=2; i<=DWIDTH/8; i++) begin
                    DataR[(i*8)+:8] = {8{1'b0}};
                end
            end
            3'd6: begin             //load word unsigned
                DataR[7:0]  = memory[Addr];
                DataR[15:8] = memory[Addr+1];
                DataR[23:16] = memory[Addr+2];
                DataR[31:24] = memory[Addr+3];
                for (i=4; i<=DWIDTH/8; i++) begin
                    DataR[(i*8)+:8] = {8{1'b0}};
                end
            end
        endcase
    end

    always @(posedge clk or rst) begin     //Sync. WRITE
        if (rst) begin
            for (i=0; i<2**AWIDTH; i++) begin
                memory[i] = 0;
            end
        end else if(MemRW) begin
            case(type)
                0: begin            //byte
                    memory[Addr] = DataW[7:0];
                    for (i=1; i<DWIDTH/8; i++) begin
                        memory[Addr+i] = {8{DataW[7]}};
                        $display("byte-----> %0b", {{DataW[7]}});
                    end
                end
                1: begin            //half
                    {memory[Addr+1], memory[Addr+0]} = DataW[15:0];
                    for (i=2; i<DWIDTH/8; i++) begin
                        memory[Addr+i] = {8{DataR[15]}};
                        $display("half-----> %0b", {{DataW[15]}});
                    end
                end
                2:begin             //word
                    {memory[Addr+3], memory[Addr+2], memory[Addr+1], memory[Addr+0]} = DataW[31:0];
                    for (i=4; i<DWIDTH/8; i++) begin
                        memory[Addr+i] = {8{DataR[31]}};
                    end
                end
                3: begin            //double
                    {memory[Addr+7], memory[Addr+6], memory[Addr+5], memory[Addr+4], memory[Addr+3], memory[Addr+2], memory[Addr+1], memory[Addr+0]} = DataW;
                    
                end
            endcase
        end
    end
    
endmodule

