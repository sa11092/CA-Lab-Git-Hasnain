addi x5, x0, 5 # a = 5
addi x6, x0, 3 # b = 3
addi x7, x0, 0 # i = 0
addi x10, x0, 0x200 # d = 0 (base address)
loop1:
addi x29, x0, 0 # j = 0
loop2:
slli x11, x29, 4
add  x12, x10, x11  # address of D[4*j]
add  x13, x7, x29   # x13 = i + j
sw   x13, 0(x12)    # D[4*j] = i + j
addi x29, x29, 1    # j++
blt  x29, x6, loop2 # if j < b, continue inner loop
addi x7, x7, 1      # i++
blt  x7, x5, loop1  # if i < a, continue outer loop
exit:
j exit