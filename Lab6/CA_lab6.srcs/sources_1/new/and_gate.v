// and_gate.v
// 1-bit AND gate: used for the ALU's AND operation

module and_gate (
    input  a,
    input  b,
    output y
);

    assign y = a & b;

endmodule