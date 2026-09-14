# insert at 801CAAD8

cmpwi r3, 0x0
beq green
cmpwi r3, 0x1
beq green
cmpwi r3, 0x2
beq green
cmpwi r3, 0x3
beq green
cmpwi r3, 0x4
beq green
cmpwi r3, 0x5
beq green
cmpwi r3, 0x6
beq green
cmpwi r3, 0x7
beq yellow
cmpwi r3, 0xA
beq yellow
cmpwi r3, 0xB
beq yellow
cmpwi r3, 0xC
beq yellow
cmpwi r3, 0xD
beq yellow
cmpwi r3, 0xF
beq yellow
cmpwi r3, 0x10
beq yellow
cmpwi r3, 0x11
beq yellow
cmpwi r3, 0x14
beq red
cmpwi r3, 0x15
beq red
cmpwi r3, 0x16
beq red
cmpwi r3, 0x17
beq red
cmpwi r3, 0x18
beq red
cmpwi r3, 0x19
beq red
cmpwi r3, 0x1E
beq aqua
cmpwi r3, 0x1F
beq aqua
cmpwi r3, 0x29
beq purple
cmpwi r3, 0x2A
beq purple
cmpwi r3, 0x2B
beq purple
cmpwi r3, 0x2C
beq purple
cmpwi r3, 0x2E
beq purple
cmpwi r3, 0x32
beq purple
cmpwi r3, 0x33
beq green
cmpwi r3, 0x34
beq green
cmpwi r21, 0x35
beq purple

b end

green:
li r3, 0
b end

yellow:
li r3, 1
b end

red:
li r3, 2
b end

aqua:
li r3, 3
b end

purple:
li r3, 3

end: