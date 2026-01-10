# insert at 8015F1E8

lis r4, 0x8026
ori r4, r4, 0x5B74
lbz r18, 1(r4) # load last turn into memory
subi r19, r18, 5 # lastTurn before last5
lbz r4, 0(r4) # curTurn
cmpwi r4, r18 # if current turn is lower then last turn or equal
ble setl5 # if lower not in last 5
li r4, 0x6
b end

setl5:
li r4, 0x3

end:
