%include 'bsd-putstring.asm'

	section	.data
	hello	db	'Hello, World!', 0Ah,0
	hbytes	equ	$-hello

	section	.text
	global	_start
_start:
	mov eax,hello
	call putstring

        mov eax,1
	push 0
	push eax
        int 80h

