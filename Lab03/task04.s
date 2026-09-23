main:

    li x7, 3 # value in x7
    sw x7, 0x200(x0) # source address
    li x7, 4 # second value in x7
    sb x7, 0x201(x0) # second value Sbyte
    li x10, 0x100 # x10 has destination address
    li x11, 0x200 # x11 has source address
    jal x1, strcpy
stop:
    j stop # stop 

strcpy:
    addi sp, sp, -16 # make spaces in stack
    sw x20, 12(sp) # x20 in stack
    li x20, 0 # x20 is index and starts from 0

loop:
    add x7, x20, x11 # source byte address
    lb x28, 0(x7)
    add x7, x20, x10 # destination byte address
    sb x28, 0(x7) 
    beq x28, x0, exit   
    addi x20, x20, 1 # increase index 
    beq x0, x0, loop

exit:
    lw x20, 12(sp) # restore old value of x20
    addi sp, sp, 16 # remove stack space
    jalr x0, 0(x1)