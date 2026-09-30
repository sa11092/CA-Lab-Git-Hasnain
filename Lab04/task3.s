.globl main 
 
main: 
    la   a0, array            # a0 = address of array 
    addi a1, x0, 5              # a1 = len = 5 
    jal  ra, bubble         #calling bubble sort function 
    li   a0, 10                   
    ecall 
 
.data 
array: .word 5, 3, 8, 1, 9 #initilaizing an array of 5 integers so that we can check if the bubble sort function is working properly or not 
 
.text 
bubble: 
 
 
    beq  x10, x0, done 
    beq  x11, x0, done 
    addi x12, x0, 0 

outer: # for the outer loop 
 
    bge  x12, x11, done 
    addi x13, x12, 0 
 
 
inner: 
 bge  x13, x11, next_i 
    slli x14, x12, 2 
    add  x14, x10, x14 
    lw   x16, 0(x14) 
    slli x15, x13, 2 
    add  x15, x10, x15 
    lw   x17, 0(x15) 
    bge  x16, x17, skip 
    sw   x17, 0(x14) 
    sw   x16, 0(x15) 
 
skip: 
 
 
    addi x13, x13, 1 
    jal  x0, inner 
 
next_i: # for the next iteration of the outer loop 
 
    addi x12, x12, 1 
    jal  x0, outer 
 
done: 
    jalr x0, 0(x1)