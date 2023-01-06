;-------Draw Header------------------------------------------------------------;

;draw colors first; the DMG then re-overwrites the data later
iHeaderColor:
	ld	A,	1
	ldh	[$FF4F],A	;Set vbank 1

	ld	A,	3		;Color palette 3 = GREYSCALE
	ld	B,	$40		;Number of bytes to write = 64
	ld	HL,	$9C00	;Source address
.loop
	ld	[HL+],	A	;Write to char attribute ram
	dec	B			;Decrease counter
	jr	nz,	.loop	; and loop

	xor	A
	ldh	[$FF4F],A	;Restore vbank 0


;top part

iSplashHeader1:
	ld	B,	20				;number of bytes
	ld	DE,	gSplashHeader1	;source
	ld	HL,	$9C00			;destination
.loop:
	ld	A,	[DE]			;load from ROM
	ld	[HL+],	A			;store in charmap
	inc	DE					;increase pointer
	dec	B					;decrease counter
	jr	nz,	.loop			; and loop
	

;bottom part

iSplashHeader2:
	ld	B,	20				;number of bytes
	ld	DE,	gSplashHeader2	;source
	ld	HL,	$9C20			;destination
.loop:
	ld	A,	[DE]			;load from ROM
	ld	[HL+],	A			;store in charmap
	inc	DE					;increase pointer
	dec	B					;decrease counter
	jr	nz,	.loop			; and loop
