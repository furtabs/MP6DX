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

# Clockwork Castle's sun direction and map brightness are day/night model files.
# LightSetHook only rebuilds Bowser. Swap the castle meshes while the wipe is still out.
lis r3, 0x802C
ori r3, r3, 0x0CFC      # LightSetHook
lwz r12, 0(r3)
cmplwi r12, 0
beq dayNightOther
lwz r4, 0x40(r12)
lis r3, 0x3880
ori r3, r3, 0x1000      # li r4, 0x1000 just before MBSNpcCreate
cmpw r4, r3
bne dayNightOther
lwz r4, 0x44(r12)
rlwinm r4, r4, 0, 6, 29
andis. r0, r4, 0x0200
beq dayNightBlPos
addis r4, r4, -0x400
dayNightBlPos:
add r4, r4, r12
addi r4, r4, 0x44
lis r3, 0x8015
ori r3, r3, 0xF2B0      # MBSNpcCreate
cmpw r4, r3
bne dayNightOther

lis r4, 0x8026
ori r4, r4, 0x5B70      # GwSystem
lbz r0, 0x10(r4)
extrwi r3, r0, 1, 25    # curTime (1 = night)
cmpwi r3, 0
bne dayNightDirNight
lis r3, 0xE1
b dayNightDirRead
dayNightDirNight:
lis r3, 0xE2
dayNightDirRead:
lis r12, 0x8000
ori r12, r12, 0x78C8    # HuDataDirRead
mtctr r12
bctrl
cmpwi r3, 0
beq dayNightTelop

# Path links, gates, and the next-space arrows.
lis r12, 0x8020
ori r12, r12, 0x0524    # MBGateClose
mtctr r12
bctrl
lis r12, 0x8017
ori r12, r12, 0x4FA0    # MBMasuClose
mtctr r12
bctrl
lis r4, 0x8026
ori r4, r4, 0x5B70
lbz r0, 0x10(r4)
extrwi r3, r0, 1, 25
cmpwi r3, 0
bne dayNightMasuNight
lis r3, 0xE1
b dayNightMasuInit
dayNightMasuNight:
lis r3, 0xE2
dayNightMasuInit:
lis r12, 0x8017
ori r12, r12, 0x4EBC    # MBMasuInit
mtctr r12
bctrl

# Day/night scenery, then the path meshes. Offsets are from TimeChangeHook.
lis r3, 0x802C
ori r3, r3, 0x0D10
lwz r12, 0(r3)
addis r3, r12, -1
addi r3, r3, 0x7B60     # scenery kill A
mtctr r3
bctrl
lis r3, 0x802C
ori r3, r3, 0x0D10
lwz r12, 0(r3)
subi r3, r12, 0x6BD8    # scenery kill B
mtctr r3
bctrl
lis r3, 0x802C
ori r3, r3, 0x0D10
lwz r12, 0(r3)
subi r3, r12, 0x527C    # scenery kill C
mtctr r3
bctrl
lis r3, 0x802C
ori r3, r3, 0x0D10
lwz r12, 0(r3)
subi r3, r12, 0x464C    # scenery kill D
mtctr r3
bctrl
lis r3, 0x802C
ori r3, r3, 0x0D10
lwz r12, 0(r3)
subi r3, r12, 0xC1C     # path-mesh kill
mtctr r3
bctrl

# Main board mesh. The kill routine's lis/addi still point at its model id.
lis r3, 0x802C
ori r3, r3, 0x0D10
lwz r12, 0(r3)
addis r4, r12, -1
addi r4, r4, 0x5428
lwz r5, 0(r4)
lwz r6, 4(r4)
rlwinm r5, r5, 16, 0, 15
extsh r6, r6
add r4, r5, r6
lha r3, 0(r4)
cmpwi r3, 0
blt dayNightMapCreate
lis r12, 0x8016
ori r12, r12, 0x9288    # MBModelKill
mtctr r12
bctrl

dayNightMapCreate:
lis r4, 0x8026
ori r4, r4, 0x5B70
lbz r0, 0x10(r4)
extrwi r3, r0, 1, 25
cmpwi r3, 0
bne dayNightMapNight
lis r3, 0xE1
b dayNightMapNew
dayNightMapNight:
lis r3, 0xE2
dayNightMapNew:
ori r3, r3, 1           # board mesh for this time
li r4, 0
li r5, 0
lis r12, 0x8016
ori r12, r12, 0x8DC4    # MBModelCreate
mtctr r12
bctrl
sth r3, 8(r1)
lis r3, 0x802C
ori r3, r3, 0x0D10
lwz r12, 0(r3)
addis r4, r12, -1
addi r4, r4, 0x5428
lwz r5, 0(r4)
lwz r6, 4(r4)
rlwinm r5, r5, 16, 0, 15
extsh r6, r6
add r4, r5, r6
lha r3, 8(r1)
sth r3, 0(r4)
extsh r3, r3
cmpwi r3, 0
blt dayNightScenery
lis r4, 0x4000
addi r4, r4, 1
lis r12, 0x8016
ori r12, r12, 0x9BC4    # MBModelAttrSet
mtctr r12
bctrl
lha r3, 8(r1)
lis r4, 0xBF80          # -1.0 cull
stw r4, 0xC(r1)
lfs f1, 0xC(r1)
lis r12, 0x8016
ori r12, r12, 0x9E48    # MBModelCullRadiusSet
mtctr r12
bctrl
lha r3, 8(r1)
lis r4, 0x3F80          # 1.0
stw r4, 0xC(r1)
lfs f1, 0xC(r1)
lis r12, 0x8016
ori r12, r12, 0xA980    # MBMotionSpeedSet
mtctr r12
bctrl
lha r3, 8(r1)
lis r4, 0
stw r4, 0xC(r1)
lfs f1, 0xC(r1)
lis r12, 0x8016
ori r12, r12, 0xA858    # MBMotionTimeSet
mtctr r12
bctrl
lha r3, 8(r1)
lis r4, 0x4000
addi r4, r4, 1
lis r12, 0x8016
ori r12, r12, 0x9BC4    # MBModelAttrSet
mtctr r12
bctrl

dayNightScenery:
lis r3, 0x802C
ori r3, r3, 0x0D10
lwz r12, 0(r3)
addis r3, r12, -1
addi r3, r3, 0x6758     # scenery create A
mtctr r3
bctrl
lis r3, 0x802C
ori r3, r3, 0x0D10
lwz r12, 0(r3)
addis r3, r12, -1
addi r3, r3, 0x7C08     # scenery create B
mtctr r3
bctrl
lis r3, 0x802C
ori r3, r3, 0x0D10
lwz r12, 0(r3)
subi r3, r12, 0x6B44    # scenery create C
mtctr r3
bctrl
lis r3, 0x802C
ori r3, r3, 0x0D10
lwz r12, 0(r3)
subi r3, r12, 0x51C0    # scenery create D
mtctr r3
bctrl
lis r3, 0x802C
ori r3, r3, 0x0D10
lwz r12, 0(r3)
subi r3, r12, 0x2110    # path-mesh create
mtctr r3
bctrl

lis r3, 0x802C
ori r3, r3, 0x0D10      # TimeChangeHook
lwz r12, 0(r3)
subi r3, r12, 0x120     # castle light-model kill
mtctr r3
bctrl

lis r3, 0x802C
ori r3, r3, 0x0D10
lwz r12, 0(r3)
subi r12, r12, 0xB3C    # castle light-model create
lwz r3, 0x958(r12)
lwz r4, 0x95C(r12)
rlwinm r3, r3, 16, 0, 15
extsh r4, r4
add r3, r3, r4
lwz r3, 0x40(r3)        # clock model the kill routine does not free
extsh r3, r3
cmpwi r3, 0
blt dayNightClockCreate
lis r12, 0x8016
ori r12, r12, 0x9288    # MBModelKill
mtctr r12
bctrl

dayNightClockCreate:
lis r3, 0x802C
ori r3, r3, 0x0D10
lwz r12, 0(r3)
subi r12, r12, 0xB3C
mtctr r12
bctrl

lis r4, 0x8026
ori r4, r4, 0x5B70
lbz r0, 0x10(r4)
extrwi r3, r0, 1, 25
cmpwi r3, 0
bne dayNightDirCloseNight
lis r3, 0xE1
b dayNightDirClose
dayNightDirCloseNight:
lis r3, 0xE2
dayNightDirClose:
lis r12, 0x8000
ori r12, r12, 0x97F4    # HuDataDirClose
mtctr r12
bctrl

dayNightTelop:
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
stwu r1, -0x60(r1)
mflr r0
stw r0, 0x64(r1)
stw r31, 0x4c(r1)
stw r30, 0x48(r1)
stw r29, 0x44(r1)
stw r28, 0x40(r1)
# Host fly-over is only on Towering Treetop and E. Gadd's Garage.
lis r3, 0x8026
ori r3, r3, 0x5B70      # GwSystem
lbz r4, 8(r3)
clrlwi r4, r4, 27
cmpwi r4, 2
bge chompyHookOnly
lbz r4, 0xA(r3)
extsb r4, r4
stw r4, 0x34(r1)
lbz r0, 0x10(r3)
extrwi r0, r0, 1, 25
stw r0, 0x38(r1)
lis r3, 0x802C
ori r3, r3, 0x0E6C      # StarMoveHook
lwz r3, 0(r3)
cmplwi r3, 0
beq chompyDone
lwz r3, -0x6860(r13)    # StarMasuNext, still the old space
extsh r31, r3
cmpwi r31, 0
blt chompyHookOnly
stw r31, 0x30(r1)
mr r3, r31
addi r4, r1, 8
lis r12, 0x8017
ori r12, r12, 0x7948    # MBMasuPosGet
mtctr r12
bctrl
lis r3, 1
addi r3, r3, 0x1c
lis r12, 0x8006
ori r12, r12, 0xA1C4    # _SetFlag
mtctr r12
bctrl
lis r3, 0x8018
ori r3, r3, 0x399C      # StarPauseHook
lis r12, 0x8019
ori r12, r12, 0x1D14    # MBPauseHookPush
mtctr r12
bctrl
lis r12, 0x8020
ori r12, r12, 0x68F8    # MBWipeFadeOut
mtctr r12
bctrl
bl chompyCallHook
lwz r31, 0x30(r1)
lwz r3, -0x6860(r13)
extsh r30, r3
li r29, 0
chompyKillOld:
slwi r0, r29, 2
lis r3, 0x802B
ori r3, r3, 0xA368
lwzx r3, r3, r0
cmplwi r3, 0
beq chompyKillNext
lwz r4, 0x5c(r3)
lwz r0, 0xc(r4)
cmpw r0, r31
bne chompyKillNext
mr r3, r29
lis r12, 0x8017
ori r12, r12, 0xF6E4    # MBStarObjKill
mtctr r12
bctrl
chompyKillNext:
addi r29, r29, 1
cmpwi r29, 0x3e7
blt chompyKillOld
li r3, 2
lis r12, 0x8000
ori r12, r12, 0xE26C    # HuPrcSleep
mtctr r12
bctrl
cmpw r30, r31
beq chompyNoMove
mr r3, r30
addi r4, r1, 0x14
lis r12, 0x8017
ori r12, r12, 0x7948    # MBMasuPosGet
mtctr r12
bctrl
li r3, -1
stw r3, 0x2c(r1)
li r29, 0
chompyFind:
slwi r0, r29, 2
lis r3, 0x802B
ori r3, r3, 0xA368
lwzx r3, r3, r0
cmplwi r3, 0
beq chompyFindNext
lwz r4, 0x5c(r3)
lwz r0, 0xc(r4)
cmpw r0, r30
bne chompyFindNext
stw r29, 0x2c(r1)
mr r3, r29
li r4, 0
lis r12, 0x8017
ori r12, r12, 0xF720    # MBStarObjDispSet
mtctr r12
bctrl
b chompyHost
chompyFindNext:
addi r29, r29, 1
cmpwi r29, 0x3e7
blt chompyFind
chompyHost:
lis r3, 0x8024
ori r3, r3, 0x7F84      # StarMasuGuidePos
li r4, 4
addi r5, r1, 0x20
lis r12, 0x8014
ori r12, r12, 0xDCDC    # MBPosNormto3D
mtctr r12
bctrl
addi r3, r1, 0x20
addi r4, r13, -0x7A0F   # StarMasuGuideMotTbl
li r5, 1
li r6, 0
li r7, 1
lis r12, 0x801E
ori r12, r12, 0xCBC4    # MBGuideCreateFlag
mtctr r12
bctrl
stw r3, -0x6868(r13)    # StarGuideObj
cmplwi r3, 0
beq chompyHudOff
li r4, 1
lis r12, 0x801E
ori r12, r12, 0xCFA8    # MBGuideMotionNextSet
mtctr r12
bctrl
chompyHudOff:
li r3, 0
lis r12, 0x8018
ori r12, r12, 0xD3E8    # MBStatusDispForceSetAll
mtctr r12
bctrl
lis r12, 0x8020
ori r12, r12, 0x6988    # MBWipeFadeIn
mtctr r12
bctrl
li r3, 1
li r4, 0xc
li r5, 0x7f
li r6, 0
lis r12, 0x8016
ori r12, r12, 0xE338    # MBMusPlay
mtctr r12
bctrl
li r3, 0x3b8
lis r12, 0x8017
ori r12, r12, 0x0980    # MBAudGuidePlay
mtctr r12
bctrl
lwz r3, -0x6868(r13)
cmplwi r3, 0
beq chompyWin1
li r4, 0xc
li r5, 1
lis r12, 0x801E
ori r12, r12, 0xD064    # MBGuideMotionShiftSet
mtctr r12
bctrl
chompyWin1:
li r3, 4
lwz r4, 0x38(r1)
addis r4, r4, 0x27
addi r4, r4, 0xc
li r5, -1
lis r12, 0x8016
ori r12, r12, 0xBE40    # MBWinCreateTime
mtctr r12
bctrl
mr r28, r3
extsh r3, r28
lis r12, 0x8016
ori r12, r12, 0xCB24    # MBWinPause
mtctr r12
bctrl
addi r3, r1, 8
addi r4, r1, 0x14
li r5, 0x78
lis r12, 0x8017
ori r12, r12, 0x26A4    # MBStarScrollExec
mtctr r12
bctrl
extsh r3, r28
lis r12, 0x8016
ori r12, r12, 0xBFE8    # MBWinKill
mtctr r12
bctrl
lwz r29, 0x2c(r1)
cmpwi r29, 0
blt chompyWin2
mr r3, r29
li r4, 1
lis r12, 0x8017
ori r12, r12, 0xF720    # MBStarObjDispSet
mtctr r12
bctrl
slwi r0, r29, 2
lis r3, 0x802B
ori r3, r3, 0xA368
lwzx r3, r3, r0
cmplwi r3, 0
beq chompyWin2
lwz r31, 0x5c(r3)
li r3, 0x447
lis r12, 0x8017
ori r12, r12, 0x0454    # MBAudFXPlay
mtctr r12
bctrl
li r3, 0x448
lis r12, 0x8017
ori r12, r12, 0x0454    # MBAudFXPlay
mtctr r12
bctrl
li r3, 1
lbz r0, 0(r31)
rlwimi r0, r3, 6, 25, 25
stb r0, 0(r31)
li r0, 0
sth r0, 0x16(r31)
sth r0, 0x20(r31)
stb r0, 0x14(r31)
li r3, 1
lbz r0, 0(r31)
rlwimi r0, r3, 3, 28, 28
stb r0, 0(r31)
li r0, 0
stw r0, 0x3c(r1)
lfs f0, 0x3c(r1)
stfs f0, 0x40(r31)
li r3, 1
lbz r0, 0(r31)
rlwimi r0, r3, 5, 26, 26
stb r0, 0(r31)
li r3, 1
lbz r0, 0(r31)
rlwimi r0, r3, 2, 29, 29
stb r0, 0(r31)
lbz r0, 0(r31)
rlwinm r0, r0, 28, 31, 31
cmplwi r0, 1
bne chompyWait
lwz r3, 0x28(r31)
extsh r3, r3
cmpwi r3, 0
blt chompyWait
li r4, 1
lis r12, 0x8016
ori r12, r12, 0x94A4    # MBModelDispSet
mtctr r12
bctrl
chompyWait:
lis r12, 0x8000
ori r12, r12, 0xE2EC    # HuPrcVSleep
mtctr r12
bctrl
lbz r0, 0x14(r31)
extsb r0, r0
cmpwi r0, 1
bne chompyWait
li r3, 0x14
lis r12, 0x8000
ori r12, r12, 0xE26C    # HuPrcSleep
mtctr r12
bctrl
chompyWin2:
li r3, 0x3b8
lis r12, 0x8017
ori r12, r12, 0x0980    # MBAudGuidePlay
mtctr r12
bctrl
lwz r3, -0x6868(r13)
cmplwi r3, 0
beq chompyWin2Mes
li r4, 0xc
li r5, 1
lis r12, 0x801E
ori r12, r12, 0xD064    # MBGuideMotionShiftSet
mtctr r12
bctrl
chompyWin2Mes:
li r3, 4
lwz r4, 0x38(r1)
addis r4, r4, 0x27
addi r4, r4, 0xe
li r5, -1
lis r12, 0x8016
ori r12, r12, 0xBE40    # MBWinCreateTime
mtctr r12
bctrl
lis r12, 0x8016
ori r12, r12, 0xCDA8    # MBTopWinWait
mtctr r12
bctrl
li r3, 1
li r4, 0x3e8
lis r12, 0x8016
ori r12, r12, 0xE640    # MBMusFadeOutSpeed
mtctr r12
bctrl
chompyNoMove:
lis r12, 0x8020
ori r12, r12, 0x68F8    # MBWipeFadeOut
mtctr r12
bctrl
lwz r3, 0x34(r1)
cmpwi r3, 0
blt chompyKillHost
cmpwi r3, 4
bge chompyKillHost
li r4, 0
lis r12, 0x8018
ori r12, r12, 0xD114    # MBStatusDispForceSet
mtctr r12
bctrl
lwz r3, 0x34(r1)
lis r12, 0x8015
ori r12, r12, 0x154C    # MBCameraFocusPlayerSet
mtctr r12
bctrl
lis r12, 0x8015
ori r12, r12, 0x2FC4    # MBCameraMotionWait
mtctr r12
bctrl
chompyKillHost:
li r3, 1
lis r12, 0x8018
ori r12, r12, 0xD3E8    # MBStatusDispForceSetAll
mtctr r12
bctrl
li r3, 1
lis r12, 0x8018
ori r12, r12, 0xD3E8
mtctr r12
bctrl
lwz r3, -0x6868(r13)
cmplwi r3, 0
beq chompyMusBack
lis r12, 0x801E
ori r12, r12, 0xCC84    # MBGuideKill
mtctr r12
bctrl
li r0, 0
stw r0, -0x6868(r13)
chompyMusBack:
li r3, 0x3c
lis r12, 0x8000
ori r12, r12, 0xE26C    # HuPrcSleep
mtctr r12
bctrl
lis r12, 0x8016
ori r12, r12, 0xE20C    # MBMusBoardPlay
mtctr r12
bctrl
lis r3, 0x8018
ori r3, r3, 0x399C      # StarPauseHook
lis r12, 0x8019
ori r12, r12, 0x1D38    # MBPauseHookPop
mtctr r12
bctrl
lis r12, 0x8020
ori r12, r12, 0x6988    # MBWipeFadeIn
mtctr r12
bctrl
lis r3, 1
addi r3, r3, 0x1c
lis r12, 0x8006
ori r12, r12, 0xA268    # _ClearFlag
mtctr r12
bctrl
b chompyDone
chompyHookOnly:
bl chompyCallHook
chompyDone:
lwz r28, 0x40(r1)
lwz r29, 0x44(r1)
lwz r30, 0x48(r1)
lwz r31, 0x4c(r1)
lwz r0, 0x64(r1)
mtlr r0
addi r1, r1, 0x60
b finishCustomCapsule

chompyCallHook:
stwu r1, -0x10(r1)
mflr r0
stw r0, 0x14(r1)
lis r3, 0x802C
ori r3, r3, 0x0E6C      # StarMoveHook
lwz r12, 0(r3)
cmplwi r12, 0
beq chompyCallHookOut
mtctr r12
bctrl
chompyCallHookOut:
lwz r0, 0x14(r1)
mtlr r0
addi r1, r1, 0x10
blr

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

# Boards 0-4. Dirs run D7/D8, D9/DA, DB/DC, DD/DE, DF/E0.
dayNightOther:
stwu r1, -0x30(r1)
mflr r0
stw r0, 0x34(r1)
stw r31, 0x2c(r1)
stw r30, 0x28(r1)
stw r29, 0x24(r1)
stw r28, 0x20(r1)
lis r4, 0x8026
ori r4, r4, 0x5B70      # GwSystem
lbz r3, 8(r4)
clrlwi r3, r3, 0x1b     # board index
cmpwi r3, 5
bge dayNightOtherDone
stw r3, 8(r1)
bl dayNightBoardDir
stw r3, 0xC(r1)
bl dayNightOpenMasu
cmpwi r3, 0
beq dayNightOtherDone
lwz r29, 8(r1)
lwz r31, 0xC(r1)
cmpwi r29, 0
beq dayNightMesh0
cmpwi r29, 1
beq dayNightMesh1
cmpwi r29, 2
beq dayNightMesh2
cmpwi r29, 3
beq dayNightMesh3
b dayNightMesh4

dayNightMesh0:
lis r3, 0x802C
ori r3, r3, 0x0D10
lwz r12, 0(r3)
lwz r5, -0xA60(r12)
lwz r6, -0xA5C(r12)
rlwinm r5, r5, 16, 0, 15
extsh r6, r6
add r30, r5, r6         # map model work
stw r30, 0x1c(r1)
mr r3, r30
li r4, 4
mr r5, r31
bl dayNightReloadOne
lis r3, 0x802C
ori r3, r3, 0x0D10
lwz r12, 0(r3)
lwz r5, -0x904(r12)
lwz r6, -0x900(r12)
rlwinm r5, r5, 16, 0, 15
extsh r6, r6
add r4, r5, r6
lis r3, 0x8026
ori r3, r3, 0x5B70
lbz r0, 0x10(r3)
extrwi r0, r0, 1, 25    # night list is the second pointer
slwi r0, r0, 2
lwzx r29, r4, r0
stw r29, 0x18(r1)
li r28, 0
dayNightW01Loop:
lwz r29, 0x18(r1)
slwi r0, r28, 2
lwzx r4, r29, r0
cmplwi r4, 0
beq dayNightW01File5
clrlwi r4, r4, 0x10
slwi r0, r28, 1
addi r0, r0, 2
lwz r3, 0x1c(r1)
add r3, r3, r0
lwz r5, 0xC(r1)
stw r28, 0x14(r1)
bl dayNightReloadOne
lwz r28, 0x14(r1)
addi r28, r28, 1
b dayNightW01Loop
dayNightW01File5:
slwi r0, r28, 1
addi r0, r0, 2
lwz r3, 0x1c(r1)
add r3, r3, r0
li r4, 5
lwz r5, 0xC(r1)
stw r28, 0x14(r1)
bl dayNightReloadOne
lwz r28, 0x14(r1)
lwz r3, 0x1c(r1)
slwi r0, r28, 1
addi r0, r0, 2
lhax r3, r3, r0
cmpwi r3, 0
blt dayNightOtherClose
li r4, 1
lis r12, 0x8016
ori r12, r12, 0x9530    # MBModelLayerSet
mtctr r12
bctrl
b dayNightOtherClose

dayNightMesh1:
lis r3, 0x802C
ori r3, r3, 0x0D10
lwz r12, 0(r3)
lwz r5, -0x2E68(r12)
lwz r6, -0x2E64(r12)
rlwinm r5, r5, 16, 0, 15
extsh r6, r6
add r3, r5, r6
li r4, 3
mr r5, r31
bl dayNightReloadOne
b dayNightOtherClose

dayNightMesh2:
lis r3, 0x802C
ori r3, r3, 0x0D10
lwz r12, 0(r3)
lwz r5, -0x1B18(r12)
lwz r6, -0x1B14(r12)
rlwinm r5, r5, 16, 0, 15
extsh r6, r6
add r3, r5, r6
li r4, 1
mr r5, r31
bl dayNightReloadOne
b dayNightOtherClose

dayNightMesh3:
lis r3, 0x802C
ori r3, r3, 0x0D10
lwz r12, 0(r3)
lwz r5, -0x1334(r12)
lwz r6, -0x1330(r12)
rlwinm r5, r5, 16, 0, 15
extsh r6, r6
add r3, r5, r6
li r4, 3
mr r5, r31
bl dayNightReloadOne
b dayNightOtherClose

dayNightMesh4:
lis r3, 0x802C
ori r3, r3, 0x0D10
lwz r12, 0(r3)
lwz r5, -0x1F10(r12)
lwz r6, -0x1F0C(r12)
rlwinm r5, r5, 16, 0, 15
extsh r6, r6
add r3, r5, r6
li r4, 3
mr r5, r31
bl dayNightReloadOne

dayNightOtherClose:
lwz r3, 0xC(r1)
lis r12, 0x8000
ori r12, r12, 0x97F4    # HuDataDirClose
mtctr r12
bctrl

dayNightOtherDone:
lwz r28, 0x20(r1)
lwz r29, 0x24(r1)
lwz r30, 0x28(r1)
lwz r31, 0x2c(r1)
lwz r0, 0x34(r1)
mtlr r0
addi r1, r1, 0x30
b dayNightTelop

# r3 = board 0-4. Returns that board's directory for the current time.
dayNightBoardDir:
slwi r3, r3, 1
addi r3, r3, 0xD7
lis r4, 0x8026
ori r4, r4, 0x5B70
lbz r0, 0x10(r4)
extrwi r0, r0, 1, 25
add r3, r3, r0
slwi r3, r3, 16
blr

# r3 = directory. Opens it and reloads the path. Returns 1, or 0 if the open failed.
dayNightOpenMasu:
stwu r1, -0x10(r1)
mflr r0
stw r0, 0x14(r1)
stw r31, 0xC(r1)
mr r31, r3
lis r12, 0x8000
ori r12, r12, 0x78C8    # HuDataDirRead
mtctr r12
bctrl
cmpwi r3, 0
beq dayNightOpenFail
lis r12, 0x8020
ori r12, r12, 0x0524    # MBGateClose
mtctr r12
bctrl
lis r12, 0x8017
ori r12, r12, 0x4FA0    # MBMasuClose
mtctr r12
bctrl
mr r3, r31
lis r12, 0x8017
ori r12, r12, 0x4EBC    # MBMasuInit
mtctr r12
bctrl
li r3, 1
b dayNightOpenOut
dayNightOpenFail:
li r3, 0
dayNightOpenOut:
lwz r31, 0xC(r1)
lwz r0, 0x14(r1)
mtlr r0
addi r1, r1, 0x10
blr

# r3 = halfword slot, r4 = file number, r5 = directory.
dayNightReloadOne:
stwu r1, -0x20(r1)
mflr r0
stw r0, 0x24(r1)
stw r31, 0x1C(r1)
stw r30, 0x18(r1)
stw r29, 0x14(r1)
mr r31, r3
mr r30, r4
mr r29, r5
lha r3, 0(r31)
cmpwi r3, 0
blt dayNightReloadNew
lis r12, 0x8016
ori r12, r12, 0x9288    # MBModelKill
mtctr r12
bctrl
dayNightReloadNew:
mr r3, r29
or r3, r3, r30
li r4, 0
li r5, 0
lis r12, 0x8016
ori r12, r12, 0x8DC4    # MBModelCreate
mtctr r12
bctrl
sth r3, 0(r31)
extsh r3, r3
cmpwi r3, 0
blt dayNightReloadOut
lis r4, 0x4000
addi r4, r4, 1
lis r12, 0x8016
ori r12, r12, 0x9BC4    # MBModelAttrSet
mtctr r12
bctrl
dayNightReloadOut:
lwz r29, 0x14(r1)
lwz r30, 0x18(r1)
lwz r31, 0x1C(r1)
lwz r0, 0x24(r1)
mtlr r0
addi r1, r1, 0x20
blr
