module pc_adder_tb;
    // Testbench signals
    reg [31:0] pc;
    reg [31:0] immediate;
    reg [31:0] rs1_data;
    reg [1:0] pc_src;
    wire [31:0] next_pc;

    // Instantiate the PC Adder
    pc_adder pc_add (
        .pc(pc),
        .immediate(immediate),
        .rs1_data(rs1_data),
        .pc_src(pc_src),
        .next_pc(next_pc)
    );

    // Test stimulus
    initial begin
        // Initialize waveform dumping
        $dumpfile("sim/pc_adder.vcd");
        $dumpvars(0, pc_adder_tb);

        // Initialize signals
        pc = 32'h00000000;
        immediate = 32'h00000004;
        rs1_data = 32'h00000010;
        pc_src = 2'b00;

        // Test 1: PC + 4 (normal sequential execution)
        #10;
        $display("PC+4: pc=%h, next_pc=%h", pc, next_pc);

        // Test 2: PC + immediate (branch/jump)
        pc_src = 2'b01;
        #10;
        $display("PC+imm: pc=%h, imm=%h, next_pc=%h", pc, immediate, next_pc);

        // Test 3: rs1 + immediate (JALR)
        pc_src = 2'b10;
        #10;
        $display("rs1+imm: rs1=%h, imm=%h, next_pc=%h", rs1_data, immediate, next_pc);

        // Test 4: PC (stall)
        pc_src = 2'b11;
        #10;
        $display("PC stall: pc=%h, next_pc=%h", pc, next_pc);

        // Test 5: Negative immediate
        pc_src = 2'b01;
        immediate = 32'hFFFFFFFC;  // -4
        #10;
        $display("PC+neg_imm: pc=%h, imm=%h, next_pc=%h", pc, immediate, next_pc);

        // End simulation
        $display("All tests completed!");
        $finish;
    end

endmodule 