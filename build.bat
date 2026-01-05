@echo off

mkdir tmp
mkdir dist
mkdir dist\store

"compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/CPU Can Use All Orbs.asm" && python "compiler/gecko.py" a.out 801C986C tmp/cpu_can_use_all_orbs.txt1
"compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Custom Orb Code.asm" && python "compiler/gecko.py" a.out 801D644C tmp/custom_orb_code.txt1
"compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Orb Shells.asm" && python "compiler/gecko.py" a.out 8024ABB8 tmp/orb_shells.txt1 -ow

"compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Bowser Orb/Bowser Orb Rewrite.asm" && python "compiler/gecko.py" a.out 801BE730 tmp/bowser_orb_rewrite.txt1
"compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Bowser Orb/Bowser Orb Pointer.asm" && python "compiler/gecko.py" a.out 80249B64 tmp/bowser_orb_pointer.txt1 -ow

"compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Chance Orb/Chance Orb Pointer.asm" && python "compiler/gecko.py" a.out 80249B3C tmp/chance_orb_pointer.txt1 -ow

"compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Chomp Call Orb/Chomp Call Orb Pointer.asm" && python "compiler/gecko.py" a.out 80249CA4 tmp/chomp_call_orb_pointer.txt1 -ow

"compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/DK Orb/DK Orb Pointer.asm" && python "compiler/gecko.py" a.out 80249B8C tmp/dk_orb_pointer.txt1 -ow

"compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Duel Orb/Duel Orb Fixer.asm" && python "compiler/gecko.py" a.out 801B9C60 tmp/duel_orb_fixer.txt1
"compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Duel Orb/Duel Orb Pointer.asm" && python "compiler/gecko.py" a.out 80249B14 tmp/duel_orb_pointer.txt1 -ow

"compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Pink Boo Orb/Pink Boo Day 1.asm" && python "compiler/gecko.py" a.out 801B1BB4 tmp/pink_boo_orb_day_1.txt1
"compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Pink Boo Orb/Pink Boo Day 2.asm" && python "compiler/gecko.py" a.out 801B1EF8 tmp/pink_boo_orb_day_2.txt1
"compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Pink Boo Orb/Pink Boo Orb Pointer.asm" && python "compiler/gecko.py" a.out 80249BDC tmp/pink_boo_orb_pointer.txt1 -ow
"compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Pink Boo Orb/Pink Boo Orb Pos Fixer.asm" && python "compiler/gecko.py" a.out 801B1C60 tmp/pink_boo_orb_pos_fixer.txt1

"compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Plunder Chest Orb/Plunder Chest Orb Pointer.asm" && python "compiler/gecko.py" a.out 80249BB4 tmp/plunder_chest_orb_pointer.txt1 -ow
"compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Plunder Chest Orb/Plunder Chest Orb Type.asm" && python "compiler/gecko.py" a.out 80249D12 tmp/plunder_chest_orb_type.txt1 -ow

"compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Soluna Orb/Soluna Orb Pointer.asm" && python "compiler/gecko.py" a.out 80249C7C tmp/soluna_orb_pointer.txt1 -ow

"compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Wacky Watch Orb/Wacky Watch Orb Pointer.asm" && python "compiler/gecko.py" a.out 80249CCC tmp/wacky_watch_orb_pointer.txt1 -ow

"compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Last 5 Turns/L5T Space Switch.asm" && python "compiler/gecko.py" a.out 80249CCC tmp/wacky_watch_orb_pointer.txt1 -ow
"compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Last 5 Turns/L5T Byte Hook.asm" && python "compiler/gecko.py" a.out 80249CCC tmp/wacky_watch_orb_pointer.txt1 -ow

copy "src\asm\Debug Orb Enablers.txt" tmp\debug_orb_enablers.txt1
copy "src\asm\Orb Tables.txt" tmp\orb_tables.txt1
del a.out

cd tmp
echo.$MP6DX >> ..\dist\store\codes.txt
for %%f in (*.txt1) do (
    type "%%f" >> ..\dist\store\codes.txt
    echo. >> ..\dist\store\codes.txt
)

cd ..

xcopy /E /I tools dist\tools
xcopy /E /I src\files dist\store\files

copy src\patch.bat dist\
copy src\patch.sh dist\
