module program_counter (
    input wire clk,          // Clock input
    input wire rst_n,        // Active low reset
    input wire pc_write,     // Enable signal
    input wire [31:0] next_pc, // Next program counter value
    output reg [31:0] pc_out   // Current program counter value
);

    // Sequential logic for program counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc_out <= 32'h0;  // Reset to address 0
        end else if (pc_write) begin
            pc_out <= next_pc;
        end
    end

endmodule 