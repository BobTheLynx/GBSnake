    PUSHS
 
;-------Update Level-----------------------------------------------------------;
; update in VBlank, pls
; A should loop from 0 to 127
    
    
    SECTION FRAGMENT "Routines", ROM0


gCopyLevel:
	and	$7F				;we only need 127 steps, luckely
	ld	L,	A			; load as low bit of address for loading
	xor	A				; and load 0
	ld	H,	A			; as high bit of address for loading

	sla	L				;multiply HL...
	rl	H
	sla	L
	rl	H				;...by 4

	ld	BC,	gLevel		;load address of level
	ldh	A,	[g_level]	; from address table, indexed with [g_level*2]
	sla	A
	add	A,	C			;add [g_level*2] to lowest bit of address
	ld	C,	A

	ld	A,	[BC]		;load effective address of current level
	ld	E,	A			; first lowest bit
	inc	BC
	ld	A,	[BC]
	ld	D,	A			; then highest bit

	ld	A,	E
	add	A,	L			;add loading offset to source
	ld	E,	a
	jp	NC,	.notcarry	; and if carry...
	inc	D				; ...carry on
.notcarry:

	ld	A,	D
	add	A,	H			;add loading offset to destination
	ld	D,	A

	ldh	A,	[g_vidBase]	;add current video map offset
	or	A,	H
	ld	H,	A

	ld	A,	$4			;effectively load 4 bytes
	ld	B,	A

.copylevelbase:
	ld	A,	1		;Set palette to 4 shades of brown
	ldh	[$FF4F],A	; into vbank 1
	ld	[HL],A
	xor	A
	ldh	[$FF4F],A	; return to vbank 0

	ld	A,	[DE]	;Load tile to load
	cp	A,	$0		; if it isn't an empty one
	jp	NZ,	.notEmpty	; then do load it another way

	ld	A,	1		;Else, reset palette to 4 tints of olive
	ldh	[$FF4F],A	; into vbank 1
	xor	A
	ld	[HL],A
	ldh	[$FF4F],A	; return to vbank 0

	;and perform Yvar's secret grass hashing routine
	ld	A,	L
	swap	A
	xor	L
	ld	C,	A
	add	C
	add	C
	rra
	and	32

.notEmpty:
	add	A,	32		;Anyway, add 43 as for the map base
	ld	[HL+],	A	; and store it in memory
	inc	DE			;increase pointer
	dec	B			;decrease counter
	jp	nz,	.copylevelbase	; and, guess what, loop!
	ret
	
;-------End--------------------------------------------------------------------;
	
	POPS
