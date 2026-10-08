// ALU_tb.v
`timescale 1ns / 1ps

module ALU_tb;

    reg  [31:0] A, B;
    reg  [3:0]  ALUControl;
    wire [31:0] ALUResult;
    wire        Zero;

    ALU uut (
        .A(A),
        .B(B),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );

    task run_test;
        input [127:0] name;
        input [31:0]  a_in, b_in;
        input [3:0]   ctrl_in;
        input [31:0]  expected;
        begin
            A = a_in;
            B = b_in;
            ALUControl = ctrl_in;
            #10;
            if (ALUResult === expected)
                $display("PASS: %0s | A=%0d B=%0d -> Result=%0d", name, a_in, b_in, ALUResult);
            else
                $display("FAIL: %0s | A=%0d B=%0d -> Result=%0d (expected %0d)", name, a_in, b_in, ALUResult, expected);
        end
    endtask

    initial begin
        $display("---- Starting ALU tests ----");
        run_test("ADD", 32'd15, 32'd10, 4'b0010, 32'd25);
        run_test("SUB", 32'd15, 32'd10, 4'b0110, 32'd5);
        run_test("AND", 32'hFF00FF00, 32'h0F0F0F0F, 4'b0000, 32'h0F000F00);
        run_test("OR",  32'hFF00FF00, 32'h0F0F0F0F, 4'b0001, 32'hFF0FFF0F);
        run_test("XOR", 32'hFF00FF00, 32'h0F0F0F0F, 4'b0011, 32'hF00FF00F);
        run_test("SLL", 32'd1, 32'd4, 4'b0100, 32'd16);
        run_test("SRL", 32'd16, 32'd2, 4'b0101, 32'd4);
        run_test("SUB_EQUAL(zero check)", 32'd7, 32'd7, 4'b0110, 32'd0);
        $display("---- ALU tests complete ----");
        $finish;
    end

endmodule