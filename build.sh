#!/bin/bash

mkdir -p tmp
mkdir -p dist
mkdir -p dist/store

wine "compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/CPU Can Use All Orbs.asm" && python "compiler/gecko.py" a.out 801C986C tmp/cpu_can_use_all_orbs.txt1
wine "compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Custom Orb Code.asm" && python "compiler/gecko.py" a.out 801D644C tmp/custom_orb_code.txt1
wine "compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Max Capsules.asm" && python "compiler/gecko.py" a.out 801CAB84 tmp/max_capsules.txt1
wine "compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Orb Model Shells.asm" && python "compiler/gecko.py" a.out 801CCD88 tmp/orb_model_shells.txt1
wine "compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Orb Icon Shells.asm" && python "compiler/gecko.py" a.out 801CAAD8 tmp/orb_icon_shells.txt1
wine "compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Orb Type.asm" && python "compiler/gecko.py" a.out 801C93AC tmp/orb_icon_shells.txt1

wine "compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Battle Orb/Battle Orb Function.asm" && python "compiler/gecko.py" a.out 801F0160 tmp/battle_orb_function.txt1
wine "compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Battle Orb/Battle Orb Pointer.asm" && python "compiler/gecko.py" a.out 80249CF4 tmp/battle_orb_pointer.txt1 -ow

wine "compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Bowser Orb/Bowser Orb Rewrite.asm" && python "compiler/gecko.py" a.out 801BE730 tmp/bowser_orb_rewrite.txt1
wine "compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Bowser Orb/Bowser Orb Pointer.asm" && python "compiler/gecko.py" a.out 80249B64 tmp/bowser_orb_pointer.txt1 -ow

wine "compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Soluna Orb/Soluna Orb Pointer.asm" && python "compiler/gecko.py" a.out 80249C7C tmp/soluna_orb_pointer.txt1 -ow

wine "compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Wacky Watch Orb/Wacky Watch Orb Pointer.asm" && python "compiler/gecko.py" a.out 80249CCC tmp/wacky_watch_orb_pointer.txt1 -ow

wine "compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Last 5 Turns/L5T Multiplier.asm" && python "compiler/gecko.py" a.out 8015EDEC tmp/l5t_multiplier.txt1
wine "compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Last 5 Turns/L5T Multiplier If Nop.asm" && python "compiler/gecko.py" a.out 8015EDF0 tmp/l5t_multiplier_if_nop.txt1
wine "compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Last 5 Turns/L5T Byte Hook.asm" && python "compiler/gecko.py" a.out 80175910 tmp/l5t_byte_hook.txt1

cp "src/asm/Debug Enablers.txt" tmp/debug_enablers.txt1
cp "src/asm/Orb Tables.txt" tmp/orb_tables.txt1
cp "src/asm/Orb Shells 2.txt" tmp/orb_shells_2.txt1

rm -f a.out

cd tmp
echo '$MP6DX' >> ../dist/store/codes.txt
for f in *.txt1; do
    if [ -f "$f" ]; then
        cat "$f" >> ../dist/store/codes.txt
        echo "" >> ../dist/store/codes.txt
    fi
done

cd ..

cp -r tools dist/
cp -r src/files dist/store/

cp src/patch.bat dist/
cp src/patch.sh dist/
