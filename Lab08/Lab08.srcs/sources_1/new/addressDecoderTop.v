`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2026 05:25:07 PM
// Design Name: 
// Module Name: addressDecoderTop
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
/////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module addressDecoderTop(
    input clk,
    input rst,
    input [15:0] switches,
    output [15:0] leds
);

    // SW15: Read enable
    // SW14: Write enable
    // SW13-SW12: Device selection
    //   00, 01 = Data memory
    //   10     = LEDs
    //   11     = Switches
    // SW11-SW8: Local address
    // SW7-SW0:  Write data

    wire readEnable;
    wire writeEnable;

    assign readEnable =
        switches[15] && !switches[14] && !rst;

    assign writeEnable =
        switches[14] && !switches[15] && !rst;

    wire [31:0] address;
    wire [31:0] writeData;

    assign address =
        {22'b0, switches[13:12], 4'b0000, switches[11:8]};

    assign writeData = {24'b0, switches[7:0]};

    wire DM, LED, Switch;

    wire [31:0] memoryData;
    wire [31:0] switchData;
    wire [31:0] unusedLedData;
    wire [15:0] storedLeds;

    addressdec decoder(
        .address(address[9:0]),
        .memwrite(writeEnable),
        .memread(readEnable),
        .DM(DM),
        .LED(LED),
        .Switch(Switch)
    );

    datamem memory(
        .clk(clk),
        .rst(rst),
        .writemem(DM),
        .address({23'b0, address[8:0]}),
        .writedata(writeData),
        .datamemout(memoryData)
    );

    leds switchReader(
        .clk(clk),
        .rst(rst),
        .btns(16'b0),
        .writeData(writeData),
        .writeEnable(1'b0),
        .readEnable(readEnable && Switch),
        .memAddress(address[31:2]),
        .switches(switches),
        .readData(switchData)
    );

    switches ledWriter(
        .clk(clk),
        .rst(rst),
        .writeData(writeData),
        .writeEnable(writeEnable && LED),
        .readEnable(1'b0),
        .memAddress(address[31:2]),
        .readData(unusedLedData),
        .leds(storedLeds)
    );

    assign leds = rst ? 16'b0 :
                  (readEnable && Switch) ? switchData[15:0] :
                  (readEnable && !LED && !Switch) ?
                      memoryData[15:0] :
                  storedLeds;

endmodule

    