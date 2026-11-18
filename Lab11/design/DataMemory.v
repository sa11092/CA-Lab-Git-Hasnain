module DataMemory (
    input wire clk, mem_write, mem_read,
    input wire [31:0] address, write_data,
    output wire [31:0] read_data
);
    reg [31:0] ram [0:63];
    wire valid_address = address < 32'd256 && address[1:0] == 2'b00;

    always @(posedge clk) begin
        if (mem_write && valid_address)
            ram[address[7:2]] <= write_data;
    end

    assign read_data = (mem_read && valid_address)
                       ? ram[address[7:2]] : 32'b0;
endmodule
