// xor_gate.v
// 1-bit XOR gate: used for the ALU's XOR operation, AND to invert b for SUB
// (SUB = A + (~B) + 1, so this same gate doubles as the B-inverter for subtract)

module xor_gate (
    input  a,
    input  b,
    output y
);

    assign y = a ^ b;

endmodule