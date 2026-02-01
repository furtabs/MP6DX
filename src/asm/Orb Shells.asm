# insert at 8024ABA8

# load initial set addr
lis r25, 0x8024
ori r25, r25, 0xABA8
lwz r25, 0(r25)

# if orb is -0x6 (default green orbs)
cmpwi r21, 0x6
ble green

# if orb is 0x7 (cursed)
cmpwi r21, 0x7
beq red

# if orb is -0x11 (default yellow orbs)
cmpwi r21, 0x11
ble yellow

# if orb is -0x19 (default red orbs)
cmpwi r21, 0x19
ble red

# if orb is -0x1F
cmpwi r21, 0x1F
ble aqua

# if orb is -0x32
cmpwi r21, 0x32
# ble purple
ble aqua

# if orb is -0x34 (default green orbs)
cmpwi r21, 0x34
ble green

green:
lis r17, 0x000C
ori r17, r17, 0x0018
b end

yellow:
lis r17, 0x000C
ori r17, r17, 0x0019
b end

red:
lis r17, 0x000C
ori r17, r17, 0x001A
b end

aqua:
lis r17, 0x000C
ori r17, r17, 0x0022
b end

end:
lwz r17, 0 (r25)
