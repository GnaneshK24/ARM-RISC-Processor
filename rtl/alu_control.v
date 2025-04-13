module alu_control (
    input wire [1:0] alu_op,      // ALU operation type from main control
    input wire [2:0] funct3,      // Function field 3
    input wire [6:0] funct7,      // Function field 7
    output reg [3:0] alu_ctrl     // ALU control signal
);

    // ALU operation types from main control
    localparam ALU_OP_R_TYPE = 2'b10;   // R-type operations
    localparam ALU_OP_I_TYPE = 2'b11;   // I-type operations
    localparam ALU_OP_BRANCH = 2'b01;   // Branch operations
    localparam ALU_OP_OTHER  = 2'b00;   // Other operations

    // ALU control codes
    localparam ALU_ADD  = 4'b0000;
    localparam ALU_SUB  = 4'b0001;
    localparam ALU_AND  = 4'b0010;
    localparam ALU_OR   = 4'b0011;
    localparam ALU_XOR  = 4'b0100;
    localparam ALU_SLT  = 4'b0101;
    localparam ALU_SLL  = 4'b0110;
    localparam ALU_SRL  = 4'b0111;
    localparam ALU_SRA  = 4'b1000;

    // Main ALU control logic
    always @(*) begin
        case (alu_op)
            ALU_OP_R_TYPE: begin
                case ({funct7[5], funct3})
                    4'b0000: alu_ctrl = ALU_ADD;  // add
                    4'b1000: alu_ctrl = ALU_SUB;  // sub
                    4'b0111: alu_ctrl = ALU_AND;  // and
                    4'b0110: alu_ctrl = ALU_OR;   // or
                    4'b0100: alu_ctrl = ALU_XOR;  // xor
                    4'b0010: alu_ctrl = ALU_SLT;  // slt
                    4'b0001: alu_ctrl = ALU_SLL;  // sll
                    4'b0101: alu_ctrl = ALU_SRL;  // srl
                    4'b1101: alu_ctrl = ALU_SRA;  // sra
                    default: alu_ctrl = ALU_ADD;  // default to add
                endcase
            end

            ALU_OP_I_TYPE: begin
                case (funct3)
                    3'b000: alu_ctrl = ALU_ADD;  // addi
                    3'b111: alu_ctrl = ALU_AND;  // andi
                    3'b110: alu_ctrl = ALU_OR;   // ori
                    3'b100: alu_ctrl = ALU_XOR;  // xori
                    3'b010: alu_ctrl = ALU_SLT;  // slti
                    3'b001: alu_ctrl = ALU_SLL;  // slli
                    3'b101: alu_ctrl = (funct7[5] ? ALU_SRA : ALU_SRL);  // srli/srai
                    default: alu_ctrl = ALU_ADD;  // default to addi
                endcase
            end

            ALU_OP_BRANCH: begin
                case (funct3)
                    3'b000: alu_ctrl = ALU_SUB;  // beq
                    3'b001: alu_ctrl = ALU_SUB;  // bne
                    3'b100: alu_ctrl = ALU_SLT;  // blt
                    3'b101: alu_ctrl = ALU_SLT;  // bge
                    3'b110: alu_ctrl = ALU_SLT;  // bltu
                    3'b111: alu_ctrl = ALU_SLT;  // bgeu
                    default: alu_ctrl = ALU_SUB;  // default to beq
                endcase
            end

            default: begin
                alu_ctrl = ALU_ADD;  // default to add
            end
        endcase
    end

endmodule 