module instruction_memory_tb;
    // Testbench signals
    reg [31:0] address;
    wire [31:0] instruction;

    // Instantiate the instruction memory
    instruction_memory instr_mem (
        .address(address),
        .instruction(instruction)
    );

    // Test stimulus
    initial begin
        // Initialize waveform dumping
        $dumpfile("sim/instruction_memory.vcd");
        $dumpvars(0, instruction_memory_tb);

        // Test 1: Read from address 0
        address = 32'h00000000;
        #10;
        $display("Address: %h, Instruction: %h", address, instruction);

        // Test 2: Read from address 4
        address = 32'h00000004;
        #10;
        $display("Address: %h, Instruction: %h", address, instruction);

        // Test 3: Read from address 8
        address = 32'h00000008;
        #10;
        $display("Address: %h, Instruction: %h", address, instruction);

        // Test 4: Read from uninitialized address
        address = 32'h0000000C;
        #10;
        $display("Address: %h, Instruction: %h", address, instruction);

        // End simulation
        $display("All tests completed!");
        $finish;
    end

endmodule 