`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Muddassir Ali
//
// Module Name: fsm_top
// Project Name: ALU
// Target Devices: Basys 3
//
//////////////////////////////////////////////////////////////////////////////////

module fsm_top (
    input wire clk,
    input wire pbin,
    input wire [15:0] physical_sw,
    output wire [15:0] physical_leds
);

    // ============================================================
    // LAB 5 INTERFACE
    // ============================================================

    wire rst_clean;

    // Data read from the physical switches
    wire [31:0] switch_data;

    // Data written to the physical LEDs
    reg [31:0] led_write_data = 32'd0;


    // ------------------------------------------------------------
    // Debouncer from Lab 5
    // Port names fixed to match debouncer.v (clk, reset, btn_in, btn_out)
    // ------------------------------------------------------------

    debouncer rst_db (
        .clk(clk),
        .reset(1'b0),
        .btn_in(pbin),
        .btn_out(rst_clean)
    );


    // ------------------------------------------------------------
    // Edge-detect the debounced button so the FSM advances ONCE
    // per press instead of every clock cycle the button is held.
    // ------------------------------------------------------------

    reg btn_prev = 1'b0;
    wire btn_pressed;

    always @(posedge clk) begin
        btn_prev <= rst_clean;
    end

    assign btn_pressed = rst_clean & ~btn_prev;


    // ------------------------------------------------------------
    // LED module from Lab 5
    // Reads the physical switches
    // ------------------------------------------------------------

    leds switch_reader (
        .clk(clk),
        .rst(1'b0),
        .btns(16'd0),
        .writeData(32'd0),
        .writeEnable(1'b0),
        .readEnable(1'b1),
        .memAddress(30'd0),
        .switches(physical_sw),
        .readData(switch_data)
    );


    // ------------------------------------------------------------
    // Switches module from Lab 5
    // Writes data to the physical LEDs
    // ------------------------------------------------------------

    switches led_writer (
        .clk(clk),
        .rst(1'b0),
        .writeData(led_write_data),
        .writeEnable(1'b1),
        .readEnable(1'b0),
        .memAddress(30'd0),
        .readData(),
        .leds(physical_leds)
    );


    // ============================================================
    // FIXED ALU OPERANDS
    // ============================================================

    wire [31:0] A;
    wire [31:0] B;

    assign A = 32'h10101010;
    assign B = 32'h01010101;


    // ============================================================
    // ALU CONTROL
    // SW[3:0] controls the ALU operation
    //
    // 0000 = AND
    // 0001 = OR
    // 0010 = ADD
    // 0011 = XOR
    // 0100 = SLL
    // 0101 = SRL
    // 0110 = SUB
    // ============================================================

    reg [3:0] ALUControl;

    always @(*) begin
        ALUControl = switch_data[3:0];
    end


    // ============================================================
    // ALU
    // ============================================================

    wire [31:0] ALUResult;
    wire Zero;

    ALU alu_unit (
        .A(A),
        .B(B),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );


    // ============================================================
    // SIMPLE FSM
    // S_WAIT    : idle - switches freely select the operation,
    //             LEDs stay blank
    // S_EXECUTE : one-cycle pass-through - latches the ALU result
    // S_DISPLAY : holds the latched result on the LEDs until the
    //             button is pressed again
    // ============================================================

    localparam S_WAIT    = 2'b00;
    localparam S_EXECUTE = 2'b01;
    localparam S_DISPLAY = 2'b10;

    reg [1:0] state = S_WAIT;

    reg [31:0] ALUResult_latched = 32'd0;
    reg        Zero_latched      = 1'b0;

    always @(posedge clk) begin

        case (state)

            // Wait here until the button is pressed; switches
            // are free to select whichever operation to run.
            S_WAIT: begin
                if (btn_pressed)
                    state <= S_EXECUTE;
            end

            // Latch the currently-selected ALU result, then move on.
            S_EXECUTE: begin
                ALUResult_latched <= ALUResult;
                Zero_latched      <= Zero;
                state             <= S_DISPLAY;
            end

            // Hold the result on the LEDs until pressed again.
            S_DISPLAY: begin
                if (btn_pressed)
                    state <= S_WAIT;
            end

            default: begin
                state <= S_WAIT;
            end

        endcase

    end


    // ============================================================
    // LED OUTPUT
    //
    // LED[14:0] = lower 15 bits of the latched ALUResult
    // LED[15]   = latched Zero flag
    // Blank (all zero) whenever we're not in S_DISPLAY.
    // ============================================================

    always @(*) begin
        if (state == S_DISPLAY)
            led_write_data = {Zero_latched, ALUResult_latched[14:0]};
        else
            led_write_data = 32'd0;
    end


endmodule