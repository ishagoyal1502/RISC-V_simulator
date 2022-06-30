#ISHA GOYAL
#2020CSB1089

# question 4
#the strings can be made of any character
#not case sensitive, i.e., s=S
.data
string1: .string "heyhowareYou"
string2: .string "helloIareyou"
length: .word 12

.text
lui a0 0x10001 #starting address of where the string 2 is to be stored
lui a1 0x10002 #starting address of where the string 2 is to be stored
la x5 string1 #starting address of string 1
la x6 string2 #starting address of string 2
lw a7 length #length of the two strings

storing_word: #storing the strings in their respective addresses
loop1:
addi a6 a6 1 #maintains the number of elemnts of the string stored
lb a4 0(x5)
sb a4 0(a0)
addi a0 a0 1
addi x5 x5 1
lb a4 0(x6)
sb a4 0(a1)
addi a1 a1 1
addi x6 x6 1
bne a6 a7 loop1 #once a6 becomes length, it means that the entire strigs have been stored

lui a0 0x10001 #stores the starting addresses again
lui a1 0x10002
addi a6 x0 0
comparison: #starts comparing between the strings
addi a6 a6 1 #maintains a count
lb a2 0(a0) #loads char of string 1
lb a3 0(a1) #loads char of string 2
addi a1 a1 1
addi a0 a0 1
beq a2 a3 check1 #checks if they are equal, if yes then goes to check1
check_letter: #if not equal then sees if its a special character or letter
addi a4 x0 65
blt a2 a4 answer #a2<65
blt a3 a4 answer #a3<65
addi a4 x0 123
bge a2 a4 answer #a2>122
bge a3 a4 answer #a3>122
addi a4 x0 91
addi a5 x0 97
bge a2 a4 try2 #a2>90
bge a3 a4 try3 #a3>90
beq x0 x0 check
try2:
blt a2 a5 answer
beq x0 x0 check
try3:
blt a3 a5 answer
# if any of the above got to answer, it means that atleast one of the characters is not a letter

check: #if both are letters, then we check if the case sensitive case applies
blt a2 a3 goto #a2<a3
addi a3 a3 32
beq a2 a3 check1 
answer: # increases the value of x7 by one, basically a pair of non-equal characters has been found
addi x7 x7 1
beq x0 x0 check1 #goes to check1 to see if the length of string has been covered or not
goto:
addi a2 a2 32 #on adding 32 to a2, if it becomes its lowercase version, then good else goes to answer
bne a2 a3 answer
check1: #checks the value of a6, if equal to length then exits
bne a6 a7 comparison
beq x0 x0 exit

exit:

