# insert at 801CCD88

lwz	r3, 0(r3)
lis r17, 0x000C
ori r17, r17, 0x0018
cmpw r17, r3
beq cont

lis r17, 0x000C
ori r17, r17, 0x0019
cmpw r17, r3
beq cont

lis r17, 0x000C
ori r17, r17, 0x001A
cmpw r17, r3
beq cont

lis r17, 0x000C
ori r17, r17, 0x001B
cmpw r17, r3
beq cont

lis r17, 0x0000
cmpw r17, r3
beq cont

b end

cont:
# if orb is -0x6 (default green orbs)
cmpwi r21, 0x0
beq green
cmpwi r21, 0x1
beq green
cmpwi r21, 0x2
beq green
cmpwi r21, 0x3
beq green
cmpwi r21, 0x4
beq green
cmpwi r21, 0x5
beq green
cmpwi r21, 0x6
beq green

# if orb is 0x7 (cursed)
cmpwi r21, 0x7
beq red

# if orb is -0x11 (default yellow orbs)
cmpwi r21, 0xA
beq yellow
cmpwi r21, 0xB
beq yellow
cmpwi r21, 0xC
beq yellow
cmpwi r21, 0xD
beq yellow
cmpwi r21, 0xF
beq yellow
cmpwi r21, 0x10
beq yellow
cmpwi r21, 0x11
beq yellow

# if orb is -0x19 (default red orbs)
cmpwi r21, 0x14
beq red
cmpwi r21, 0x15
beq red
cmpwi r21, 0x16
beq red
cmpwi r21, 0x17
beq red
cmpwi r21, 0x18
beq red
cmpwi r21, 0x19
beq red

# if orb is -0x1F
cmpwi r21, 0x1E
beq aqua
cmpwi r21, 0x1F
beq aqua

# if orb is -0x32
cmpwi r21, 0x29
beq purple
cmpwi r21, 0x2A
beq purple
cmpwi r21, 0x2B
beq purple
cmpwi r21, 0x2C
beq purple
cmpwi r21, 0x2E
beq purple
cmpwi r21, 0x32
beq purple

# if orb is -0x34 (default green orbs)
cmpwi r21, 0x33
beq green
cmpwi r21, 0x34
beq green

b end

green:
lis r17, 0x000C
ori r17, r17, 0x0018
b end2

yellow:
lis r17, 0x000C
ori r17, r17, 0x0019
b end2

red:
lis r17, 0x000C
ori r17, r17, 0x001A
b end2

aqua:
lis r17, 0x000C
ori r17, r17, 0x001B
b end2

purple:
lis r17, 0x000C
ori r17, r17, 0x005E
b end2

end2:
mr r3, r17
end: