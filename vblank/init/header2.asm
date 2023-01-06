;-------Draw Header-----------------------------------------------------------;

	; colorize a few icons on the header
	ld	A,	1
	ldh	[$FF4F],A	;Set vbank 1
	ld	[$9C30],A

	ld	A,	2
	ld	[$9C2B],A

	xor	A
	ld	[$9C26],A
	ld	[$9C27],A
	ldh	[$FF4F],A	;Reset vbank 0


	;copy top part header
iHeader3:
	ld	B,	20			;number of bytes
	ld	DE,	gHeader1	;source
	ld	HL,	$9C00		;destination
.loop:
	ld	A,	[DE]		;load from ROM
	ld	[HL+],	A		;store in charmap
	inc	DE				;increase pointer
	dec	B				;decrease counter
	jr	nz,	.loop		; and loop
	
	;copy bottom part header
iHeader4:
	ld	B,	20			;number of bytes
	ld	DE,	gHeader2	;source
	ld	HL,	$9C20		;destination
.loop:
	ld	A,	[DE]		;load from ROM
	ld	[HL+],	A		;store in charmap
	inc	DE				;increase pointer
	dec	B				;decrease counter
	jr	nz,	.loop		; and loop
