module alu (
    input wire [31:0] op_a,
    input wire [31:0] op_b,
    input wire [3:0] alu_ctrl,
    output reg [31:0] result,
    output wire zero,
    output reg overflow
);

    // ALU Control codes
    localparam ALU_ADD  = 4'b0000;
    localparam ALU_SUB  = 4'b0001;
    localparam ALU_AND  = 4'b0010;
    localparam ALU_OR   = 4'b0011;
    localparam ALU_XOR  = 4'b0100;
    localparam ALU_SLT  = 4'b0101;
    localparam ALU_SLL  = 4'b0110;
    localparam ALU_SRL  = 4'b0111;
    localparam ALU_SRA  = 4'b1000;

    // Zero flag
    assign zero = (result == 32'b0);

    // Main ALU operation
    always @(*) begin
        // Default no overflow
        overflow = 1'b0;
        
        case (alu_ctrl)
            ALU_ADD: begin
                {overflow, result} = {op_a[31], op_a} + {op_b[31], op_b};
            end
            
            ALU_SUB: begin
                {overflow, result} = {op_a[31], op_a} - {op_b[31], op_b};
            end
            
            ALU_AND: begin
                result = op_a & op_b;
            end
            
            ALU_OR: begin
                result = op_a | op_b;
            end
            
            ALU_XOR: begin
                result = op_a ^ op_b;
            end
            
            ALU_SLT: begin
                result = ($signed(op_a) < $signed(op_b)) ? 32'b1 : 32'b0;
            end
            
            ALU_SLL: begin
                result = op_a << op_b[4:0];
            end
            
            ALU_SRL: begin
                result = op_a >> op_b[4:0];
            end
            
            ALU_SRA: begin
                result = $signed(op_a) >>> op_b[4:0];
            end
            
            default: begin
                result = 32'b0;
                overflow = 1'b0;
            end
        endcase
    end

endmodule 