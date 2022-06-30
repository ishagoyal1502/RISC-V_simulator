#ISHA GOYAL
#2020CSB1089

#question 3
# add  opcode 0110011
# slti opcode 0010011
# lw   opcode 0000011
# sw   opcode 0100011
# beq  opcode 1100011
.data
arr: .word 0x005180b3 0x0051a093 0x0032a083 0x0012a1a3 0x00308263  #add x1 x3 x5, slti x1 x3 5, lw x1 3(x5), sw x1 3(x5), beq x1 x3 (4)    
opcodes: .word 0b00110011 0b00010011 0b00000011 0b00100011 0b01100011

#the program stores the values as words and in left to right order of their appearance in the machine code, immediate is always stored last
.text
la x5 arr
lui x6 0x10001
la x7 opcodes
add a0 x0 x7

beq x0 x0 main

main: #main function checks for the opcode and accordingly determines the type of the machine code
lb a1 0(x5)
andi a1 a1 0x7f 
lw a2 0(x7)
beq a1 a2 add_type
lw a2 4(x7)
beq a1 a2 slti_lw_type
lw a2 8(x7)
beq a1 a2 slti_lw_type
lw a2 12(x7)
beq a1 a2 sw_type
lw a2 16(x7)
beq a1 a2 beq_type

add_type: #add type machine code
jal x1 storing_opcode
jal x1 storing_rd
jal x1 storing_func3
jal x1 storing_rs1
jal x1 storing_rs2
jal x1 storing_func7
addi x5 x5 4
lw a1 0(x5)
beq x5 a0 exit
beq x0 x0 main


slti_lw_type: #slti and lw type machine code
jal x1 storing_opcode
jal x1 storing_rd
jal x1 storing_func3
jal x1 storing_rs1
jal x1 immediate_slti_lw
addi x5 x5 4
lw a1 0(x5)
beq x5 a0 exit
beq x0 x0 main


sw_type: #sw type machine code
jal x1 storing_opcode
jal x1 storing_func3
jal x1 storing_rs1
jal x1 storing_rs2
jal x1 immediate_sw
addi x5 x5 4
lw a1 0(x5)
beq x5 a0 exit
beq x0 x0 main

beq_type: #beq type machine code
jal x1 storing_opcode
jal x1 storing_func3
jal x1 storing_rs1
jal x1 storing_rs2
jal x1 immediate_beq
addi x5 x5 4
lw a1 0(x5)
beq x5 a0 exit
beq x0 x0 main

storing_opcode:
sw a1 0(x6) #storing opcode
addi x6 x6 4
jalr x0 x1 0

storing_rs1:
lb a1 1(x5)
lb a2 2(x5)
andi a1 a1 0x080
andi a2 a2 0x0f
slli a2 a2 8
add a2 a1 a2
srli a2 a2 7
sw a2 0(x6) #storing rs1
addi x6 x6 4
jalr x0 x1 0

#all the functions going forth work in the same way, that is extracting the bits using and, slli and srli functions
storing_rs2:
lb a1 3(x5)
lb a2 2(x5)
andi a1 a1 0x01
andi a2 a2 0x0f0
slli a1 a1 8
add a1 a2 a1
srli a1 a1 4
sw a1 0(x6) #storing rs2
addi x6 x6 4
jalr x0 x1 0

storing_rd:
lb a1 1(x5)
lb a2 0(x5)
andi a2 a2 0x080
andi a1 a1 0x0f
slli a1 a1 8
add a1 a2 a1
srli a1 a1 7
sw a1 0(x6)
addi x6 x6 4
jalr x0 x1 0

storing_func3:
lb a1 1(x5)
andi a1 a1 0x70
srli a1 a1 4
sw a1 0(x6)
addi x6 x6 4
jalr x0 x1 0

storing_func7:
lb a1 3(x5)
andi a1 a1 0x0fe
slli a1 a1 1
sw a1 0(x6)
addi x6 x6 4
jalr x0 x1 0

immediate_slti_lw:
lb a1 3(x5)
lb a2 2(x5)
andi a2 a2 0x0f0
andi a1 a1 0x0ff
slli a1 a1 8
add a1 a1 a2
srli a1 a1 4
sw a1 0(x6)
addi x6 x6 4
jalr x0 x1 0

immediate_sw:
lb a1 1(x5)
lb a2 0(x5)
andi a2 a2 0x080
andi a1 a1 0x0f
slli a1 a1 8
add a1 a2 a1
srli a1 a1 7

lb a3 3(x5)
andi a3 a3 0x0fe

slli a3 a3 4
add a3 a3 a1
sw a3 0(x6)
addi x6 x6 4
jalr x0 x1 0

immediate_beq:
lb a1 3(x5)
andi a1 a1 0x080 #12th bit 0b 1000 0000 (0000)
slli a1 a1 4
lb a2 0(x5)
andi a2 a2 0x080 #11th bit 0b 1000 0000 (000)
slli a2 a2 3
add a1 a2 a1 #a1= 1100 0000 0000
lb a2 3(x5)
andi a2 a2 0x7e #0111|1110
slli a2 a2 3
add a1 a2 a1 # a1=11111111(0000)
lb a2 1(x5)
andi a2 a2 0x0f
add a1 a2 a1
sw a1 0(x6)
addi x6 x6 4
jalr x0 x1 0

exit: