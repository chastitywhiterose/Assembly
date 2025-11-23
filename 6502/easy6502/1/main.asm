LDA #$01
STA $0200
LDA #$05
STA $0201
LDA #$08
STA $0202

;This is a sample 6502 source file from Easy6502 by skilldrick
;https://skilldrick.github.io/easy6502/

;It can be assembled in one of the following ways.

;xa main.asm -o main.bin

;64tass main.asm -o main.bin -b

;In both cases, it should give you a file that contains these 15 bytes
;A9 01 8D 00 02 A9 05 8D 01 02 A9 08 8D 02 02

;What this program does is not important. It is only to establish the reliability of assemblers and whether they produce the correct bytes. Other assemblers may also work, but I had trouble with crasm, dasm, and acme. If I find other working assemblers, I will add them too.


