addi x22, x0, 0 # i = 0
addi x23, x0, 0 # sum = 0
addi x4, x0, 0x200
addi x10, x0, 10 # 10

loop1:
slli x5, x22, 2
add x6, x4, x5
sw x22, 0(x6)
beq x22, x10, exit
addi x22, x22, 1
beq x0, x0, loop1
exit:
addi x22, x0, 0 # i = 0

loop2:
slli x5, x22, 2
add x6, x4, x5
lw x7, 0(x6)
add x23, x23, x7 
beq x22, x10, exit1
addi x22, x22, 1
beq x0, x0, loop2

exit1:
add x0, x0, x0