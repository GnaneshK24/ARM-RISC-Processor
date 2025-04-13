module immediate_generator_tb;
    // Testbench signals
    reg [31:0] instruction;
    wire [31:0] immediate;

    // Instantiate the immediate generator
    immediate_generator imm_gen (
        .instruction(instruction),
        .immediate(immediate)
    );

    // Test stimulus
    initial begin
        // Initialize waveform dumping
        $dumpfile("sim/immediate_generator.vcd");
        $dumpvars(0, immediate_generator_tb);

        // Test 1: I-type instruction (ADDI)
        instruction = 32'h00000000;  // ADDI x0, x0, 0
        #10;
        $display("I-type (ADDI): Instruction=%h, Immediate=%h", instruction, immediate);

        // Test 2: I-type instruction with negative immediate
        instruction = 32'hFFF00093;  // ADDI x1, x0, -1
        #10;
        $display("I-type (ADDI negative): Instruction=%h, Immediate=%h", instruction, immediate);

        // Test 3: S-type instruction (SW)
        instruction = 32'h00000000;  // SW x0, 0(x0)
        #10;
        $display("S-type (SW): Instruction=%h, Immediate=%h", instruction, immediate);

        // Test 4: B-type instruction (BEQ)
        instruction = 32'h00000000;  // BEQ x0, x0, 0
        #10;
        $display("B-type (BEQ): Instruction=%h, Immediate=%h", instruction, immediate);

        // Test 5: U-type instruction (LUI)
        instruction = 32'h00000000;  // LUI x0, 0
        #10;
        $display("U-type (LUI): Instruction=%h, Immediate=%h", instruction, immediate);

        // Test 6: J-type instruction (JAL)
        instruction = 32'h00000000;  // JAL x0, 0
        #10;
        $display("J-type (JAL): Instruction=%h, Immediate=%h", instruction, immediate);

        // End simulation
        $display("All tests completed!");
        $finish;
    end

endmodule 