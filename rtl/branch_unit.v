module branch_unit (
    input wire [31:0] rs1_data,        // First source register data
    input wire [31:0] rs2_data,        // Second source register data
    input wire [31:0] pc,              // Current program counter
    input wire [31:0] immediate,       // Branch offset from immediate generator
    input wire [2:0] func3,           // Function code for branch type
    input wire branch,                // Branch control signal
    output reg branch_taken,          // Whether branch is taken
    output reg [31:0] branch_target   // Calculated branch target
);

    // Internal signals
    wire equal = (rs1_data == rs2_data);
    wire less_than = ($signed(rs1_data) < $signed(rs2_data));
    wire less_than_u = (rs1_data < rs2_data);

    // Calculate branch target (PC + immediate)
    always @(*) begin
        branch_target = pc + immediate;
    end

    // Determine if branch is taken based on func3 and operands
    always @(*) begin
        if (branch) begin
            case (func3)
                3'b000: branch_taken = equal;          // BEQ
                3'b001: branch_taken = ~equal;         // BNE
                3'b100: branch_taken = less_than;      // BLT
                3'b101: branch_taken = ~less_than;     // BGE
                3'b110: branch_taken = less_than_u;    // BLTU
                3'b111: branch_taken = ~less_than_u;   // BGEU
                default: branch_taken = 1'b0;          // Invalid func3
            endcase
        end else begin
            branch_taken = 1'b0;
        end
    end

endmodule 