`timescale 1ns/1ps
module tb_TopLevelProcessor;
    reg clk = 0, reset = 1;
    wire [15:0] current_pc;
    TopLevelProcessor dut(.clk(clk), .reset(reset), .current_pc(current_pc),
                          .step(1'b1), .sw(16'b0), .led());

    always #5 clk = ~clk;

    task expect_pc;
        input [15:0] expected;
        begin
            @(posedge clk);
            #1;
            if (current_pc !== expected)
                $fatal(1, "Expected PC %0d, got %0d", expected, current_pc);
        end
    endtask

    initial begin
        expect_pc(0);
        @(negedge clk);
        reset = 0;
        expect_pc(4);
        expect_pc(8);
        expect_pc(12);
        expect_pc(16);
        expect_pc(20); // BEQ x2,x0 is untaken
        expect_pc(28); // BEQ x1,x2 skips PC 24
        expect_pc(32);
        expect_pc(36);
        expect_pc(32); // Negative branch offset
        if (dut.dmem.ram[0] !== 32'd5 ||
            dut.regfile.regs[1] !== 32'd5 ||
            dut.regfile.regs[2] !== 32'd5 ||
            dut.regfile.regs[3] !== 32'd10)
            $fatal(1, "Incorrect register or memory contents");
        $display("Task 2 PASS");
        $finish;
    end
endmodule
