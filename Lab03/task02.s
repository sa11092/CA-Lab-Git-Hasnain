addi x10, x0, 10 # g = 10
addi x11, x0, 20 # h = 20
addi x12, x0, 5 # i = 5
addi x13, x0, 7 # j = 7
jal x1, leaf_example # CALL leaf_example
# returned answer is in x10
addi x11, x10, 0 # copy result to x11 for printing
addi x10, x0, 1 # print integer
ecall
addi x10, x0, 10 # exit
ecall
leaf_example:
    addi sp, sp, -12 # reserve 12 bytes on stack
    sw x18, 8(sp) # save x18
    sw x19, 4(sp) # save x19
    sw x20, 0(sp) # save x20
    add x18, x10, x11 # x18 = g + h
    add x19, x12, x13 # x19 = i + j
    sub x20, x18, x19 # x20 = (g+h) - (i+j)
    addi x10, x20, 0 # return value -> x10
    lw x20, 0(sp) # restore x20
    lw x19, 4(sp) # restore x19
    lw x18, 8(sp) # restore x18
    addi sp, sp, 12 # restore stack
    jalr x0, 0(x1) # RETURN