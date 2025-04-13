module multiplexer #(
    parameter WIDTH = 32,
    parameter SEL_WIDTH = 2
) (
    input wire [SEL_WIDTH-1:0] sel,
    input wire [WIDTH-1:0] in0,
    input wire [WIDTH-1:0] in1,
    input wire [WIDTH-1:0] in2,
    input wire [WIDTH-1:0] in3,
    output reg [WIDTH-1:0] out
);

    always @(*) begin
        case (sel)
            2'b00: out = in0;
            2'b01: out = in1;
            2'b10: out = in2;
            2'b11: out = in3;
            default: out = {WIDTH{1'b0}};
        endcase
    end

endmodule 