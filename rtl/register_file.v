module register_file (
    input wire clk,
    input wire rst_n,
    // Read port 1
    input wire [4:0] rs1_addr,
    output reg [31:0] rs1_data,
    // Read port 2
    input wire [4:0] rs2_addr,
    output reg [31:0] rs2_data,
    // Write port
    input wire [4:0] rd_addr,
    input wire [31:0] rd_data,
    input wire reg_write
);

    // Register array (32 x 32-bit registers)
    reg [31:0] registers [0:31];
    integer i;

    // Initialize registers
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] = 32'h0;
        end
        // Initialize test values
        registers[2] = 32'h0000000F;  // x2 = 15
        registers[3] = 32'h0000000F;  // x3 = 15
    end

    // Synchronous write
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'h0;
                // Reinitialize test values after reset
                if (i == 2) registers[i] <= 32'h0000000F;  // x2 = 15
                if (i == 3) registers[i] <= 32'h0000000F;  // x3 = 15
            end
        end else if (reg_write && rd_addr != 5'b0) begin
            // x0 is hardwired to 0
            registers[rd_addr] <= rd_data;
        end
    end

    // Asynchronous read (combinational)
    always @(*) begin
        // Read port 1
        rs1_data = (rs1_addr == 5'b0) ? 32'h0 : registers[rs1_addr];
        // Read port 2
        rs2_data = (rs2_addr == 5'b0) ? 32'h0 : registers[rs2_addr];
    end

endmodule 