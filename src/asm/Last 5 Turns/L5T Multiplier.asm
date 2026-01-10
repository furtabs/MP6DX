# insert at 8015EDF0

lis r15, 0x8026
ori r15, r15, 0x5B74
lbz r16, 1(r15) # load last turn into memory
subi r17, r16, 5 # lastTurn before last5
lbz r15, 0(r15) # curTurn
cmpwi r15, r16 # if current turn is lower then last turn or equal
ble end # if lower not in last 5
mulli r30, r30, 3
end:
