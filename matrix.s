.data

.text


addi x1,x0,2
sw x1, 0(x0) # store the size of the arrays in first element of stack

#matrix one --------------------- offset 4 - 16
#5,8
#3,9
addi x1,x0,5
sw x1, 4(x0)
addi x1,x0,8
sw x1, 8(x0)
addi x1,x0,3
sw x1, 12(x0)
addi x1,x0,9
sw x1, 16(x0)

#matrix two --------------------- offset 20 - 32
#2,4
#6,5
addi x1,x0,2
sw x1, 20(x0)
addi x1,x0,4
sw x1, 24(x0)
addi x1,x0,6
sw x1, 28(x0)
addi x1,x0,5
sw x1, 32(x0)

#output matrix ------------------- offset 36 - 48
#58,60
#60,57
#going to initialise to 0 for cleaner looking stack

addi x1,x0,0
sw x1, 36(x0)
addi x1,x0,0
sw x1, 40(x0)
addi x1,x0,0
sw x1, 44(x0)
addi x1,x0,0
sw x1, 48(x0)

lw x1, 0(x0)



#iterative solve

addi x4,x0,4 # keep x4 = 4 to calculate offsets
addi x8,x0,8 # keep x8 =8 to calculate offset by row

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
        addi x6,x6,36

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
        addi x9,x9,20

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

lw x2, 36(x0)
lw x3, 40(x0)
lw x4, 44(x0)
lw x5, 48(x0)


addi x0,x0,0