addi x1,x0,3
sw x1, 0(x0) # store the size of the arrays in first element of stack

#matrix one --------------------- offset 4-36
#5,8,3
#9,2,4
#6,5,4
addi x1,x0,5
sw x1, 4(x0)
addi x1,x0,8
sw x1, 8(x0)
addi x1,x0,3
sw x1, 12(x0)
addi x1,x0,9
sw x1, 16(x0)
addi x1,x0,2
sw x1, 20(x0)
addi x1,x0,4
sw x1, 24(x0)
addi x1,x0,6
sw x1, 28(x0)
addi x1,x0,5
sw x1, 32(x0)
addi x1,x0,4
sw x1, 36(x0)


#matrix two --------------------- offset 40-68
#2,4,6
#5,5,8
#3,9,4
addi x1,x0,2
sw x1, 40(x0)
addi x1,x0,4
sw x1, 44(x0)
addi x1,x0,6
sw x1, 48(x0)
addi x1,x0,5
sw x1, 52(x0)
addi x1,x0,5
sw x1, 56(x0)
addi x1,x0,8
sw x1, 60(x0)
addi x1,x0,3
sw x1, 64(x0)
addi x1,x0,9
sw x1, 68(x0)
addi x1,x0,4
sw x1, 72(x0)

#output matrix ------------------- offset 72-104
#58,87,106
#40,82,86
#49,85,92
#going to initialise to 0 for cleaner looking stack

addi x1,x0,0
sw x1, 76(x0)
addi x1,x0,0
sw x1, 80(x0)
addi x1,x0,0
sw x1, 84(x0)
addi x1,x0,0
sw x1, 88(x0)
addi x1,x0,0
sw x1, 92(x0)
addi x1,x0,0
sw x1, 96(x0)
addi x1,x0,0
sw x1, 100(x0)
addi x1,x0,0
sw x1, 104(x0)
addi x1,x0,0
sw x1, 108(x0)

lw x1, 0(x0)



#iterative solve

addi x4,x0,4 # keep x4 = 4 to calculate offsets
addi x8,x0,8 
mul x8, x4,x1 # keep x8 as 12 to calculate offset by row


mul x21,x8,x1 
add x21,x21,x4 #offset to matrix 2

mul x22,x8,x1
add x22,x22,x22
add x22,x22,x4 #offset to output matrix



#mul x22,x8,2


lw x1, 0(x0)# x1 will store array size
addi x2,x0,0 #x2 will store row
addi x3,x0,0 #x3 will store column
addi x5,x0,0



outer_loop:
bge x2,x1,outer_end




    middle_loop:
    bge x3,x1,middle_loop_end

        inner_loop:
        bge x5,x1,inner_loop_end
        # output[x2][x3] += matrix_1[x2][x4] * matrix_2[x4][x3]
        
        #--------------------------------------------Calculate output[x2][x3]--------------------------------------------
        #find offset from rows
        add x6,x0,x2
        mul x6,x6,x8
        
        #find offset from column
        add x7,x0,x3
        mul x7,x7,x4

        #combine offsets and add offset of output
        add x6,x6,x7
        add x6,x6,x22

        add x20,x0,x6

        lw x6, 0(x6) # store output[x2][x3] in x6

        #--------------------------------------------Calculate matrix_1[x2][x5]--------------------------------------------
        add x7,x0,x2
        mul x7,x7,x8

        add x9,x0,x5
        mul x9,x9,x4

        add x7,x7,x9
        addi x7,x7,4

        lw x7, 0(x7) # store matrix_1[x2][x5] in x7

        #--------------------------------------------Calculate matrix_2[x5][x3]--------------------------------------------
        add x9,x0,x5
        mul x9,x9,x8

        add x10,x0,x3
        mul x10,x10,x4

        add x9,x9,x10
        add x9,x9,x21

        lw x9,0(x9)



        #--------------------------------------------Calculate output[x2][x3] += matrix_1[x2][x4] * matrix_2[x4][x3] --------------------------------------------
        mul x7,x7,x9
        add x6,x6,x7

        #store back into output[x2][x3]

        sw x6, 0(x20)


        
        
        addi x5,x5,1
        j inner_loop
        inner_loop_end:
        addi x5,x0,0




    addi x3,x3,1
    j middle_loop
    middle_loop_end:
    addi x3,x0,0




addi x2,x2,1
j outer_loop
outer_end:

lw x2, 76(x0)
lw x3, 80(x0)
lw x4, 84(x0)
lw x5, 88(x0)
lw x6, 92(x0)
lw x7, 96(x0)
lw x8, 100(x0)
lw x9, 104(x0)
lw x10, 108(x0)


hold_end:
j hold_end