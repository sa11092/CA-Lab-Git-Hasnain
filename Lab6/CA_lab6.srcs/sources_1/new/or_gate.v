// or_gate.v
// 1-bit OR gate: used for the ALU's OR operation

module or_gate (
    input  a,
    input  b,
    output y
);

    assign y = a | b;

endmodule