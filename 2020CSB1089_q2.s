#ISHA GOYAL
#2020CSB1089
#question 2
#storing words
#assumption1: negative values can be taken
#assumption2: numbers can be repeated, like 1 2 2 3
#assumption3: 0 is considered as the end of arr2
#assumption4: because of above, and because the net length of the arr2 is not known, 
#             the arr2 cannot have two consecutive 0's in other than starting position
#             i.e., 0 0 1 2 3 is allowed but 
#                   1 0 0 2 3 is not allowed for arr 2
.data
arr1: .word -12 -2 0 0 0 2 3 4 4 5 6 7 8 9 
arr2: .word 0 0 5 6 7 8 9 10 11 12 

.text
la x5 arr1
la x6 arr2
add a3 x0 x6 #stores the starting address of arr2, important because arr2 follows arr1
beq x0 x0 merge

merge:
lui a0 0x10001
loop: #loop is initiated to store the values
lw a1 0(x5)
lw a2 0(x6)
beq x5 a3 check1 #checks if x5 is the starting address of arr2, basically meaning arr1 is over
beq a2 x0 check2 #checks if the current element of arr2 is 0, as this could possibly be the terminating condition of arr 
storing: #the main storing process is now
blt a1 a2 store1 #a1<a2 go to store the element of arr1 -> store1
beq a1 a2 store12 #a1=a2, go to store12, to store them both
blt a2 a1 store2 #a2<a1, go to store the element of arr2 -> store2
# one of the above three statements has to be correct
store1: #stores the element of arr1
sw a1 0(a0)
addi a0 a0 4
addi x5 x5 4
beq x0 x0 loop
store2: #stores the current element of arr2
sw a2 0(a0)
addi a0 a0 4
addi x6 x6 4
beq x0 x0 loop
store12: #stores both arr1 and arr2 current element
sw a1 0(a0)
sw a2 4(a0)
addi a0 a0 8
addi x5 x5 4
addi x6 x6 4
beq x0 x0 loop
check1: #if arr1 is over then stores the remaining values of arr2
beq a2 x0 exit
sw a2 0(a0)
addi a0 a0 4
addi x6 x6 4
beq x0 x0 loop
check2: #checks if it is the terminating condition for arr2
beq a3 x5 exit #if arr1 is also completed then exit, else store the remaining element of arr1 if arr2 has been completed
beq a3 x6 storing #if 0 is present at the start, it means the arr2 is not completed
lw a4 4(a6)
bne a4 x0 storing #if present element is 0, but the next element isn't -> arr2 is not terminated
sw a1 0(a0)
addi a0 a0 4
addi x5 x5 4
beq x0 x0 loop
exit: