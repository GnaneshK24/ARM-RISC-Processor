module program_counter_tb;
    // Testbench signals
    reg clk;
    reg rst_n;
    reg pc_write;
    reg [31:0] next_pc;
    wire [31:0] pc_out;

    // Instantiate the program counter
    program_counter pc_inst (
        .clk(clk),
        .rst_n(rst_n),
        .pc_write(pc_write),
        .next_pc(next_pc),
        .pc_out(pc_out)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;  // 100MHz clock
    end

    // Test stimulus
    initial begin
        // Initialize waveform dumping
        $dumpfile("program_counter.vcd");
        $dumpvars(0, program_counter_tb);

        // Initialize signals
        clk = 0;
        rst_n = 1;
        pc_write = 0;
        next_pc = 32'h0;

        // Test 1: Reset
        #10 rst_n = 0;
        #10 rst_n = 1;

        // Test 2: Normal increment
        #10;
        pc_write = 1;
        next_pc = 32'h4;
        #10;
        next_pc = 32'h8;
        #10;
        next_pc = 32'hC;

        // Test 3: Jump
        #10;
        next_pc = 32'h1000;
        #10;

        // Test 4: Disable writes
        pc_write = 0;
        next_pc = 32'h1004;
        #20;

        // Test 5: Re-enable writes
        pc_write = 1;
        #10;

        // End simulation
        #10;
        $display("All tests completed!");
        $finish;
    end

    // Monitor changes
    always @(posedge clk) begin
        $display("Time=%0t rst_n=%0b pc_write=%0b next_pc=%0h pc_out=%0h",
                 $time, rst_n, pc_write, next_pc, pc_out);
    end

endmodule 