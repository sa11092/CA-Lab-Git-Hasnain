addi x22, x0, 2 # b
addi x23, x0, 3 # c
addi x20, x0, 1 # x
addi x21, x0, 0 # a
addi x4, x0, 1  # temp = 1
addi x5, x0, 2  # temp = 2
addi x6, x0, 3  # temp = 3
addi x7, x0, 4  # temp = 4

beq x20, x4, case1
beq x20, x5, case2
beq x20, x6, case3
beq x20, x7, case4
beq x0, x0, exit

case1:
add x21, x22, x23
beq x0,x0,exit
case2:
sub x21, x22, x23
beq x0,x0,exit
case3:
slli x21, x22, 1 
beq x0,x0,exit
case4:
srli x21, x22, 1
beq x0,x0,exit
exit:
add x0, x0, x0