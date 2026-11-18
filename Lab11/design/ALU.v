module ALU (
    input wire [31:0] in1, in2,
    input wire [3:0] alu_control,
    output reg [31:0] result,
    output wire zero
);
    always @(*) begin
        case (alu_control)
            4'd0: result = in1 + in2;
            4'd1: result = in1 - in2;
            4'd2: result = in1 & in2;
            4'd3: result = in1 | in2;
            4'd4: result = in1 ^ in2;
            4'd5: result = in1 << in2[4:0];
            4'd6: result = in1 >> in2[4:0];
            default: result = 32'b0;
        endcase
    end

    assign zero = (result == 32'b0);
endmodule
