module data_memory_tb;
    // Testbench signals
    reg clk;
    reg [31:0] address;
    reg [31:0] write_data;
    reg mem_write;
    reg mem_read;
    wire [31:0] read_data;

    // Instantiate the data memory
    data_memory data_mem (
        .clk(clk),
        .address(address),
        .write_data(write_data),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .read_data(read_data)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Test stimulus
    initial begin
        // Initialize waveform dumping
        $dumpfile("sim/data_memory.vcd");
        $dumpvars(0, data_memory_tb);

        // Initialize signals
        clk = 0;
        address = 0;
        write_data = 0;
        mem_write = 0;
        mem_read = 0;

        // Test 1: Write operation
        #10;
        address = 32'h00000004;  // Address 4
        write_data = 32'h12345678;
        mem_write = 1;
        #10;
        mem_write = 0;

        // Test 2: Read operation
        #10;
        mem_read = 1;
        #10;
        mem_read = 0;

        // Test 3: Write and read at different address
        #10;
        address = 32'h00000008;  // Address 8
        write_data = 32'h87654321;
        mem_write = 1;
        #10;
        mem_write = 0;
        #10;
        mem_read = 1;
        #10;
        mem_read = 0;

        // Test 4: Read from uninitialized address
        #10;
        address = 32'h0000000C;  // Address 12
        mem_read = 1;
        #10;
        mem_read = 0;

        // End simulation
        $display("All tests completed!");
        $finish;
    end

    // Monitor changes
    always @(*) begin
        #1; // Small delay to let signals settle
        $display("Time=%0t address=%0h write_data=%0h mem_write=%0b mem_read=%0b read_data=%0h",
                 $time, address, write_data, mem_write, mem_read, read_data);
    end

endmodule 