#!/bin/bash

# List ASM disks and extract their names
asmcmd lsdsk -G | awk '{print $1}' > asm_disks.txt

# Check for duplicate names
duplicates=$(sort asm_disks.txt | uniq -d)

if [ -z "$duplicates" ]; then
  echo "No duplicate ASM disk names found."
else
  echo "Duplicate ASM disk names found:"
  echo "$duplicates"
fi

# Clean up
rm -f asm_disks.txt