module alu_control_tb;
    // Testbench signals
    reg [1:0] alu_op;
    reg [2:0] funct3;
    reg [6:0] funct7;
    wire [3:0] alu_ctrl;

    // Instantiate the ALU control unit
    alu_control alu_ctrl_inst (
        .alu_op(alu_op),
        .funct3(funct3),
        .funct7(funct7),
        .alu_ctrl(alu_ctrl)
    );

    // Test stimulus
    initial begin
        // Initialize waveform dumping
        $dumpfile("sim/alu_control.vcd");
        $dumpvars(0, alu_control_tb);

        // Test 1: R-type instructions
        alu_op = 2'b10;  // R-type
        // add
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #10;
        // sub
        funct3 = 3'b000;
        funct7 = 7'b0100000;
        #10;
        // and
        funct3 = 3'b111;
        funct7 = 7'b0000000;
        #10;
        // or
        funct3 = 3'b110;
        funct7 = 7'b0000000;
        #10;
        // xor
        funct3 = 3'b100;
        funct7 = 7'b0000000;
        #10;
        // slt
        funct3 = 3'b010;
        funct7 = 7'b0000000;
        #10;
        // sll
        funct3 = 3'b001;
        funct7 = 7'b0000000;
        #10;
        // srl
        funct3 = 3'b101;
        funct7 = 7'b0000000;
        #10;
        // sra
        funct3 = 3'b101;
        funct7 = 7'b0100000;
        #10;

        // Test 2: I-type instructions
        alu_op = 2'b11;  // I-type
        // addi
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #10;
        // andi
        funct3 = 3'b111;
        funct7 = 7'b0000000;
        #10;
        // ori
        funct3 = 3'b110;
        funct7 = 7'b0000000;
        #10;
        // xori
        funct3 = 3'b100;
        funct7 = 7'b0000000;
        #10;
        // slti
        funct3 = 3'b010;
        funct7 = 7'b0000000;
        #10;
        // slli
        funct3 = 3'b001;
        funct7 = 7'b0000000;
        #10;
        // srli
        funct3 = 3'b101;
        funct7 = 7'b0000000;
        #10;
        // srai
        funct3 = 3'b101;
        funct7 = 7'b0100000;
        #10;

        // Test 3: Branch instructions
        alu_op = 2'b01;  // Branch
        // beq
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #10;
        // bne
        funct3 = 3'b001;
        funct7 = 7'b0000000;
        #10;
        // blt
        funct3 = 3'b100;
        funct7 = 7'b0000000;
        #10;
        // bge
        funct3 = 3'b101;
        funct7 = 7'b0000000;
        #10;
        // bltu
        funct3 = 3'b110;
        funct7 = 7'b0000000;
        #10;
        // bgeu
        funct3 = 3'b111;
        funct7 = 7'b0000000;
        #10;

        // Test 4: Other operations
        alu_op = 2'b00;  // Other
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
        $display("Time=%0t alu_op=%0b funct3=%0b funct7=%0b alu_ctrl=%0b",
                 $time, alu_op, funct3, funct7, alu_ctrl);
    end

endmodule 