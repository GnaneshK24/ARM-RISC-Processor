module instruction_decoder_tb;
    // Testbench signals
    reg [31:0] instruction;
    wire [6:0] opcode;
    wire [4:0] rd;
    wire [2:0] func3;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [6:0] func7;

    // Instantiate the Instruction Decoder
    instruction_decoder decoder (
        .instruction(instruction),
        .opcode(opcode),
        .rd(rd),
        .func3(func3),
        .rs1(rs1),
        .rs2(rs2),
        .func7(func7)
    );

    // Test stimulus
    initial begin
        // Initialize waveform dumping
        $dumpfile("sim/instruction_decoder.vcd");
        $dumpvars(0, instruction_decoder_tb);

        // Test 1: R-type instruction (ADD)
        instruction = 32'h00C585B3;  // ADD x11, x11, x12
        #10;
        $display("ADD: opcode=%b, rd=%d, func3=%b, rs1=%d, rs2=%d, func7=%b",
                 opcode, rd, func3, rs1, rs2, func7);

        // Test 2: I-type instruction (ADDI)
        instruction = 32'h00108093;  // ADDI x1, x1, 1
        #10;
        $display("ADDI: opcode=%b, rd=%d, func3=%b, rs1=%d, rs2=%d, func7=%b",
                 opcode, rd, func3, rs1, rs2, func7);

        // Test 3: S-type instruction (SW)
        instruction = 32'h00B12223;  // SW x11, 4(x2)
        #10;
        $display("SW: opcode=%b, rd=%d, func3=%b, rs1=%d, rs2=%d, func7=%b",
                 opcode, rd, func3, rs1, rs2, func7);

        // Test 4: B-type instruction (BEQ)
        instruction = 32'h00B50663;  // BEQ x10, x11, 12
        #10;
        $display("BEQ: opcode=%b, rd=%d, func3=%b, rs1=%d, rs2=%d, func7=%b",
                 opcode, rd, func3, rs1, rs2, func7);

        // Test 5: U-type instruction (LUI)
        instruction = 32'h0000B537;  // LUI x10, 11
        #10;
        $display("LUI: opcode=%b, rd=%d, func3=%b, rs1=%d, rs2=%d, func7=%b",
                 opcode, rd, func3, rs1, rs2, func7);

        // Test 6: J-type instruction (JAL)
        instruction = 32'h004000EF;  // JAL x1, 4
        #10;
        $display("JAL: opcode=%b, rd=%d, func3=%b, rs1=%d, rs2=%d, func7=%b",
                 opcode, rd, func3, rs1, rs2, func7);

        // End simulation
        $display("All tests completed!");
        $finish;
    end

endmodule 