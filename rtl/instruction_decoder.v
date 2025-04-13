module instruction_decoder (
    input wire [31:0] instruction,     // 32-bit instruction
    output reg [6:0] opcode,          // 7-bit opcode
    output reg [4:0] rd,              // 5-bit destination register
    output reg [2:0] func3,           // 3-bit function code
    output reg [4:0] rs1,             // 5-bit first source register
    output reg [4:0] rs2,             // 5-bit second source register
    output reg [6:0] func7            // 7-bit function code
);

    // Decode instruction fields
    always @(*) begin
        opcode = instruction[6:0];
        rd = instruction[11:7];
        func3 = instruction[14:12];
        rs1 = instruction[19:15];
        rs2 = instruction[24:20];
        func7 = instruction[31:25];
    end

endmodule 