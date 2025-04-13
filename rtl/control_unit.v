module control_unit (
    input wire [6:0] opcode,          // Instruction opcode
    input wire [2:0] func3,           // Function code
    input wire [6:0] func7,           // Function code extension
    output reg reg_write,             // Register write enable
    output reg mem_write,             // Memory write enable
    output reg mem_read,              // Memory read enable
    output reg alu_src,               // ALU source selection (reg/imm)
    output reg [1:0] pc_src,          // PC source selection
    output reg [1:0] result_src,      // Result source selection
    output reg branch,                // Branch instruction
    output reg [3:0] alu_control      // ALU operation (4 bits)
);

    // Instruction type decoding
    wire is_r_type = (opcode == 7'b0110011);
    wire is_i_type = (opcode == 7'b0010011);
    wire is_load = (opcode == 7'b0000011);
    wire is_store = (opcode == 7'b0100011);
    wire is_branch = (opcode == 7'b1100011);
    wire is_jal = (opcode == 7'b1101111);
    wire is_jalr = (opcode == 7'b1100111);
    wire is_lui = (opcode == 7'b0110111);
    wire is_auipc = (opcode == 7'b0010111);

    // ALU control codes (4 bits)
    localparam ALU_ADD  = 4'b0000;
    localparam ALU_SUB  = 4'b0001;
    localparam ALU_AND  = 4'b0010;
    localparam ALU_OR   = 4'b0011;
    localparam ALU_XOR  = 4'b0100;
    localparam ALU_SLT  = 4'b0101;
    localparam ALU_SLL  = 4'b0110;
    localparam ALU_SRL  = 4'b0111;
    localparam ALU_SRA  = 4'b1000;

    // Generate control signals
    always @(*) begin
        // Default values
        reg_write = 1'b0;
        mem_write = 1'b0;
        mem_read = 1'b0;
        alu_src = 1'b0;
        pc_src = 2'b00;  // PC + 4
        result_src = 2'b00;  // ALU result
        branch = 1'b0;
        alu_control = ALU_ADD;

        case (opcode)
            // R-type instructions
            7'b0110011: begin
                reg_write = 1'b1;
                case (func3)
                    3'b000: alu_control = func7[5] ? ALU_SUB : ALU_ADD;  // SUB/ADD
                    3'b001: alu_control = ALU_SLL;  // SLL
                    3'b010: alu_control = ALU_SLT;  // SLT
                    3'b011: alu_control = ALU_SLT;  // SLTU (treat as SLT for now)
                    3'b100: alu_control = ALU_XOR;  // XOR
                    3'b101: alu_control = func7[5] ? ALU_SRA : ALU_SRL;  // SRA/SRL
                    3'b110: alu_control = ALU_OR;   // OR
                    3'b111: alu_control = ALU_AND;  // AND
                endcase
            end

            // I-type instructions
            7'b0010011: begin
                reg_write = 1'b1;
                alu_src = 1'b1;
                case (func3)
                    3'b000: alu_control = ALU_ADD;  // ADDI
                    3'b001: alu_control = ALU_SLL;  // SLLI
                    3'b010: alu_control = ALU_SLT;  // SLTI
                    3'b011: alu_control = ALU_SLT;  // SLTIU (treat as SLTI for now)
                    3'b100: alu_control = ALU_XOR;  // XORI
                    3'b101: alu_control = func7[5] ? ALU_SRA : ALU_SRL;  // SRAI/SRLI
                    3'b110: alu_control = ALU_OR;   // ORI
                    3'b111: alu_control = ALU_AND;  // ANDI
                endcase
            end

            // Load instructions
            7'b0000011: begin
                reg_write = 1'b1;
                alu_src = 1'b1;
                mem_read = 1'b1;
                result_src = 2'b01;  // Memory data
                alu_control = ALU_ADD;
            end

            // Store instructions
            7'b0100011: begin
                alu_src = 1'b1;
                mem_write = 1'b1;
                alu_control = ALU_ADD;
            end

            // Branch instructions
            7'b1100011: begin
                branch = 1'b1;
                pc_src = 2'b01;  // PC + immediate
                case (func3)
                    3'b000: alu_control = ALU_SUB;  // BEQ
                    3'b001: alu_control = ALU_SUB;  // BNE
                    3'b100: alu_control = ALU_SLT;  // BLT
                    3'b101: alu_control = ALU_SLT;  // BGE
                    3'b110: alu_control = ALU_SLT;  // BLTU
                    3'b111: alu_control = ALU_SLT;  // BGEU
                    default: alu_control = ALU_ADD;
                endcase
            end

            // JAL
            7'b1101111: begin
                reg_write = 1'b1;
                pc_src = 2'b01;  // PC + immediate
                result_src = 2'b10;  // PC + 4
                alu_control = ALU_ADD;
            end

            // JALR
            7'b1100111: begin
                reg_write = 1'b1;
                alu_src = 1'b1;
                pc_src = 2'b10;  // rs1 + immediate
                result_src = 2'b10;  // PC + 4
                alu_control = ALU_ADD;
            end

            // LUI
            7'b0110111: begin
                reg_write = 1'b1;
                result_src = 2'b11;  // Immediate
                alu_control = ALU_ADD;
            end

            // AUIPC
            7'b0010111: begin
                reg_write = 1'b1;
                alu_src = 1'b1;
                result_src = 2'b00;  // ALU result
                alu_control = ALU_ADD;
            end
        endcase
    end

endmodule 