`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2026 04:54:56 PM
// Design Name: 
// Module Name: datamem
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

module datamem(
    input clk,input rst,input writemem, 
    input [31:0] address,input [31:0] writedata,output reg [31:0] datamemout 
    );
    reg [31:0] mem [0:511];
    always @ (posedge clk or posedge rst) begin
    if (rst) begin
    datamemout <= 32'b0;
    end
    else if(writemem == 1'b1) begin
    mem[address] <= writedata;
    end 
    else begin
    datamemout <= mem[address];
    end
    end
endmodule