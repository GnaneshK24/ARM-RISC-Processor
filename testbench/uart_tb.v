module uart_tb;
    // Testbench signals
    reg clk;
    reg reset;
    reg rx;
    wire tx;
    reg [7:0] tx_data;
    reg tx_start;
    wire [7:0] rx_data;
    wire rx_ready;
    wire tx_busy;

    // Instantiate the UART
    uart #(
        .CLK_FREQ(100000000),
        .BAUD_RATE(115200)
    ) uart_inst (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .tx(tx),
        .tx_data(tx_data),
        .tx_start(tx_start),
        .rx_data(rx_data),
        .rx_ready(rx_ready),
        .tx_busy(tx_busy)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Test stimulus
    initial begin
        // Initialize waveform dumping
        $dumpfile("sim/uart.vcd");
        $dumpvars(0, uart_tb);

        // Initialize signals
        clk = 0;
        reset = 0;
        rx = 1;
        tx_data = 8'h00;
        tx_start = 0;

        // Test 1: Reset
        reset = 1;
        #10;
        reset = 0;
        #10;
        $display("Reset: rx_ready=%b, tx_busy=%b", rx_ready, tx_busy);

        // Test 2: Transmit data
        tx_data = 8'h55;
        tx_start = 1;
        #10;
        tx_start = 0;
        #1000;
        $display("Transmit: tx_data=%h, tx_busy=%b", tx_data, tx_busy);

        // Test 3: Receive data
        rx = 0;  // Start bit
        #868;    // 1 bit time at 115200 baud
        rx = 1;  // Bit 0
        #868;
        rx = 0;  // Bit 1
        #868;
        rx = 1;  // Bit 2
        #868;
        rx = 0;  // Bit 3
        #868;
        rx = 1;  // Bit 4
        #868;
        rx = 0;  // Bit 5
        #868;
        rx = 1;  // Bit 6
        #868;
        rx = 0;  // Bit 7
        #868;
        rx = 1;  // Stop bit
        #868;
        $display("Receive: rx_data=%h, rx_ready=%b", rx_data, rx_ready);

        // End simulation
        $display("All tests completed!");
        $finish;
    end

endmodule 