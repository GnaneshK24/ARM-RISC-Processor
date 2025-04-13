module branch_unit_tb;
    // Testbench signals
    reg [31:0] rs1_data;
    reg [31:0] rs2_data;
    reg [31:0] pc;
    reg [31:0] immediate;
    reg [2:0] func3;
    reg branch;
    wire branch_taken;
    wire [31:0] branch_target;

    // Instantiate the branch unit
    branch_unit branch_u (
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .pc(pc),
        .immediate(immediate),
        .func3(func3),
        .branch(branch),
        .branch_taken(branch_taken),
        .branch_target(branch_target)
    );

    // Test stimulus
    initial begin
        // Initialize waveform dumping
        $dumpfile("sim/branch_unit.vcd");
        $dumpvars(0, branch_unit_tb);

        // Initialize signals
        pc = 32'h00000000;
        immediate = 32'h00000004;  // +4 bytes
        branch = 1'b1;

        // Test 1: BEQ (equal)
        rs1_data = 32'h00000001;
        rs2_data = 32'h00000001;
        func3 = 3'b000;
        #10;
        $display("BEQ: rs1=%h, rs2=%h, taken=%b, target=%h", 
                 rs1_data, rs2_data, branch_taken, branch_target);

        // Test 2: BNE (not equal)
        rs1_data = 32'h00000001;
        rs2_data = 32'h00000002;
        func3 = 3'b001;
        #10;
        $display("BNE: rs1=%h, rs2=%h, taken=%b, target=%h", 
                 rs1_data, rs2_data, branch_taken, branch_target);

        // Test 3: BLT (less than, signed)
        rs1_data = 32'hFFFFFFFF;  // -1
        rs2_data = 32'h00000001;  // 1
        func3 = 3'b100;
        #10;
        $display("BLT: rs1=%h, rs2=%h, taken=%b, target=%h", 
                 rs1_data, rs2_data, branch_taken, branch_target);

        // Test 4: BGE (greater or equal, signed)
        rs1_data = 32'h00000001;  // 1
        rs2_data = 32'hFFFFFFFF;  // -1
        func3 = 3'b101;
        #10;
        $display("BGE: rs1=%h, rs2=%h, taken=%b, target=%h", 
                 rs1_data, rs2_data, branch_taken, branch_target);

        // Test 5: BLTU (less than, unsigned)
        rs1_data = 32'h00000001;
        rs2_data = 32'h00000002;
        func3 = 3'b110;
        #10;
        $display("BLTU: rs1=%h, rs2=%h, taken=%b, target=%h", 
                 rs1_data, rs2_data, branch_taken, branch_target);

        // Test 6: BGEU (greater or equal, unsigned)
        rs1_data = 32'hFFFFFFFF;
        rs2_data = 32'h00000001;
        func3 = 3'b111;
        #10;
        $display("BGEU: rs1=%h, rs2=%h, taken=%b, target=%h", 
                 rs1_data, rs2_data, branch_taken, branch_target);

        // Test 7: Branch disabled
        branch = 1'b0;
        #10;
        $display("Branch disabled: taken=%b", branch_taken);

        // End simulation
        $display("All tests completed!");
        $finish;
    end

endmodule 