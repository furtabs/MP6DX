#!/bin/bash

# Mario Party 6 - DX Patcher for Linux
# Uses Wine to run Windows executables

VERSION="26.01.05"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to check if Wine is installed
check_wine() {
    if ! command -v wine &> /dev/null; then
        echo "Error: Wine is not installed. Please install Wine first."
        echo "On Ubuntu/Debian: sudo apt install wine"
        echo "On Arch: sudo pacman -S wine"
        exit 1
    fi
}

# Function to check if required files exist
check_requirements() {
    if [ ! -f "$SCRIPT_DIR/tools/dolphintool.exe" ]; then
        echo "Error: dolphintool.exe not found in tools directory"
        exit 1
    fi
    if [ ! -f "$SCRIPT_DIR/tools/pyisotools.exe" ]; then
        echo "Error: pyisotools.exe not found in tools directory"
        exit 1
    fi
    if [ ! -f "$SCRIPT_DIR/tools/GeckoLoader.exe" ]; then
        echo "Error: GeckoLoader.exe not found in tools directory"
        exit 1
    fi
    if [ ! -f "$SCRIPT_DIR/store/codes.txt" ]; then
        echo "Error: codes.txt not found in store directory"
        exit 1
    fi
}

# Function to display menu and get user choice
show_menu() {
    clear
    echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ="
    echo "Mario Party 6 - DX Patcher!"
    echo "How do you wish to export your game."
    echo ""
    echo "1: RVZ (Recommended for Dolphin)"
    echo "2: ISO (Recommended for SwissGC)"
    echo "3: Exit Patcher"
    echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ="
    
    read -p "Enter your choice (1-3): " choice
    
    case $choice in
        1) PATCHER="RVZ" ;;
        2) PATCHER="ISO" ;;
        3) echo "Exiting..."; exit 0 ;;
        *) echo "Invalid choice. Please enter 1, 2, or 3."; show_menu ;;
    esac
}

# Function to find ISO/RVZ files
find_game_files() {
    ISO_FILES=()
    RVZ_FILES=()
    
    # Find ISO files
    for file in "$SCRIPT_DIR"/*.iso; do
        if [ -f "$file" ]; then
            ISO_FILES+=("$file")
        fi
    done
    
    # Find RVZ files
    for file in "$SCRIPT_DIR"/*.rvz; do
        if [ -f "$file" ]; then
            RVZ_FILES+=("$file")
        fi
    done
    
    if [ ${#ISO_FILES[@]} -eq 0 ] && [ ${#RVZ_FILES[@]} -eq 0 ]; then
        echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ="
        echo "No ISO or RVZ files found in the same directory as the script."
        echo "Place the Mario Party 6 (USA) ISO or RVZ in the script's directory and run it again."
        echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ="
        echo ""
        read -p "Press Enter to exit..."
        exit 1
    fi
}

# Function to process RVZ files
process_rvz() {
    for rvz_file in "${RVZ_FILES[@]}"; do
        echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ="
        echo "Converting RVZ to ISO! This is needed to patch the game..."
        echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ="
        
        wine "$SCRIPT_DIR/tools/dolphintool.exe" convert -i "$(winepath -w "$rvz_file")" -f iso -o "$(winepath -w "$SCRIPT_DIR/tmp/tmp.iso")"
        
        if [ $? -ne 0 ]; then
            echo "Error: Failed to convert RVZ to ISO"
            exit 1
        fi
        
        clear
        echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ="
        echo "Extracting Gamespace! This may take awhile depending on computer speed..."
        echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ="
        
        wine "$SCRIPT_DIR/tools/pyisotools.exe" "$(winepath -w "$SCRIPT_DIR/tmp/tmp.iso")" E "--dest=$(winepath -w "$SCRIPT_DIR/tmp/")"
        
        if [ $? -ne 0 ]; then
            echo "Error: Failed to extract ISO"
            exit 1
        fi
        
        clear
        echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ="
        echo "Patching in Gecko Codes!"
        echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ="
        
        wine "$SCRIPT_DIR/tools/GeckoLoader.exe" --hooktype=GX --optimize "$(winepath -w "$SCRIPT_DIR/tmp/root/sys/main.dol")" "$(winepath -w "$SCRIPT_DIR/store/codes.txt")" --dest "$(winepath -w "$SCRIPT_DIR/tmp/root/sys/main.dol")"
        
        if [ $? -ne 0 ]; then
            echo "Error: Failed to patch Gecko codes"
            exit 1
        fi
        
        clear
        echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ="
        echo "Copying mod data!"
        echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ="
        
        cp -r "$SCRIPT_DIR/store/"* "$SCRIPT_DIR/tmp/root/"
        
        clear
        echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ="
        echo "Rebuilding! This may take awhile depending on computer speed..."
        echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ="
        
        wine "$SCRIPT_DIR/tools/pyisotools.exe" "$(winepath -w "$SCRIPT_DIR/tmp/root/")" B "--dest=$(winepath -w "$SCRIPT_DIR/tmp/game.iso")"
        
        if [ $? -ne 0 ]; then
            echo "Error: Failed to rebuild ISO"
            exit 1
        fi
        
        break
    done
}

# Function to process ISO files
process_iso() {
    for iso_file in "${ISO_FILES[@]}"; do
        clear
        echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ="
        echo "Extracting Gamespace! This may take awhile depending on computer speed..."
        echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ="
        
        wine "$SCRIPT_DIR/tools/pyisotools.exe" "$(winepath -w "$iso_file")" E "--dest=$(winepath -w "$SCRIPT_DIR/tmp/")"
        
        if [ $? -ne 0 ]; then
            echo "Error: Failed to extract ISO"
            exit 1
        fi
        
        clear
        echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ="
        echo "Patching in Gecko Codes!"
        echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ="
        
        wine "$SCRIPT_DIR/tools/GeckoLoader.exe" --hooktype=GX "$(winepath -w "$SCRIPT_DIR/tmp/root/sys/main.dol")" "$(winepath -w "$SCRIPT_DIR/store/codes.txt")" --dest "$(winepath -w "$SCRIPT_DIR/tmp/root/sys/main.dol")"
        
        if [ $? -ne 0 ]; then
            echo "Error: Failed to patch Gecko codes"
            exit 1
        fi
        
        clear
        echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ="
        echo "Copying mod data!"
        echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ="
        
        cp -r "$SCRIPT_DIR/store/"* "$SCRIPT_DIR/tmp/root/"
        
        clear
        echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ="
        echo "Rebuilding! This may take awhile depending on computer speed..."
        echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ="
        
        wine "$SCRIPT_DIR/tools/pyisotools.exe" "$(winepath -w "$SCRIPT_DIR/tmp/root/")" B "--dest=$(winepath -w "$SCRIPT_DIR/tmp/game.iso")"
        
        if [ $? -ne 0 ]; then
            echo "Error: Failed to rebuild ISO"
            exit 1
        fi
        
        break
    done
}

# Function to create final output
create_output() {
    if [ "$PATCHER" = "RVZ" ]; then
        clear
        echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ="
        echo "Converting to RVZ format..."
        echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ="
        
        wine "$SCRIPT_DIR/tools/dolphintool.exe" convert -i "$(winepath -w "$SCRIPT_DIR/tmp/game.iso")" -o "$(winepath -w "$SCRIPT_DIR/Mario Party 6 (USA) [DX] ($VERSION).rvz")" -f rvz -b 131072 -c zstd -l 5
        
        if [ $? -eq 0 ]; then
            rm -f "$SCRIPT_DIR/tmp/game.iso"
            clear
            echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ="
            echo "Success! Your game is located in \"Mario Party 6 (USA) [DX] ($VERSION).rvz\""
            echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ="
        else
            echo "Error: Failed to convert to RVZ"
            exit 1
        fi
    elif [ "$PATCHER" = "ISO" ]; then
        clear
        mv "$SCRIPT_DIR/tmp/game.iso" "$SCRIPT_DIR/Mario Party 6 (USA) [DX] ($VERSION).iso"
        echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ="
        echo "Success! Your game is located in \"Mario Party 6 (USA) [DX] ($VERSION).iso\""
        echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ="
    fi
}

# Main execution
main() {
    echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ="
    echo "Setting up patcher!"
    echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ="
    
    # Check requirements
    check_wine
    check_requirements
    
    # Clean up tmp directory
    rm -rf "$SCRIPT_DIR/tmp"
    mkdir -p "$SCRIPT_DIR/tmp"
    
    # Show menu and get user choice
    show_menu
    
    # Find game files
    find_game_files
    
    # Process files based on type
    if [ ${#RVZ_FILES[@]} -gt 0 ]; then
        process_rvz
    elif [ ${#ISO_FILES[@]} -gt 0 ]; then
        process_iso
    fi
    
    # Create final output
    create_output
    
    # Clean up
    rm -rf "$SCRIPT_DIR/tmp"
    
    echo ""
    read -p "Press Enter to exit..."
}

# Run main function
main
