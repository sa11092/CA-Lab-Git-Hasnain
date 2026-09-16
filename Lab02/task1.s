addi x22, x0, 6 # i
addi x23, x0, 6 # n
addi x20, x0, 4 # g
addi x21, x0, 2 # h
bne x22, x23, else
add x19, x20, x21 # f
beq x0,x0,exit
else: 
sub x19, x20, x21
addi x0, x0, 0
exit: 


addi x22, x0, 0 # i = 0
addi x24, x0, 1 # k = 1
addi x25, x0, 0
# save = [1,1,3]
addi x4, x0, 1
sw x4, 0(x25)
addi x4, x0, 1
sw x4, 4(x25)
addi x4, x0, 3
sw x4, 8(x25)
Loop:
slli x10, x22, 2
add x10, x10, x25
lw x9, 0(x10)
bne x9, x24, exit
addi x22, x22, 1
beq x0, x0, Loop
exit:
addi x0, x0, 0 

