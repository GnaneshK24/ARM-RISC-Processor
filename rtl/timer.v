module timer (
    input wire clk,                    // Clock signal
    input wire reset,                  // Reset signal
    input wire [31:0] mtimecmp,        // Timer compare value
    output reg timer_interrupt         // Timer interrupt signal
);

    // Internal counter
    reg [31:0] mtime;

    // Counter and interrupt generation
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            mtime <= 32'b0;
            timer_interrupt <= 1'b0;
        end else begin
            mtime <= mtime + 32'b1;
            timer_interrupt <= (mtime >= mtimecmp);
        end
    end

endmodule 