
main:

li x4, 5 #x4 = a
li x5, 0 #x5 = b
addi x4, x5, 32
add x6, x4, x5 #x6 = a+b
addi x7, x6, -5 #x7 = d
sub x8, x4, x7 #x8 = a-d
sub x9, x5, x4 #x9 = b-a
add x10, x9, x8 #x10 = (a - d) + (b - a)
add x11, x10, x7 #x11 = e
add x12, x6, x7 #x12 = a + b + d 
add x11, x12, x11
end:
j end