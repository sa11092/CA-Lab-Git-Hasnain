`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/02/2026 01:50:38 PM
// Design Name: 
// Module Name: riscv_ctrl_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module riscv_ctrl_top (
    input wire clk,
    input wire [15:0] sw,
    input wire btnC,
    input wire btnU,
    output wire [15:0] led
);

    wire [15:0] switches;
    wire step;
    wire reset;

    switch_interface u_switch (
        .clk(clk),
        .sw_in(sw),
        .sw_out(switches)
    );

    button_debounce u_button (
        .clk(clk),
        .btn_in(btnC),
        .btn_clean(),
        .btn_pulse(step)
    );

    button_debounce u_reset (
        .clk(clk),
        .btn_in(btnU),
        .btn_clean(reset),
        .btn_pulse()
    );

    reg [1:0] state;
    reg [6:0] opcode;
    reg [2:0] funct3;
    reg [6:0] funct7;

    initial begin
        state = 0;
        opcode = 0;
        funct3 = 0;
        funct7 = 0;
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= 0;
            opcode <= 0;
            funct3 <= 0;
            funct7 <= 0;
        end
        else if (step) begin
            case (state)
                0: begin
                    // Read opcode
                    opcode <= switches[6:0];
                    state <= 1;
                end

                1: begin
                    // Read funct3
                    funct3 <= switches[2:0];
                    state <= 2;
                end

                2: begin
                    // Read funct7
                    funct7 <= switches[6:0];
                    state <= 3;
                end

                3: begin
                    // Return to opcode entry
                    state <= 0;
                end

                default: state <= 0;
            endcase
        end
    end

    wire RegWrite;
    wire ALUSrc;
    wire MemRead;
    wire MemWrite;
    wire MemtoReg;
    wire Branch;
    wire [1:0] ALUOp;
    wire [3:0] ALUControl;

    main_control u_main (
        .opcode(opcode),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .Branch(Branch),
        .ALUOp(ALUOp)
    );

    alu_control u_alu (
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .ALUControl(ALUControl)
    );

    reg [15:0] led_data;

    always @(*) begin
        led_data = 16'b0;

        case (state)
            0: begin
                led_data[12] = 1'b1;
                led_data[6:0] = switches[6:0];
            end

            1: begin
                led_data[13] = 1'b1;
                led_data[6:0] = switches[6:0];
            end

            2: begin
                led_data[14] = 1'b1;
                led_data[6:0] = switches[6:0];
            end
            3: begin
                // Display control signals
                led_data[15] = 1'b1;
                led_data[0] = RegWrite;
                led_data[1] = ALUSrc;
                led_data[2] = MemRead;
                led_data[3] = MemWrite;
                led_data[4] = MemtoReg;
                led_data[5] = Branch;
                led_data[7:6] = ALUOp;
                led_data[11:8] = ALUControl;
            end
        endcase
    end

    led_interface u_led (
        .clk(clk),
        .led_in(led_data),
        .led_out(led)
    );
endmodule