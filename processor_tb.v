module processor_tb;
    reg clk;
    reg reset;
    reg rx;
    wire tx;
    wire [31:0] result;

    // Instantiate the processor
    processor_top processor (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .tx(tx),
        .result(result)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Monitor register values
    reg [31:0] expected_x1;
    reg [31:0] expected_x4;

    initial begin
        // Initialize waveform dumping
        $dumpfile("sim/processor.vcd");
        $dumpvars(0, processor_tb);

        // Initialize inputs
        rx = 1'b1;
        reset = 1'b1;
        expected_x1 = 32'h1E;  // Expected value for x1 (30 = 15 + 15)
        expected_x4 = 32'h0F;  // Expected value for x4 (15 = 30 - 15)

        // Release reset after 100ns
        #100 reset = 1'b0;

        // Wait for instructions to execute
        #200;

        // Check results
        if (processor.reg_file.registers[1] == expected_x1)
            $display("SUCCESS: x1 = %h (Expected: %h)", processor.reg_file.registers[1], expected_x1);
        else
            $display("ERROR: x1 = %h (Expected: %h)", processor.reg_file.registers[1], expected_x1);

        if (processor.reg_file.registers[4] == expected_x4)
            $display("SUCCESS: x4 = %h (Expected: %h)", processor.reg_file.registers[4], expected_x4);
        else
            $display("ERROR: x4 = %h (Expected: %h)", processor.reg_file.registers[4], expected_x4);

        // Additional debug information
        $display("Debug Info:");
        $display("x2 value: %h", processor.reg_file.registers[2]);
        $display("x3 value: %h", processor.reg_file.registers[3]);
        $display("Current PC: %h", processor.pc);
        $display("Current Instruction: %h", processor.instruction);

        #100 $finish;
    end

endmodule 