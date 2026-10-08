// full_adder.v
// 1-bit full adder using XOR, AND, and OR gate modules

module full_adder (
    input a,
    input b,
    input cin,
    output sum,
    output cout
);

    wire x1;
    wire a1;
    wire a2;
    wire a3;
    wire o1;

    // Sum = a XOR b XOR cin
    xor_gate X1 (
        .a(a),
        .b(b),
        .y(x1)
    );

    xor_gate X2 (
        .a(x1),
        .b(cin),
        .y(sum)
    );

    // Carry = (a AND b) OR (b AND cin) OR (a AND cin)
    and_gate A1 (
        .a(a),
        .b(b),
        .y(a1)
    );

    and_gate A2 (
        .a(b),
        .b(cin),
        .y(a2)
    );

    and_gate A3 (
        .a(a),
        .b(cin),
        .y(a3)
    );

    or_gate O1 (
        .a(a1),
        .b(a2),
        .y(o1)
    );

    or_gate O2 (
        .a(o1),
        .b(a3),
        .y(cout)
    );

endmodule