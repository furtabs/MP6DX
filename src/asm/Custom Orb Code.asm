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
# Flip state + BGM without board tear-down
lis r3, 0x8014
ori r3, r3, 0xB99C      # mbChangeTimeSet
mtctr r3
bctrl

lis r3, 0x8016
ori r3, r3, 0xE20C      # mbMusBoardPlay
mtctr r3
bctrl

# Night has no day fog. Clear it first; LightSetHook puts the new fog back when the board uses one.
lis r4, 0x8026
ori r4, r4, 0x5B70      # GwSystem
lbz r0, 0x10(r4)
extrwi r3, r0, 1, 25    # curTime (1 = night)
cmpwi r3, 0
beq dayNightLightReset
lis r12, 0x8002
ori r12, r12, 0xA30C    # Hu3DFogClear
mtctr r12
bctrl

dayNightLightReset:
# Paired with LightSetHook. No-op on most boards; Clockwork Castle kills its day/night NPC so Set can rebuild it.
lis r3, 0x802C
ori r3, r3, 0x0D00      # LightResetHook
lwz r12, 0(r3)
cmplwi r12, 0
beq dayNightLightSet
mtctr r12
bctrl

dayNightLightSet:
# Board fog, background, and model light for the time bit MBTimeChange just wrote.
lis r3, 0x802C
ori r3, r3, 0x0CFC      # LightSetHook
lwz r12, 0(r3)
cmplwi r12, 0
beq dayNightCam
mtctr r12
bctrl

dayNightCam:
# Save camera (same pattern as last-5 mid-board effects)
lis r3, 0x8015
ori r3, r3, 0x0EAC      # mbCameraStackPush
mtctr r3
bctrl

# Board TimeChangeHook — sky/models/telop (StarMoveHook-style)
lis r3, 0x802C
ori r3, r3, 0x0D10      # TimeChangeHook
lwz r12, 0(r3)
cmplwi r12, 0
beq dayNightRestore
mtctr r12
bctrl

# mbMain cleanup after NextTime
lis r3, 0x8020
ori r3, r3, 0x67EC      # mbTelopTimeChangeKill
mtctr r3
bctrl
lis r3, 0x8015
ori r3, r3, 0x301C      # mbCameraMoveStop
mtctr r3
bctrl

dayNightRestore:
# Undo wipe + restore pre-hook camera (last5 pattern)
lis r3, 0x8015
ori r3, r3, 0x1400      # mbCameraFocusReset
mtctr r3
bctrl
li r3, 0
lis r12, 0x8015
ori r12, r12, 0x1058    # mbCameraStackPop
mtctr r12
bctrl
lis r3, 0x8020
ori r3, r3, 0x6B88      # mbWipeDissolveFadeIn
mtctr r3
bctrl

# Snap view back to the active player
lis r4, 0x8026
ori r4, r4, 0x5B70      # GwSystem
lbz r3, 0xA(r4)
extsb r3, r3
cmpwi r3, 0
blt dayNightSync
cmpwi r3, 4
bge dayNightSync
li r4, 0
lis r12, 0x8015
ori r12, r12, 0x3264    # mbCameraPlayerViewSetFast
mtctr r12
bctrl

dayNightSync:
# nextTime = curTime so mbMain won't replay the cinematic
lis r4, 0x8026
ori r4, r4, 0x5B70      # GwSystem
lbz r0, 0x10(r4)
extrwi r3, r0, 1, 25
rlwimi r0, r3, 7, 24, 24
stb r0, 0x10(r4)
extsh r0, r3
sth r0, -0x7468(r13)    # GwMgTime@sda21
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
