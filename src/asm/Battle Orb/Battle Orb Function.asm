# Insert at 801F0160

lis r14, 0x8023
ori r14, r14, 0xF9C3
lbz r5, 0(r14)
cmpwi r5, 0x1
bne end
li r5, 0x0
stb r5, 0(r14)
lis r14, 0x801F
ori r14, r14, 0x0184
mtctr r14
bctr

end:
lwz r0, 0(r31)