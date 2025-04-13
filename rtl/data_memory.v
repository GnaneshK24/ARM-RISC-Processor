module data_memory (
    input wire clk,
    input wire [31:0] address,
    input wire [31:0] write_data,
    input wire mem_write,
    input wire mem_read,
    output reg [31:0] read_data
);

    // Memory array (4KB = 1024 words)
    reg [31:0] memory [0:1023];

    // Initialize memory with zeros
    integer i;
    initial begin
        for (i = 0; i < 1024; i = i + 1) begin
            memory[i] = 32'b0;
        end
    end

    // Memory operations
    always @(posedge clk) begin
        if (mem_write) begin
            memory[address[11:2]] <= write_data;  // Word-aligned addressing
        end
    end

    // Read operation (combinational)
    always @(*) begin
        if (mem_read) begin
            read_data = memory[address[11:2]];  // Word-aligned addressing
        end else begin
            read_data = 32'b0;
        end
    end

endmodule 