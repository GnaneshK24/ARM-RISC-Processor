module pc_adder (
    input wire [31:0] pc,              // Current program counter
    input wire [31:0] immediate,       // Immediate value for jumps/branches
    input wire [31:0] rs1_data,       // Register data for JALR
    input wire [1:0] pc_src,          // PC source selection
    output reg [31:0] next_pc         // Next program counter
);

    // PC source selection encoding
    localparam PC_PLUS_4 = 2'b00;     // PC + 4
    localparam PC_PLUS_IMM = 2'b01;   // PC + immediate (for branches/jumps)
    localparam RS1_PLUS_IMM = 2'b10;  // rs1 + immediate (for JALR)
    localparam PC_PLUS_0 = 2'b11;     // PC (for stalls)

    // Calculate next PC based on pc_src
    always @(*) begin
        case (pc_src)
            PC_PLUS_4: next_pc = pc + 32'h4;
            PC_PLUS_IMM: next_pc = pc + immediate;
            RS1_PLUS_IMM: next_pc = rs1_data + immediate;
            PC_PLUS_0: next_pc = pc;
            default: next_pc = pc + 32'h4;
        endcase
    end

endmodule 