module control_unit_tb;
    // Testbench signals
    reg [6:0] opcode;
    reg [2:0] funct3;
    reg [6:0] funct7;
    wire reg_write;
    wire alu_src;
    wire mem_write;
    wire mem_read;
    wire mem_to_reg;
    wire [1:0] alu_op;
    wire branch;
    wire jump;

    // Instantiate the control unit
    control_unit ctrl_inst (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .mem_to_reg(mem_to_reg),
        .alu_op(alu_op),
        .branch(branch),
        .jump(jump)
    );

    // Test stimulus
    initial begin
        // Initialize waveform dumping
        $dumpfile("sim/control_unit.vcd");
        $dumpvars(0, control_unit_tb);

        // Test 1: R-type instruction (add)
        opcode = 7'b0110011;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #10;

        // Test 2: I-type instruction (addi)
        opcode = 7'b0010011;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #10;

        // Test 3: Load instruction (lw)
        opcode = 7'b0000011;
        funct3 = 3'b010;
        funct7 = 7'b0000000;
        #10;

        // Test 4: Store instruction (sw)
        opcode = 7'b0100011;
        funct3 = 3'b010;
        funct7 = 7'b0000000;
        #10;

        // Test 5: Branch instruction (beq)
        opcode = 7'b1100011;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #10;

        // Test 6: Jump and link (jal)
        opcode = 7'b1101111;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #10;

        // Test 7: Jump and link register (jalr)
        opcode = 7'b1100111;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #10;

        // Test 8: Invalid opcode
        opcode = 7'b1111111;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #10;

        // End simulation
        $display("All tests completed!");
        $finish;
    end

    // Monitor changes
    always @(*) begin
        #1; // Small delay to let signals settle
        $display("Time=%0t opcode=%0b funct3=%0b funct7=%0b reg_write=%0b alu_src=%0b mem_write=%0b mem_read=%0b mem_to_reg=%0b alu_op=%0b branch=%0b jump=%0b",
                 $time, opcode, funct3, funct7, reg_write, alu_src, mem_write, mem_read, mem_to_reg, alu_op, branch, jump);
    end

endmodule 