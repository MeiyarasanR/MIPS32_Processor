module MIPS32_Pipelined_TB;
    reg clk1, clk2;
    integer k;
    
    MIPS32_Piplined mips(.clk1(clk1), .clk2(clk2));
    
    // --------------- CLOCK GENERATION -----------------
    initial begin
        clk1 = 0; 
        clk2 = 0;
        repeat(30) begin
            #5  clk1 = 1;  #5 clk1 = 0;
            #5  clk2 = 1;  #5 clk2 = 0;
        end
    end
    
    // --------------- INITIAL SETUP ---------------
    initial begin
        $display("====================================");
        $display("=== MIPS32 Pipeline Simulation ===");
        $display("====================================\n");
        
        // Initialize ALL registers
        for (k = 0; k <= 31; k = k + 1)
            mips.Reg[k] = k;
        
        // *** Initialize ALL memory locations to zero ***
        for (k = 0; k <= 1023; k = k + 1)
            mips.Mem[k] = 32'h00000000;
        
        // *** Initialize ALL pipeline registers ***
        mips.IF_ID_IR = 32'h00000000;
        mips.IF_ID_NPC = 32'h00000000;
        mips.ID_EX_IR = 32'h00000000;
        mips.ID_EX_NPC = 32'h00000000;
        mips.ID_EX_A = 32'h00000000;
        mips.ID_EX_B = 32'h00000000;
        mips.ID_EX_Imm = 32'h00000000;
        mips.ID_EX_type = 3'b000;
        mips.EX_MEM_IR = 32'h00000000;
        mips.EX_MEM_ALUOut = 32'h00000000;
        mips.EX_MEM_B = 32'h00000000;
        mips.EX_MEM_type = 3'b000;
        mips.EX_MEM_cond = 1'b0;
        mips.MEM_WB_IR = 32'h00000000;
        mips.MEM_WB_ALUOut = 32'h00000000;
        mips.MEM_WB_LMD = 32'h00000000;
        mips.MEM_WB_type = 3'b000;
        
        // Load program
        mips.Mem[0] = 32'h2801000a;   // ADDI R1, R0, 10
        mips.Mem[1] = 32'h28020014;   // ADDI R2, R0, 20
        mips.Mem[2] = 32'h28030019;   // ADDI R3, R0, 25
        mips.Mem[3] = 32'h0ce77800;   // OR R7, R7, R7 (NOP)
        mips.Mem[4] = 32'h0ce77800;   // OR R7, R7, R7 (NOP)
        mips.Mem[5] = 32'h00222000;   // ADD R4, R1, R2
        mips.Mem[6] = 32'h0ce77800;   // OR R7, R7, R7 (NOP)
        mips.Mem[7] = 32'h0ce77800;   // OR R7, R7, R7 (NOP)
        mips.Mem[8] = 32'h00832800;   // ADD R5, R4, R3
        mips.Mem[9] = 32'hfc000000;   // HLT
        
        // Initialize control
        mips.HALTED = 1'b0;
        mips.PC = 32'h00000000;
        mips.TAKEN_BRANCH = 1'b0;
        
        $display("Program loaded. Starting execution...\n");
        
        // Wait for completion
        wait(mips.HALTED == 1);
        #50;
        
        $display("\n====================================");
        $display("=== Final Register Values ===");
        $display("====================================");
        for (k = 0; k < 6; k = k + 1)
            $display("R%1d = %2d", k, mips.Reg[k]);
        $display("====================================");
        
        // Verify
        if (mips.Reg[1] == 10 && mips.Reg[2] == 20 && 
            mips.Reg[3] == 25 && mips.Reg[4] == 30 && 
            mips.Reg[5] == 55) begin
            $display("\n*** TEST PASSED ***\n");
        end else begin
            $display("\n*** TEST FAILED ***\n");
        end
        
        #50 $finish;
    end
    
    // Monitor
    initial begin
        $display("Time\t\tPC\tIF_ID_IR\tID_EX_type\tRegisters");
        $display("================================================================");
    end
    
    always @(posedge clk1) begin
        $display("t=%0t (clk1) | PC=%0d | IF_ID_IR=%h | R1=%0d R2=%0d R3=%0d R4=%0d R5=%0d", 
                 $time, mips.PC, mips.IF_ID_IR,
                 mips.Reg[1], mips.Reg[2], mips.Reg[3], 
                 mips.Reg[4], mips.Reg[5]);
    end
    
endmodule