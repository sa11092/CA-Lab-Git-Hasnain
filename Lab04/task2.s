.globl main
main:
    addi a0, x0, 5        # num = 5 as a test value
    jal  ra, ntri            # call ntri(5)
    mv   a1, a0              # move result into a1 for printing
    li   a0, 1                # print int syscall code
    ecall
    li   a0, 10               # exit syscall code
    ecall

ntri:
    addi sp, sp, -8         # allocate stack frame (2 words: ra, num)
    sw   x1, 4(sp)            # save return address
    sw   x10, 0(sp)            # save argument num



    addi x5, x0, 1               # x5 = 1
    bge  x5, x10, base             # if (1 >= num), i.e. num <= 1, go to base case



    addi x10, x10, -1            # argument = num - 1
    jal  x1, ntri                   # this is a recursive call that is ntri(num - 1)



    addi x6, x10, 0              # this saves the result of ntri(num-1)
    lw   x10, 0(sp)               # restore original num
    lw   x1, 4(sp)                 # this restores the return address
    addi sp, sp, 8

    add  x10, x10, x6             # does num + ntri(num-1)
    jalr x0, 0(x1)                   # return




base:
    addi x10, x0, 1                # return 1
    addi sp, sp, 8
    jalr x0, 0(x1)