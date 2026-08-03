import struct
import argparse

# Set up argument parsing
parser = argparse.ArgumentParser(description='Convert a.out to Gecko format.')
parser.add_argument('input_file', type=str, help='Input a.out file')
parser.add_argument('start_address', type=str, help='Starting address in hexadecimal')
parser.add_argument('output_file', type=str, help='Output file for the Gecko code')
parser.add_argument('-ow', action='store_true', help='Overwrite for the func instead of inserting.')

args = parser.parse_args()

# Read the a.out file
with open(args.input_file, 'rb') as f:
    data = f.read()

# Extract relevant data
data = data[52:data.index(b'\x00\x2E\x73\x79\x6D\x74\x61\x62')]  # Adjusted for Python

# Prepare the output code
code = []

# Ensure start_address is a string before conversion
start_address_int = int(str(args.start_address), 16) & 0xFFFFFFFF  # Convert and format the starting address

# Swap the first two bytes if necessary
first_byte = (start_address_int >> 24) & 0xFF  # Get the first byte
if first_byte == 0x80:
    if args.ow:
        start_address_int = (start_address_int & ~0xFF000000) | (0x06 << 24)  # Swap 80 to C2
    else:
        start_address_int = (start_address_int & ~0xFF000000) | (0xC2 << 24)  # Swap 80 to C2
elif first_byte == 0x81:
    if args.ow:
        start_address_int = (start_address_int & ~0xFF000000) | (0x16 << 24)  # Swap 80 to C2
    else:
        start_address_int = (start_address_int & ~0xFF000000) | (0xD2 << 24)  # Swap 81 to D2


# Prepare the output code with spacing
counter = 0
for b in data:
    if counter % 8 == 0 and counter != 0:
        code.append("\n")  # New line after every 8 bytes

    if counter % 4 == 0 and counter % 8 != 0 and counter != 0:
        code.append(" ")  # Add space after every 4 bytes

    code.append(f"{b:02X}")  # Append the byte in hex format
    counter += 1

# Add padding if necessary
if not args.ow:
    if counter % 8 != 0:
        code.append(" 00000000")  # Add padding if not a multiple of 8

if args.ow:
    num_lines = (len(data))  # Calculate number of lines (rounding up) and add 1 for the final line
else:
    num_lines = (len(data) + 7) // 8  # Calculate number of lines (rounding up) and add 1 for the final line

# Add the initial line with the starting address and number of lines
code.insert(0, f"{start_address_int:08X} {num_lines:08X}\n")  # Insert at the beginning

if not args.ow and len(data) % 8 == 0:
        code.append("\n60000000 00000000")  # Final line only if complete

if args.ow:
    if not len(data) % 8 == 0:
        code.append(" 00000000")

code.append(f"\n")

# Join the code into a single string
formatted_code = ''.join(code)

if not args.ow and formatted_code.strip().endswith("60000000 00000000"):
    first_line = formatted_code.splitlines()[0]  # Get the first line
    address_part = first_line.split()[1]  # Get the second half (the number of lines)
    new_address = hex(int(address_part, 16) + 1)[2:].upper().zfill(8)  # Add 1 and format
    formatted_code = formatted_code.replace(address_part, new_address, 1)

# C2 with exactly 2 lines ending in nop needs count 1, not 2
if not args.ow:
    lines = formatted_code.strip().splitlines()
    if (len(lines) >= 2
            and lines[0].startswith("C2")
            and lines[0].endswith("00000002")
            and lines[-1] == "60000000 00000000"):
        lines[0] = lines[0][:-8] + "00000001"
        formatted_code = "\n".join(lines) + "\n"

# Write to dist/code.txt
with open(args.output_file, "w") as output_file:
    output_file.write(formatted_code)
