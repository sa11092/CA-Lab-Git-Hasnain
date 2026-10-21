`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2026 05:11:21 PM
// Design Name: 
// Module Name: addressdec
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


module addressdec(
    input [9:0]address, 
    input memwrite, memread,
    output DM, LED, Switch
    );
    wire[1:0] selector;
    assign selector = address[9:8];
    assign DM = ((selector == 2'b00) || (selector == 2'b01)) && memwrite;
    assign LED = (selector == 2'b10);
    assign Switch = (selector == 2'b11);
     
endmodule