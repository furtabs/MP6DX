# Insert at 80175910

rlwinm r24, r0, 25, 31, 31
lis r15, 0x8026
ori r15, r15, 0x5B79
lbz r15, 0(r15)
cmpwi r15, 0x1
bne end
lhz r0, 48(r31)
cmplwi r0, 2
bne- end
lhz r4, 50(r31)
cmplwi r4, 65535
bne- end
li r0, 0x4
sth r0, 48(r31)

end:


