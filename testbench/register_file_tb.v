module register_file_tb;
    // Testbench signals
    reg clk;
    reg reset;
    reg reg_write;
    reg [4:0] rs1_addr;
    reg [4:0] rs2_addr;
    reg [4:0] rd_addr;
    reg [31:0] rd_data;
    wire [31:0] rs1_data;
    wire [31:0] rs2_data;

    // Instantiate the Register File
    register_file reg_file (
        .clk(clk),
        .reset(reset),
        .reg_write(reg_write),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rd_addr(rd_addr),
        .rd_data(rd_data),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Test stimulus
    initial begin
        // Initialize waveform dumping
        $dumpfile("sim/register_file.vcd");
        $dumpvars(0, register_file_tb);

        // Initialize signals
        clk = 0;
        reset = 0;
        reg_write = 0;
        rs1_addr = 0;
        rs2_addr = 0;
        rd_addr = 0;
        rd_data = 0;

        // Test 1: Reset
        reset = 1;
        #10;
        reset = 0;
        #10;
        $display("Reset: rs1_data=%h, rs2_data=%h", rs1_data, rs2_data);

        // Test 2: Write to register
        reg_write = 1;
        rd_addr = 5'b00001;  // x1
        rd_data = 32'h12345678;
        #10;
        $display("Write x1: rd_data=%h", rd_data);

        // Test 3: Read from register
        reg_write = 0;
        rs1_addr = 5'b00001;  // x1
        #10;
        $display("Read x1: rs1_data=%h", rs1_data);

        // Test 4: Write to x0 (should not change)
        reg_write = 1;
        rd_addr = 5'b00000;  // x0
        rd_data = 32'hFFFFFFFF;
        #10;
        $display("Write x0: rd_data=%h", rd_data);

        // Test 5: Read from x0 (should be 0)
        reg_write = 0;
        rs1_addr = 5'b00000;  // x0
        #10;
        $display("Read x0: rs1_data=%h", rs1_data);

        // Test 6: Multiple register operations
        reg_write = 1;
        rd_addr = 5'b00010;  // x2
        rd_data = 32'h87654321;
        #10;
        reg_write = 0;
        rs1_addr = 5'b00001;  // x1
        rs2_addr = 5'b00010;  // x2
        #10;
        $display("Multiple regs: rs1_data=%h, rs2_data=%h", rs1_data, rs2_data);

        // End simulation
        $display("All tests completed!");
        $finish;
    end

endmodule 