`timescale 1ns/1ps
module tb_PCDatapath;
    reg clk = 0, reset = 1, PCSrc = 0;
    reg [31:0] inst = 32'h00A00093;
    wire [31:0] current_pc, next_seq_pc, branch_target, next_pc, imm_out;

    ProgramCounter pc_reg(clk, reset, next_pc, current_pc);
    pcAdder add4(current_pc, next_seq_pc);
    immGen imm_decoder(inst, imm_out);
    branchAdder add_branch(current_pc, imm_out, branch_target);
    mux2 pc_mux(next_seq_pc, branch_target, PCSrc, next_pc);

    always #5 clk = ~clk;

    task expect_pc;
        input [31:0] expected;
        begin
            @(posedge clk);
            #1;
            if (current_pc !== expected)
                $fatal(1, "Expected PC %0d, got %0d", expected, current_pc);
        end
    endtask

    initial begin
        expect_pc(0);
        if (imm_out !== 32'd10) $fatal(1, "ADDI immediate");
        @(negedge clk);
        reset = 0;
        inst = 32'hfe102e23; // sw x1,-4(x0)
        expect_pc(4);
        if (imm_out !== 32'hfffffffc) $fatal(1, "SW immediate");
        expect_pc(8);
        @(negedge clk);
        PCSrc = 1;
        inst = 32'hfe000ee3; // beq x0,x0,-4
        expect_pc(4);
        @(negedge clk);
        inst = 32'h00000463; // beq x0,x0,+8
        expect_pc(12);
        $display("Task 1 PASS");
        $finish;
    end
endmodule
