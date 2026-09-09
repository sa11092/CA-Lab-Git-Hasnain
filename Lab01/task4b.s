addi x4, x0, 4
addi x5, x0, 6
sb x4, 0x100(x0)
sh x5, 0x200(x0)
addi x4, x0, 7
addi x5, x0, 1
sb x4, 0x101(x0)
sh x5, 0x202(x0)
addi x4, x0, 12
addi x5, x0, 9
sb x4, 0x102(x0)
sh x5, 0x204(x0)
addi x4, x0, 1
addi x5, x0, 6
sb x4, 0x103(x0)
sh x5, 0x206(x0)
lb x1, 0x100(x0)
lh x2, 0x200(x0)
add x3, x1, x2
sw x3, 0x300(x0)
lb x1, 0x101(x0)
lh x2, 0x202(x0)
add x3, x1, x2
sw x3, 0x304(x0)
lb x1, 0x102(x0)
lh x2, 0x204(x0)
add x3, x1, x2
sw x3, 0x308(x0)
lb x1, 0x103(x0)
lh x2, 0x206(x0)
add x3, x1, x2
sw x3, 0x30C(x0)
end:
    j end