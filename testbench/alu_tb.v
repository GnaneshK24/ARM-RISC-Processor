module alu_tb;
    // Testbench signals
    reg [31:0] op_a;
    reg [31:0] op_b;
    reg [3:0] alu_ctrl;
    wire [31:0] result;
    wire zero;
    wire overflow;

    // Instantiate the ALU
    alu alu_inst (
        .op_a(op_a),
        .op_b(op_b),
        .alu_ctrl(alu_ctrl),
        .result(result),
        .zero(zero),
        .overflow(overflow)
    );

    // Test stimulus
    initial begin
        // Initialize waveform dumping
        $dumpfile("sim/alu.vcd");
        $dumpvars(0, alu_tb);

        // Test 1: Addition
        op_a = 32'h00000005;
        op_b = 32'h00000003;
        alu_ctrl = 4'b0000;  // ADD
        #10;
        
        // Test overflow
        op_a = 32'h7FFFFFFF;
        op_b = 32'h00000001;
        #10;

        // Test 2: Subtraction
        op_a = 32'h00000005;
        op_b = 32'h00000003;
        alu_ctrl = 4'b0001;  // SUB
        #10;

        // Test 3: AND
        op_a = 32'hFF00FF00;
        op_b = 32'h0F0F0F0F;
        alu_ctrl = 4'b0010;  // AND
        #10;

        // Test 4: OR
        op_a = 32'hFF00FF00;
        op_b = 32'h0F0F0F0F;
        alu_ctrl = 4'b0011;  // OR
        #10;

        // Test 5: XOR
        op_a = 32'hFF00FF00;
        op_b = 32'h0F0F0F0F;
        alu_ctrl = 4'b0100;  // XOR
        #10;

        // Test 6: SLT (Less than)
        op_a = 32'hFFFFFFFF;  // -1
        op_b = 32'h00000001;  // 1
        alu_ctrl = 4'b0101;  // SLT
        #10;

        // Test 7: Shift left logical
        op_a = 32'h00000001;
        op_b = 32'h00000004;
        alu_ctrl = 4'b0110;  // SLL
        #10;

        // Test 8: Shift right logical
        op_a = 32'h80000000;
        op_b = 32'h00000004;
        alu_ctrl = 4'b0111;  // SRL
        #10;

        // Test 9: Shift right arithmetic
        op_a = 32'h80000000;
        op_b = 32'h00000004;
        alu_ctrl = 4'b1000;  // SRA
        #10;

        // Test 10: Zero flag
        op_a = 32'h00000000;
        op_b = 32'h00000000;
        alu_ctrl = 4'b0000;  // ADD
        #10;

        // End simulation
        $display("All tests completed!");
        $finish;
    end

    // Monitor changes
    always @(*) begin
        #1; // Small delay to let signals settle
        $display("Time=%0t op_a=%0h op_b=%0h alu_ctrl=%0h result=%0h zero=%0b overflow=%0b",
                 $time, op_a, op_b, alu_ctrl, result, zero, overflow);
    end

endmodule 