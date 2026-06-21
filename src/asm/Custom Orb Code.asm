# Insert at 801d644c

cmpwi r4, 0x578 #Compare r4 with (Capsule used ID multiplied by 0x1C) 
beq dayNightOrb

cmpwi r4, 0x594 #Compare r4 with (Capsule used ID multiplied by 0x1C)
beq chompyOrb

cmpwi r4, 0x5B0 #Compare r4 with (Capsule used ID multiplied by 0x1C)
beq wackyWatchOrb

cmpwi r4, 0x5CC #Compare r4 with (Capsule used ID multiplied by 0x1C)
beq battleOrb

b notCustomOrb

dayNightOrb:
lis r3, 0x8014 # MBTimeRefresh@h
ori r3, r3, 0xBA78 # MBTimeRefresh@l
mtctr r3
bctrl # run function
b finishCustomCapsule

chompyOrb:
lis r3, 0x802C # StarMoveHook@h
ori r3, r3, 0x0E6C # StarMoveHook@l
lwz r3, 0(r3) # Load pointer StarMoveHook to StarMoveHook
mtctr r3
bctrl # run function
b finishCustomCapsule

wackyWatchOrb:
lis r3, 0x8026 # MaxTurn byte
ori r3, r3, 0x5B74 # MaxTurn byte
lbz r19, 1(r3) # load in MaxTurn to r19
subi r19, r19, 5 # right before last 5
stb r19, 1(r3)
b finishCustomCapsule

zoomShroomOrb:
lis r3, 0x8023
ori r3, r3, 0xF9C0
li r19, 0x1
stb r19, 0(r3) # Load 0x1 (zoomShroomOrb) state into TabiOrbFlag

lis r3, 0x8019 # MBCapsuleKinokoExec@h
ori r3, r3, 0xB4F4 # MBCapsuleKinokoExec@l
mtctr r3
bctrl # run function
b finishCustomCapsule

battleOrb:
lis r3, 0x8023
ori r3, r3, 0xF9C3
li r19, 0x1
stb r19, 0(r3) # Load 0x1 (toForceBattle) state into TabiBattleFlag
b finishCustomCapsule

finishCustomCapsule:
lis r3, 0x801D
ori r3, r3, 0x6518
mtctr r3
bctr # Go to end of Orb Function

notCustomOrb:
lis r12, 0x8023
ori r12, r12, 0xF9C0
li r0, 0xFF
stb r0, 0(r12) # Load CLEAR state back into custom orb
lwz r3, 0(r3) # Execute original instruction
lis r12, 0x801D
ori r12, r12, 0x6450
mtctr r12
bctr