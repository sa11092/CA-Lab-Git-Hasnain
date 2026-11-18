module InstructionMemory #(parameter ROM_FILE = "lab11.mem") (
    input wire [31:0] read_addr,
    output wire [31:0] inst
);
    reg [31:0] rom [0:63];

    initial $readmemh(ROM_FILE, rom);

    assign inst = (read_addr < 32'd256 && read_addr[1:0] == 2'b00)
                  ? rom[read_addr[7:2]] : 32'h00000013;
endmodule
