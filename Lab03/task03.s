li x5, 5
li x6, 10
sw x5, 0x120(x0) # store 5 at address 0x120
sw x6, 0x124(x0) # store 10 at address 0x124
# Pass arguments to the swap function
addi x10, x0, 0x100  # x10 contains the base address
addi x11, x0, 8 # x11 contains the index k
jal x1, swap # call the swap function
j exit  # go to exit after returning

swap:

    slli x11, x11, 2 # multiply k by 4 to get the byte offset
    add x10, x10, x11 # x10 now points to the required array element

    lw x13, 0(x10) # load the first value
    lw x14, 4(x10) # load the next value

    sw x14, 0(x10) # put second value in first position
    sw x13, 4(x10) # put first value in second position

    jalr x0, 0(x1)# return to the main program
exit:

    addi x10, x0, 10 # system call for exit
    ecall