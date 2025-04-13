module processor_top (
    input wire clk,                    // Clock signal
    input wire reset,                  // Reset signal
    input wire rx,                     // UART receive
    output wire tx,                    // UART transmit
    output wire [31:0] result          // Result output for testing
);

    // Internal wires and registers
    wire [31:0] pc;                    // Program Counter
    wire [31:0] next_pc;               // Next Program Counter
    wire [31:0] instruction;           // Current instruction
    wire [31:0] immediate;             // Immediate value
    wire [31:0] alu_result;            // ALU result
    wire [31:0] mem_data;              // Memory data
    wire [31:0] rs1_data;              // Register source 1 data
    wire [31:0] rs2_data;              // Register source 2 data
    wire [31:0] rd_data;               // Register destination data
    wire zero;                         // ALU zero flag
    wire overflow;                     // ALU overflow flag

    // Control signals
    wire [6:0] opcode;                 // Instruction opcode
    wire [2:0] func3;                  // Function code
    wire [6:0] func7;                  // Function code extension
    wire [4:0] rd;                     // Destination register
    wire [4:0] rs1;                    // Source register 1
    wire [4:0] rs2;                    // Source register 2

    // Control unit outputs
    wire reg_write;                    // Register write enable
    wire mem_write;                    // Memory write enable
    wire mem_read;                     // Memory read enable
    wire alu_src;                      // ALU source selection
    wire [1:0] pc_src;                 // PC source selection
    wire [1:0] result_src;             // Result source selection
    wire branch;                       // Branch instruction
    wire [3:0] alu_ctrl;              // ALU operation control

    // Debug signals
    wire [31:0] alu_op_a;             // ALU operand A
    wire [31:0] alu_op_b;             // ALU operand B
    wire [31:0] alu_result_debug;     // ALU result for debugging
    wire [3:0] alu_ctrl_debug;        // ALU control for debugging
    wire reg_write_debug;              // Register write for debugging
    wire [4:0] rd_debug;               // Destination register for debugging
    wire [31:0] rd_data_debug;         // Register write data for debugging

    // Branch unit outputs
    wire branch_taken;                 // Branch taken signal
    wire [31:0] branch_target;         // Branch target address

    // Timer signals
    wire timer_interrupt;              // Timer interrupt

    // UART signals
    wire [7:0] uart_tx_data;           // UART transmit data
    wire uart_tx_start;                // UART transmit start
    wire [7:0] uart_rx_data;           // UART receive data
    wire uart_rx_ready;                // UART receive ready
    wire uart_tx_busy;                 // UART transmit busy

    // Assign debug signals
    assign alu_op_a = rs1_data;
    assign alu_op_b = alu_src ? immediate : rs2_data;
    assign alu_result_debug = alu_result;
    assign alu_ctrl_debug = alu_ctrl;
    assign reg_write_debug = reg_write;
    assign rd_debug = rd;
    assign rd_data_debug = rd_data;

    // Instantiate Program Counter
    register #(.WIDTH(32)) pc_reg (
        .clk(clk),
        .reset(reset),
        .d(next_pc),
        .q(pc)
    );

    // Instantiate Instruction Memory
    instruction_memory imem (
        .address(pc),
        .instruction(instruction)
    );

    // Instantiate Instruction Decoder
    instruction_decoder idec (
        .instruction(instruction),
        .opcode(opcode),
        .rd(rd),
        .func3(func3),
        .rs1(rs1),
        .rs2(rs2),
        .func7(func7)
    );

    // Instantiate Immediate Generator
    immediate_generator imm_gen (
        .instruction(instruction),
        .immediate(immediate)
    );

    // Instantiate Register File
    register_file reg_file (
        .clk(clk),
        .rst_n(~reset),
        .rs1_addr(rs1),
        .rs2_addr(rs2),
        .rd_addr(rd),
        .rd_data(rd_data),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .reg_write(reg_write)
    );

    // Instantiate ALU
    alu alu_inst (
        .op_a(rs1_data),
        .op_b(alu_src ? immediate : rs2_data),
        .alu_ctrl(alu_ctrl),
        .result(alu_result),
        .zero(zero),
        .overflow(overflow)
    );

    // Instantiate Data Memory
    data_memory dmem (
        .clk(clk),
        .address(alu_result),
        .write_data(rs2_data),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .read_data(mem_data)
    );

    // Instantiate Branch Unit
    branch_unit branch_inst (
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .pc(pc),
        .immediate(immediate),
        .func3(func3),
        .branch(branch),
        .branch_taken(branch_taken),
        .branch_target(branch_target)
    );

    // Instantiate PC Adder
    pc_adder pc_add (
        .pc(pc),
        .immediate(immediate),
        .rs1_data(rs1_data),
        .pc_src(pc_src),
        .next_pc(next_pc)
    );

    // Instantiate Control Unit
    control_unit ctrl (
        .opcode(opcode),
        .func3(func3),
        .func7(func7),
        .reg_write(reg_write),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .alu_src(alu_src),
        .pc_src(pc_src),
        .result_src(result_src),
        .branch(branch),
        .alu_control(alu_ctrl)
    );

    // Instantiate Timer
    timer timer_inst (
        .clk(clk),
        .reset(reset),
        .mtimecmp(32'h0000FFFF),  // Example compare value
        .timer_interrupt(timer_interrupt)
    );

    // Instantiate UART
    uart uart_inst (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .tx(tx),
        .tx_data(uart_tx_data),
        .tx_start(uart_tx_start),
        .rx_data(uart_rx_data),
        .rx_ready(uart_rx_ready),
        .tx_busy(uart_tx_busy)
    );

    // Result multiplexer
    multiplexer #(.WIDTH(32), .SEL_WIDTH(2)) result_mux (
        .sel(result_src),
        .in0(alu_result),
        .in1(mem_data),
        .in2(pc + 32'h4),
        .in3(immediate),
        .out(rd_data)
    );

    // Assign result for testing
    assign result = alu_result;

endmodule 