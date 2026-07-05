#!/bin/sh
cp 5-dos.md 17-linux.md
#change ELF format and header file
sed 's/org 100h/format ELF executable/g' -i 17-linux.md
sed 's/chastelib16.asm/chastelib32.asm/g' -i 17-linux.md
#change the 16 bit registers to 32 bit
sed 's/ax/eax/g' -i 17-linux.md
sed 's/bx/ebx/g' -i 17-linux.md
sed 's/cx/ecx/g' -i 17-linux.md
sed 's/dx/edx/g' -i 17-linux.md
sed 's/si/esi/g' -i 17-linux.md
sed 's/di/edi/g' -i 17-linux.md
sed 's/bp/ebp/g' -i 17-linux.md
sed 's/sp/esp/g' -i 17-linux.md
#change word declarations to dword
sed 's/word/dword/g' -i 17-linux.md
sed 's/ dw / dd /g' -i 17-linux.md
sed 's/ rw / rd /g' -i 17-linux.md

# this script is meant to convert chapter 5 from the Linux Assembly book to chapter 17 for the Linux Assembly book
#note that chastelib16.asm and chastelib32.asm are header that I manually created
#these sed commands can make most changes but manual review is still required
#system calling conventions are still different between 16-bit DOS and 32 bit Linux
#and I could have mistakes from things I missed

