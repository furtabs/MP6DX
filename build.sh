#!/bin/bash

# Create directories
mkdir -p tmp
mkdir -p dist
mkdir -p dist/store

# Compile and process assembly files
wine "compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/CPU Can Use All Orbs.asm" && python "compiler/gecko.py" a.out 801C986C tmp/cpu_can_use_all_orbs.txt1
wine "compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Custom Orb Code.asm" && python "compiler/gecko.py" a.out 801D644C tmp/custom_orb_code.txt1
wine "compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Orb Shells.asm" && python "compiler/gecko.py" a.out 8024ABA8 tmp/orb_shells.txt1

wine "compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Bowser Orb/Bowser Orb Rewrite.asm" && python "compiler/gecko.py" a.out 801BE730 tmp/bowser_orb_rewrite.txt1
wine "compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Bowser Orb/Bowser Orb Pointer.asm" && python "compiler/gecko.py" a.out 80249B64 tmp/bowser_orb_pointer.txt1 -ow

wine "compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Chance Orb/Chance Orb Pointer.asm" && python "compiler/gecko.py" a.out 80249B3C tmp/chance_orb_pointer.txt1 -ow


wine "compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Chomp Call Orb/Chomp Call Orb Pointer.asm" && python "compiler/gecko.py" a.out 80249CA4 tmp/chomp_call_orb_pointer.txt1 -ow

wine "compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/DK Orb/DK Orb Pointer.asm" && python "compiler/gecko.py" a.out 80249B8C tmp/dk_orb_pointer.txt1 -ow
 
wine "compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Duel Orb/Duel Orb Fixer.asm" && python "compiler/gecko.py" a.out 801B9C60 tmp/duel_orb_fixer.txt1
wine "compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Duel Orb/Duel Orb Pointer.asm" && python "compiler/gecko.py" a.out 80249B14 tmp/duel_orb_pointer.txt1 -ow
 
wine "compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Pink Boo Orb/Pink Boo Day 1.asm" && python "compiler/gecko.py" a.out 801B1BB4 tmp/pink_boo_orb_day_1.txt1
wine "compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Pink Boo Orb/Pink Boo Day 2.asm" && python "compiler/gecko.py" a.out 801B1EF8 tmp/pink_boo_orb_day_2.txt1
wine "compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Pink Boo Orb/Pink Boo Orb Pointer.asm" && python "compiler/gecko.py" a.out 80249BDC tmp/pink_boo_orb_pointer.txt1 -ow
wine "compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Pink Boo Orb/Pink Boo Orb Pos Fixer.asm" && python "compiler/gecko.py" a.out 801B1C60 tmp/pink_boo_orb_pos_fixer.txt1
 
wine "compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Poison Shroom Orb/Poison Shroom Orb Type.asm" && python "compiler/gecko.py" a.out 802495DB tmp/poison_shroom_orb_type.txt1 -ow
wine "compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Poison Shroom Orb/Poison Shroom Orb Type 2.asm" && python "compiler/gecko.py" a.out 802495E2 tmp/poison_shroom_orb_type_2.txt1 -ow
 
wine "compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Soluna Orb/Soluna Orb Pointer.asm" && python "compiler/gecko.py" a.out 80249C7C tmp/soluna_orb_pointer.txt1 -ow
 
wine "compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Wacky Watch Orb/Wacky Watch Orb Pointer.asm" && python "compiler/gecko.py" a.out 80249CCC tmp/wacky_watch_orb_pointer.txt1 -ow
 
wine "compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Last 5 Turns/L5T Multiplier.asm" && python "compiler/gecko.py" a.out 8015EDEC tmp/l5t_multiplier.txt1
wine "compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Last 5 Turns/L5T Multiplier If Nop.asm" && python "compiler/gecko.py" a.out 8015EDF0 tmp/l5t_multiplier.txt1
wine "compiler/codewrite/powerpc-gekko-as.exe" -a32 -mbig -mregnames -mgekko "src/asm/Last 5 Turns/L5T Byte Hook.asm" && python "compiler/gecko.py" a.out 80175910 tmp/lt5_byte_hook.txt1

# Copy the text file
cp "src/asm/Debug Orb Enablers.txt" tmp/debug_orb_enablers.txt1
cp "src/asm/Orb Tables.txt" tmp/orb_tables.txt1

# Remove the temporary object file
rm -f a.out

# Change to tmp directory and process files
cd tmp
echo '$MP6DX' >> ../dist/store/codes.txt
for f in *.txt1; do
    if [ -f "$f" ]; then
        cat "$f" >> ../dist/store/codes.txt
        echo "" >> ../dist/store/codes.txt
    fi
done

# Return to parent directory
cd ..

# Copy tools directory
cp -r tools dist/

# Copy files directory
cp -r src/files dist/store/

# Copy patch script (convert to .sh if needed)
cp src/patch.bat dist/
cp src/patch.sh dist/

echo "Build completed successfully!"
