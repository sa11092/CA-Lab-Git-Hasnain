.globl main

main:
    addi a0, x0, 5        # n = 5 (test value)
    jal  ra, fact          # call fact(n)
    mv   a1, a0              # move result into a1 for printing
    li   a0, 1                # print_int syscall code
    ecall
    li   a0, 10               # exit syscall code
    ecall



fact:
    addi x6, x0, 1          # acc = 1


L1:
    bge  x0, x10, L2          # if (n <= 0) exit loop
    mul  x6, x6, x10         # acc = acc * n
    addi x10, x10, -1        # n = n - 1
    jal  x0, L1                # repeat loop


L2:
    addi x10, x6, 0          # move acc into a0 (return value)
    jalr x0, 0(x1)             # return to caller