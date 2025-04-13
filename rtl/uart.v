module uart #(
    parameter CLK_FREQ = 100000000,    // Clock frequency in Hz
    parameter BAUD_RATE = 115200       // Baud rate
) (
    input wire clk,                    // Clock signal
    input wire reset,                  // Reset signal
    input wire rx,                     // Receive line
    output reg tx,                     // Transmit line
    input wire [7:0] tx_data,          // Data to transmit
    input wire tx_start,               // Start transmission
    output reg [7:0] rx_data,          // Received data
    output reg rx_ready,               // Received data ready
    output reg tx_busy                 // Transmission in progress
);

    // Calculate clock cycles per bit
    localparam CYCLES_PER_BIT = CLK_FREQ / BAUD_RATE;

    // Internal signals
    reg [15:0] rx_counter;
    reg [15:0] tx_counter;
    reg [3:0] rx_state;
    reg [3:0] tx_state;
    reg [7:0] rx_shift;
    reg [7:0] tx_shift;

    // States
    localparam IDLE = 4'b0000;
    localparam START = 4'b0001;
    localparam DATA = 4'b0010;
    localparam STOP = 4'b0011;

    // Receive process
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            rx_state <= IDLE;
            rx_counter <= 16'b0;
            rx_shift <= 8'b0;
            rx_data <= 8'b0;
            rx_ready <= 1'b0;
        end else begin
            case (rx_state)
                IDLE: begin
                    rx_ready <= 1'b0;
                    if (!rx) begin  // Start bit detected
                        rx_state <= START;
                        rx_counter <= 16'b0;
                    end
                end
                START: begin
                    if (rx_counter == (CYCLES_PER_BIT/2)) begin
                        rx_state <= DATA;
                        rx_counter <= 16'b0;
                        rx_shift <= 8'b0;
                    end else begin
                        rx_counter <= rx_counter + 16'b1;
                    end
                end
                DATA: begin
                    if (rx_counter == CYCLES_PER_BIT) begin
                        rx_shift <= {rx, rx_shift[7:1]};
                        rx_counter <= 16'b0;
                        if (rx_shift[0]) begin  // All bits received
                            rx_state <= STOP;
                        end
                    end else begin
                        rx_counter <= rx_counter + 16'b1;
                    end
                end
                STOP: begin
                    if (rx_counter == CYCLES_PER_BIT) begin
                        rx_data <= rx_shift;
                        rx_ready <= 1'b1;
                        rx_state <= IDLE;
                    end else begin
                        rx_counter <= rx_counter + 16'b1;
                    end
                end
            endcase
        end
    end

    // Transmit process
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tx_state <= IDLE;
            tx_counter <= 16'b0;
            tx_shift <= 8'b0;
            tx <= 1'b1;
            tx_busy <= 1'b0;
        end else begin
            case (tx_state)
                IDLE: begin
                    tx <= 1'b1;
                    tx_busy <= 1'b0;
                    if (tx_start) begin
                        tx_state <= START;
                        tx_counter <= 16'b0;
                        tx_shift <= tx_data;
                        tx_busy <= 1'b1;
                    end
                end
                START: begin
                    tx <= 1'b0;
                    if (tx_counter == CYCLES_PER_BIT) begin
                        tx_state <= DATA;
                        tx_counter <= 16'b0;
                    end else begin
                        tx_counter <= tx_counter + 16'b1;
                    end
                end
                DATA: begin
                    tx <= tx_shift[0];
                    if (tx_counter == CYCLES_PER_BIT) begin
                        tx_shift <= {1'b0, tx_shift[7:1]};
                        tx_counter <= 16'b0;
                        if (!tx_shift[7:1]) begin  // All bits transmitted
                            tx_state <= STOP;
                        end
                    end else begin
                        tx_counter <= tx_counter + 16'b1;
                    end
                end
                STOP: begin
                    tx <= 1'b1;
                    if (tx_counter == CYCLES_PER_BIT) begin
                        tx_state <= IDLE;
                    end else begin
                        tx_counter <= tx_counter + 16'b1;
                    end
                end
            endcase
        end
    end

endmodule 