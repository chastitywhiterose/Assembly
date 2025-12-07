%include 'bsd-putstring.asm'

	section	.data
	hello	db	'Hello, World!', 0Ah,0
	hbytes	equ	$-hello

	section	.text
	global	_start
_start:
	mov eax,hello
	call putstring

	push	dword 0
        mov eax,1
