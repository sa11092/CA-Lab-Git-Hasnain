module FPGA_Top #(parameter STEP_CYCLES = 25_000_000) (
    input wire clk, btnC,
    input wire [15:0] sw,
    output wire [15:0] led
);
    reg [1:0] reset_sync = 2'b11;
    reg [15:0] sw_meta, sw_sync;
    reg [31:0] count = 0;
    wire reset = reset_sync[1];
    wire step = count == STEP_CYCLES - 1;

    always @(posedge clk) begin
        reset_sync <= {reset_sync[0], btnC};
        sw_meta <= sw;
        sw_sync <= sw_meta;
        if (reset || step)
            count <= 0;
        else
            count <= count + 1;
    end
    TopLevelProcessor #(.ROM_FILE("switch_sum.mem"), .BOARD_MODE(1)) cpu (
        .clk(clk), .reset(reset), .current_pc(),
        .step(step), .sw(sw_sync), .led(led)
    );
endmodule
