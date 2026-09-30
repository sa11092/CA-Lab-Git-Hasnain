`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////


module clock_divider (
    input wire clk_in, // The super fast 100MHz board clock
    input wire rst,  // The reset button
    output reg clk_out // Our new slow 1Hz clock
);
    reg [25:0] count = 0; // A register big enough to hold the number 50,000,000

    localparam MAX_COUNT = 50_000_000 - 1;	//comment out for hw impl

    always @(posedge clk_in) begin
        if (rst) begin
            count <= 0;
            clk_out <= 0;
        end 
        else if (count == MAX_COUNT) begin
            count <= 0;
            clk_out <= ~clk_out; // Flip the slow clock opposite of what it was
        end 
        else begin
            count <= count + 1;
        end
    end

endmodule