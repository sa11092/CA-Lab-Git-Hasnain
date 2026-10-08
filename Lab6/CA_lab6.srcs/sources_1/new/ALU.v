// ALU.v
// 32-bit ALU built from full_adder, and_gate, or_gate, xor_gate modules.
// A generate loop wires up all 32 bits (pure wiring, no logic inside it).
// One case statement at the end picks the final result.

module ALU (
    input  [31:0] A,
    input  [31:0] B,
    input  [3:0]  ALUControl,
    output reg [31:0] ALUResult,
    output        Zero
);

    // ---- ALUControl encoding ----
    localparam ALU_AND = 4'b0000;
    localparam ALU_OR  = 4'b0001;
    localparam ALU_ADD = 4'b0010;
    localparam ALU_XOR = 4'b0011;
    localparam ALU_SLL = 4'b0100;
    localparam ALU_SRL = 4'b0101;
    localparam ALU_SUB = 4'b0110;

    wire subtract;
    assign subtract = (ALUControl == ALU_SUB);

    wire [31:0] b_inv;
    wire [31:0] adder_sum;
    wire [31:0] and_result;
    wire [31:0] or_result;
    wire [31:0] xor_result;
    wire [32:0] carry;

    assign carry[0] = subtract;

    // wire up one bit at a time, 32 times, using the gate modules
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : alu_bits
            xor_gate INV (.a(B[i]), .b(subtract), .y(b_inv[i]));
            full_adder FA (.a(A[i]), .b(b_inv[i]), .cin(carry[i]), .sum(adder_sum[i]), .cout(carry[i+1]));
            and_gate AG (.a(A[i]), .b(B[i]), .y(and_result[i]));
            or_gate OG (.a(A[i]), .b(B[i]), .y(or_result[i]));
            xor_gate XG (.a(A[i]), .b(B[i]), .y(xor_result[i]));
        end
    endgenerate

    wire [31:0] shift_left_result  = A << B[4:0];
    wire [31:0] shift_right_result = A >> B[4:0];

    // one simple case statement picks the final output
    always @(*) begin
        case (ALUControl)
            ALU_ADD: ALUResult = adder_sum;
            ALU_SUB: ALUResult = adder_sum;
            ALU_AND: ALUResult = and_result;
            ALU_OR:  ALUResult = or_result;
            ALU_XOR: ALUResult = xor_result;
            ALU_SLL: ALUResult = shift_left_result;
            ALU_SRL: ALUResult = shift_right_result;
            default: ALUResult = 32'd0;
        endcase
    end

    assign Zero = (ALUResult == 32'd0);

endmodule