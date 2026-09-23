addi x10, x0, 12       # x10 = a = 12
addi x11, x0, 12       # x11 = b = 12
jal  x1, sum            # call sum(a, b)
addi x11, x10, 0        # copy result from x10 to x11
addi x10, x0, 1         # ecall 1 = print integer
ecall                    # prints 24
addi x10, x0, 10        # ecall 10 = exit program
ecall
sum:
    add x10, x10, x11       # x10 = a + b
    jalr x0, 0(x1)          # return to caller