.globl main

main:
    addi a0, x0, 48        # a = 48 taking a and b as test values
    addi a1, x0, 18        # b = 18
    jal  ra, gcd           # call gcd(48, 18) that will be 6
    mv   a1, a0          # move result into a1 for printing
    li   a0, 1            # print int syscall code
    ecall

    li   a0, 10                    
    ecall



gcd:

    addi sp, sp, -12         # allocate stack frame (3 words: ra, a, b)
    sw   x1, 8(sp)              #save return address
    sw   x10, 4(sp)             #save argument a
    sw   x11, 0(sp)             #save argument b
    beq  x11, x0, base            # if (b == 0) return a
    rem  x14, x10, x11              # x14 = a % b
    addi x10, x11, 0                  # a = b
    addi x11, x14, 0                  # b = a % b
    jal  x1, gcd                  # recursive call: gcd(b, a % b)
    lw   x1, 8(sp)                # restore return address already in a0
    addi sp, sp, 12
    jalr x0, 0(x1)                   # return



base:
    lw   x10, 4(sp)               # restore original a (this is the return value)
    lw   x1, 8(sp)                 # restore return address
    addi sp, sp, 12
    jalr x0, 0(x1)                   # return