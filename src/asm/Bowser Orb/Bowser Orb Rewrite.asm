# Insert at 801BE730

lwz r3, 0(r28)          # og: player who triggered Bowser
mr r19, r3              # keep that player across the dice check

lis r29, 0x8018
ori r29, r29, 0x7004    # MBSaiResultGet
mtctr r29
bctrl
cmpwi r3, 0
bne og                  # dice already rolled → Bowser space, leave player alone

reroll:
lis r29, 0x8003
ori r29, r29, 0xFCD4    # frandmod
mtctr r29
li r3, 4
bctrl
cmpw r3, r19            # don't target the player who used the orb
beq reroll

mr r29, r3
stw r3, 0(r28)          # KoopaMain keeps reading this player
b end

og:
mr r3, r19
mr r29, r3
end:
li r20, 0
li r19, 0
