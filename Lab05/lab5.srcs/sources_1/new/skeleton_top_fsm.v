`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module skeleton_top_fsm (
    input wire clk,
    input wire pbin,
    input wire [15:0] physical_sw,
    output wire [15:0] physical_leds);

    // DEBOUNCER
    wire rst_clean;
    wire [31:0] switch_data; // holds the value read from the switches
    reg  [31:0] led_write_data = 32'd0; // counter value goes here, shown on LEDs
    wire slow_clk;

    debouncer rst_db (
        .clk(clk),
        .pbin(pbin),
        .pbout(rst_clean)
    );
    leds switch_reader (
        .clk(clk), .rst(rst_clean),
        .btns(16'd0),// Not used for this FSM
        .writeData(32'd0), // We don't write to switches
        .writeEnable(1'b0),  // Disabled
        .readEnable(1'b1), // Always ON so we can monitor switches
        .memAddress(30'd0),
        .switches(physical_sw),// Plug in the physical switches
        .readData(switch_data)  // output data
    );

    switches led_writer (
        .clk(clk), .rst(rst_clean),
        .writeData(led_write_data),
        .writeEnable(1'b1), // Always ON so LEDs update instantly
        .readEnable(1'b0), .memAddress(30'd0),
        .readData(),  // Ignored
        .leds(physical_leds)
    );

    clock_divider ticker (
        .clk_in(clk), // Feed it the 100MHz fast clock
        .rst(rst_clean),  // Feed it the clean button signal
        .clk_out(slow_clk) // It spits out the 1Hz slow clock!
    );

    // Give the 3 states friendly names instead of bare numbers
    localparam S_INPUT = 2'b00; // Input-waiting state
    localparam S_COUNT = 2'b01; // Counter (counting down)
    localparam S_RESET = 2'b10;// Reset

    reg [1:0]  state       = S_INPUT; // which state we're in right now
    reg [15:0] counter_reg = 16'd0; // the number currently being counted down

    reg slow_clk_d = 1'b0;
    wire tick = slow_clk & ~slow_clk_d;

    always @(posedge clk) begin
        slow_clk_d <= slow_clk;
    end

    always @(posedge clk) begin
        if (rst_clean) begin
            state <= S_RESET;
            counter_reg <= 16'd0;
        end else begin
            case (state)

                S_INPUT: begin
                    if (physical_sw != 16'd0) begin
                        // sw != 0,load the value and start counting
                        counter_reg <= physical_sw;
                        state       <= S_COUNT;
                    end
                    // sw == 0, implicitly stays in S_INPUT (do nothing)
                end

                S_COUNT: begin
                    if (tick) begin
                        if (counter_reg == 16'd0)// counter == 0 -> back to Input-waiting
                            state <= S_INPUT;
                        else// counter != 0 -> count down, stay here
                            counter_reg <= counter_reg - 16'd1;
                    end
                end

                S_RESET: begin// go back to Input-waiting

                    state <= S_INPUT;
                end

                default: state <= S_INPUT;
            endcase
        end
    end

    always @(*) begin
        led_write_data = {16'd0, counter_reg};
    end

endmodule