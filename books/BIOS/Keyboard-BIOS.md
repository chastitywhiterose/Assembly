In PC BIOS programming (16-bit real mode), reading a character or getting keyboard input is handled via Interrupt 0x16 (Keyboard Services), while displaying or reading characters on the screen uses Interrupt 0x10 (Video Services).

1. Reading a Character from the Keyboard (INT 0x16)

To wait for and read a keystroke from the keyboard:

- Interrupt: 0x16
- Function (AH): 0x00 (Get Key / Read Character)
- Return Value (AL): Contains the ASCII character code.
- Return Value (AH): Contains the keyboard scan code.

Assembly Example:

```
mov ah, 0x00      ; Function 00h: Read character/key
int 0x16          ; Call BIOS keyboard interrupt
                  ; AL now holds the ASCII value of the key pressed
```


2. Reading a Character at the Cursor (INT 0x10, Service 0x08)

If you mean reading the character currently displayed on the screen at the cursor position (Video Service):

- Interrupt: 0x10
- Function (AH): 0x08 (Read character and attribute at cursor)
- Input (BH): Display page number (in text mode)
- Output (AL): ASCII value of the character
- Output (AH): Attribute byte of the character (color/formatting in text mode)

Assembly Example:

```
mov ah, 0x08      ; Function 08h: Read character and attribute
mov bh, 0x00      ; Display page 0
int 0x10          ; Call BIOS video interrupt
                  ; AL = ASCII character, AH = attribute
```


3. Printing/Displaying a Character (INT 0x10, Service 0x0E)

To output/display a character to the screen (teletype mode):

- Interrupt: 0x10
- Function (AH): 0x0E (Teletype output)
- Input (AL): ASCII character to print
- Input (BH): Page number
- Input (BL): Color attribute (in graphics mode; optional in some contexts)

Assembly Example:

```
mov ah, 0x0E      ; Function 0Eh: Teletype output
mov al, 'A'       ; Character to print
mov bh, 0x00      ; Page number 0
int 0x10          ; Call BIOS video interrupt
```

More information:

<https://jyywiki.cn/pages/OS/manuals/BIOS-interrupts.pdf>
