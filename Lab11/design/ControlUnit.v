module ControlUnit (
    input wire [31:0] inst,
    output reg branch, mem_read, mem_to_reg, mem_write, alu_src, reg_write,
    output reg [3:0] alu_control
);
    always @(*) begin
        branch = 0;
        mem_read = 0;
        mem_to_reg = 0;
        mem_write = 0;
        alu_src = 0;
        reg_write = 0;
        alu_control = 4'd0;

        case (inst[6:0])
            7'b0110011: begin
                reg_write = 1;
                case ({inst[31:25], inst[14:12]})
                    10'b0000000_000: alu_control = 4'd0; // ADD
                    10'b0100000_000: alu_control = 4'd1; // SUB
                    10'b0000000_111: alu_control = 4'd2; // AND
                    10'b0000000_110: alu_control = 4'd3; // OR
                    10'b0000000_100: alu_control = 4'd4; // XOR
                    10'b0000000_001: alu_control = 4'd5; // SLL
                    10'b0000000_101: alu_control = 4'd6; // SRL
                    default: reg_write = 0;
                endcase
            end
            7'b0010011: if (inst[14:12] == 3'b000) begin // ADDI
                alu_src = 1;
                reg_write = 1;
            end
            7'b0000011: if (inst[14:12] == 3'b010) begin // LW
                alu_src = 1;
                mem_read = 1;
                mem_to_reg = 1;
                reg_write = 1;
            end
            7'b0100011: if (inst[14:12] == 3'b010) begin // SW
                alu_src = 1;
                mem_write = 1;
            end
            7'b1100011: if (inst[14:12] == 3'b000) begin // BEQ
                branch = 1;
                alu_control = 4'd1;
            end
            default: begin end
        endcase
    end
endmodule
