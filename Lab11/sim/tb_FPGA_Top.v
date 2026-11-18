`timescale 1ns/1ps
module tb_FPGA_Top;
    reg clk = 0, btnC = 1;
    reg [15:0] sw = 16'hA507;
    wire [15:0] led;

    FPGA_Top #(.STEP_CYCLES(4)) dut(.clk(clk), .btnC(btnC), .sw(sw), .led(led));
    always #5 clk = ~clk;

    initial begin
        repeat (4) @(negedge clk);
        if (led !== 16'd0) $fatal(1, "Reset did not clear LEDs");
        btnC = 0;
        repeat (24) @(negedge clk);
        if (led !== 16'd172) $fatal(1, "First sum incorrect");
        sw = 16'hFFFF;
        repeat (32) @(negedge clk);
        if (led !== 16'd510) $fatal(1, "Updated sum incorrect");
        $display("Board demo PASS");
        $finish;
    end
endmodule
