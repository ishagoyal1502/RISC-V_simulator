#ISHA GOYAL
#2020CSB1089

#question 1
#assuming a space after the last string so as to avoid confusion between "E 23" and "E 230"
#storing words, hence bit extended form stored for negative numbers
.data
input : .string "E -20 E 12 E 9 D D S E 23 " 
str: .string "EDS- "

.text
la x5 input
la x6 str
lui a3 0x10001 #the bottom of the array is stored in a3 throughout
beq x0 x0 main

convert_positive: #function used to convert the string into a number
addi a2 a0 -48
addi a4 x0 10 
loop: #loops untill a space is found, i.e. number completes
addi x5 x5 1
lb a0 0(x5)
lb a1 4(x6)
bne a0 a1 next #checks if space is found or not, and if not then goes to next
jalr x0 x1 0
next: #conversion into number
addi a5 a0 -48
mul a2 a4 a2
add a2 a2 a5
beq x0 x0 loop

convert_negative: #multiplies the positive number obtained by -1 to get negative number
addi x5 x5 1
lb a0 0(x5)
jal x1 convert_positive
addi a4 x0 -1
mul a2 a2 a4
beq x0 x0 value

enqueue: #enqueue function
addi sp sp -8
sw x1 0(sp)
addi x5 x5 2
lb a0 0(x5)
lb a1 3(x6)
beq a0 a1 convert_negative #checks if a - is found before the number itself
jal x1 convert_positive
value: #stores the word at the correct address
sw a2 0(a3)
addi a3 a3 4
lw x1 0(sp)
addi sp sp 8
jalr x0 x1 0

dequeue: #dequeue function
lui a2 0x10001
beq a2 a3 jump #checks if there is any element in the queue
loop1: #removes an element all the while keeping the starting address fixed at 0x10001000
lw a4 4(a2)
sw a4 0(a2)
addi a2 a2 4
bne a2 a3 loop1
addi a3 a3 -4
jalr x0 x1 0
jump: 
jalr x0 x1 0

size: #calculates size of queue and stores it at 0x10005000
lui a2 0x10001
lui a4 0x10005
sub a2 a3 a2
addi a5 x0 4
div a2 a2 a5
sb a2 0(a4)
jalr x0 x1 0

main: #the main code, the program actually starts from here
lb a0 0(x5)
lb a1 0(x6)
bne a0 a1 exit1 #if not equal to e then go to exit1 and checks for d
jal x1 enqueue
beq x0 x0 exit
exit1:
lb a1 1(x6)
bne a0 a1 exit2 #if not equal to d then go to exit2 and checks for s
jal x1 dequeue
beq x0 x0 exit
exit2:
lb a1 2(x6)
bne a0 a1 exit #if not equal to s then go to exit and checks for 0 after a space ,i.e, (" 0)
jal x1 size
beq x0 x0 exit
exit: #when an e,d or s is found it comes after performing the function to exit
addi x5 x5 1
bne a0 x0 main #checks for 0, if found then finish


