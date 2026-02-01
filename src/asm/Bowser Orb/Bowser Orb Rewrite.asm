# Insert at 801BE730

lwz r29, 0(r28) # og instr
lis r19, 0x8026

cmpwi r29, 0
beq p1Ori

cmpwi r29, 1
beq p2Ori

cmpwi r29, 2
beq p3Ori

p4Ori:
ori r19, r19, 0x5A72
b contStart

p3Ori:
ori r19, r19, 0x596A
b contStart

p2Ori:
ori r19, r19, 0x5862
b contStart

p1Ori:
ori r19, r19, 0x575A

contStart:
lbz r19, 0(r19)
cmpwi r19, 0xFF
bne og

reroll:
lis r29, 0x8003
ori r29, r29, 0xFCD4
mtctr r29
li r3, 4
bctrl # run frandmod

cmpw r3, r29 # if player id matches frandmod
beq reroll

cmpwi r3, 0 # if frandmod = 0
beq p1Target

cmpwi r3, 1 # if frandmod = 1
beq p2Target

cmpwi r3, 2 # if frandmod = 2
beq p3Target

cmpwi r3, 3 # if frandmod = 3
beq p4Target

p1Target:
li r29, 0
b end

p2Target:
li r29, 1
b end

p3Target:
li r29, 2
b end

p4Target:
li r29, 3
b end

og:
end:
li r20, 0
li r19, 0
