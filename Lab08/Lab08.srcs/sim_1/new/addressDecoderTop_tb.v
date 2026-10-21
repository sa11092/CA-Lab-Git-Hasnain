`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2026 05:54:56 PM
// Design Name: 
// Module Name: addressDecoderTop_tb
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


module addressDecoderTop_tb;

    reg clk = 0;
    reg rst;
    reg [31:0] address;
    reg readEnable, writeEnable;
    reg [31:0] writeData;
    reg [15:0] switches;

    wire [31:0] readData;
    wire [15:0] leds;

    addressDecoderTop uut(
        .clk(clk),
        .rst(rst),
        .address(address),
        .readEnable(readEnable),
        .writeEnable(writeEnable),
        .writeData(writeData),
        .switches(switches),
        .readData(readData),
        .leds(leds)
    );

    always #5 clk = ~clk;

    initial begin
        rst = 1;
        address = 0;
        readEnable = 0;
        writeEnable = 0;
        writeData = 0;
        switches = 16'h1234;

        #10;
        rst = 0;
        address = 32'h00000004;
        writeData = 32'hABCDEF12;
        writeEnable = 1;

        #10;
        writeEnable = 0;
        readEnable = 1;

        #10;
        address = 32'h00000200;
        writeData = 32'h0000ABCD;
        writeEnable = 1;
        readEnable = 0;

        #10;
        address = 32'h00000300;
        writeEnable = 0;
        readEnable = 1;

        #10;
        $finish;
    end

endmodule