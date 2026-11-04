`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/02/2026 01:52:29 PM
// Design Name: 
// Module Name: alu_control_
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

module alu_control (
    input wire [1:0] ALUOp,
    input wire [2:0] funct3,
    input wire [6:0] funct7,
    output reg [3:0] ALUControl
);

    localparam AND_OP = 4'b0000;
    localparam OR_OP  = 4'b0001;
    localparam ADD_OP = 4'b0010;
    localparam SLL_OP = 4'b0011;
    localparam SRL_OP = 4'b0100;
    localparam XOR_OP = 4'b0101;
    localparam SUB_OP = 4'b0110;

    always @(*) begin
        ALUControl = ADD_OP;

        case (ALUOp)
            2'b00: ALUControl = ADD_OP;
            2'b01: ALUControl = SUB_OP;

            2'b10: begin
                case (funct3)
                    3'b000: begin
                        if (funct7[5])
                            ALUControl = SUB_OP;
                        else
                            ALUControl = ADD_OP;
                    end

                    3'b001: ALUControl = SLL_OP;
                    3'b101: ALUControl = SRL_OP;
                    3'b111: ALUControl = AND_OP;
                    3'b110: ALUControl = OR_OP;
                    3'b100: ALUControl = XOR_OP;

                    default: ALUControl = ADD_OP;
                endcase
            end

            default: ALUControl = ADD_OP;
        endcase
    end

endmodule
