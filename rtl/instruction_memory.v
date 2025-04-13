module instruction_memory (
    input wire [31:0] address,
    output reg [31:0] instruction
);

    // Memory array (4KB = 1024 words)
    reg [31:0] memory [0:1023];

    // Initialize memory with program instructions
    initial begin
        // Test program:
        // 1. ADD x1, x2, x3    (x1 = x2 + x3)
        memory[0] = 32'h003100B3;
        // 2. SUB x4, x1, x2    (x4 = x1 - x2)
        memory[1] = 32'h40208233;
        // 3. LW x5, 0(x1)      (x5 = mem[x1])
        memory[2] = 32'h0000A283;
        // 4. SW x5, 4(x1)      (mem[x1+4] = x5)
        memory[3] = 32'h0050A223;
        // 5. BEQ x1, x2, 8     (if x1 == x2, PC += 8)
        memory[4] = 32'h00208463;
        // 6. JAL x6, 16        (x6 = PC + 4, PC += 16)
        memory[5] = 32'h0100036F;
        
        // Initialize remaining memory with zeros
        for (integer i = 6; i < 1024; i = i + 1) begin
            memory[i] = 32'b0;
        end
    end

    // Read operation (combinational)
    always @(*) begin
        instruction = memory[address[11:2]];  // Word-aligned addressing
    end

endmodule 