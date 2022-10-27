`timescale 1ns/1ns

module core_test;

    reg clock, start, reset;

    wire [31:0] regfile_29;
    wire [31:0] regfile_30;
    wire [31:0] regfile_31;
    assign regfile_29 = module_core.module_regfile.memory[29];
    assign regfile_30 = module_core.module_regfile.memory[30];
    assign regfile_31 = module_core.module_regfile.memory[31];

    core module_core (.*);

    integer num_inst = 0;

    parameter HALF_CLOCK = 5;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;

        reset = 1;
        clock = 1;
        start = 0;
        #10 reset = 0;



        /*
            Move 101 to memory and read it back, and compare the read value with written one.
        */
        // writeToMemory(32'h06500f93, 32'd0);
        // writeToMemory(32'h06500593, 32'd4);
        // writeToMemory(32'h06400613, 32'd8);
        // writeToMemory(32'h00b62023, 32'd12);
        // writeToMemory(32'h00062f03, 32'd16);
        // writeToMemory(32'h0ff00e93, 32'd20);

        // writeToMemory(32'h007302b3, 32'd0);
        // writeToMemory(32'h407302b3, 32'd4);

        writeToMemory(32'h01000f93, 32'd0);
        writeToMemory(32'hffe00513, 32'd4);
        writeToMemory(32'h00300593, 32'd8);
        writeToMemory(32'h01000f13, 32'd12);
        writeToMemory(32'h00b57463, 32'd16);
        writeToMemory(32'h00900f13, 32'd20);
        writeToMemory(32'h0ff00e93, 32'd24);

        // writeToMemory(32'h00500113, 32'd0);
        // writeToMemory(32'h00C00193, 32'd4);
        // writeToMemory(32'hFF718393, 32'd8);
        // writeToMemory(32'h0023E233, 32'd12);
        // writeToMemory(32'h0041F2B3, 32'd16);
        // writeToMemory(32'h004282B3, 32'd20);
        // writeToMemory(32'h02728863, 32'd24);
        // writeToMemory(32'h0041A233, 32'd28);
        // writeToMemory(32'h00020463, 32'd32);
        // writeToMemory(32'h00000293, 32'd36);
        // writeToMemory(32'h0023A233, 32'd40);
        // writeToMemory(32'h005203B3, 32'd44);
        // writeToMemory(32'h402383B3, 32'd48);
        // writeToMemory(32'h0471AA23, 32'd52);
        // writeToMemory(32'h06002103, 32'd56);
        // writeToMemory(32'h005104B3, 32'd60);
        // writeToMemory(32'h008001EF, 32'd64);
        // writeToMemory(32'h00100113, 32'd68);
        // writeToMemory(32'h00910133, 32'd72);
        // writeToMemory(32'h0221A023, 32'd76);
        // writeToMemory(32'h0201cf83, 32'd80);
        // writeToMemory(32'h00210063, 32'd84);

        // module_core.module_regfile.memory[31] = 32'hdead_beaf;

        @(regfile_29==32'd255);
        
        // #1000;
        
        $display("--------------------------------------------------------");
        $display("reg# 29 : %02h",regfile_29);
        $display("reg# 30 : %02h",regfile_30);
        $display("reg# 31 : %02h",regfile_31);
        compareWithMemory(regfile_30,regfile_31); //compareWithMemory(final result,golden value)

        $finish;

    end

    always #HALF_CLOCK clock = ~clock;

    task writeToMemory;
        input [31:0] instruction;
        input [31:0] address;
        begin
            module_core.module_instruction_memory.memory[address+4]   = instruction[7:0];
            module_core.module_instruction_memory.memory[address+1+4] = instruction[15:8];
            module_core.module_instruction_memory.memory[address+2+4] = instruction[23:16];
            module_core.module_instruction_memory.memory[address+3+4] = instruction[31:24];
            $display("-------------------------------------------------------------");
            $display("writing:\t%02h%02h%02h%02h", instruction[31:24], instruction[23:16], instruction[15:8], instruction[7:0]);
            $display("written:\t%02h%02h%02h%02h", module_core.module_instruction_memory.memory[address+3+4],
                                         module_core.module_instruction_memory.memory[address+2+4],
                                         module_core.module_instruction_memory.memory[address+1+4],
                                         module_core.module_instruction_memory.memory[address+4]);
            num_inst++;
            $display("Added instruction  #  %0d",num_inst);
        end
    endtask

    task compareWithMemory;
        input [31:0] input_value;
        input [31:0] golden_value;
        begin
            if(input_value == golden_value) begin
                $display("TEST PASSED :) \n %0h == %0h", input_value, golden_value);
            end else begin
                $display("TEST FAILED :( \n %0h != %0h", input_value, golden_value);
            end
        end
    endtask


endmodule