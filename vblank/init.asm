;-------DMG Joke---------------------------------------------------------------;
	;little joke for the DMG!

iDisLCD:
	ld	b,	$80			; the number of lines to scroll
	ld	c,	$00			; the current line value
.nextFrame:
	WaitForVBlank

	dec	C				; scroll down
	ld	A,	C
	ldh	[rSCY],	A

	dec	B				; decrease frame counter
	jr	nz,	.nextFrame	;  and loop if not done


;-------Disable Screen---------------------------------------------------------;
	xor	a				; write 0
	ldh	[rLCDC],	a	;  to LCD Control Register


;-------Initialize Scroll------------------------------------------------------;

iIniScrl:
	ld	a,	0 			; write 0 to scroll registers X and Y
	ldh	[rSCX],	a 		;  so visible screen is
	ldh	[rSCY],	a		;  at the top left of the background.


;-------Clear Highscores-------------------------------------------------------;

iClearScores:
	ld	HL,	s_scores	; address of highscores
	ld	B,	8			; number of highscores
.loop:
	ld	A,	gHIGH		; the highscore icon
	ld	[HL+],	A		;  at position x+0
	ld	A,	$30			; the "0"
	ld	[HL+],	A		;  at position x+1
	ld	[HL+],	A		;  at position x+2
	dec	B				; decrease counter
	jp	nz,	.loop		;  and loop if not done


;-------Draw message "READY? +GO"----------------------------------------------;

	ld	A,	$3				; Message "READY? +GO"
	call	gDrawMessage


;-------Clear Sprites----------------------------------------------------------;

iClearOAM:
	ld	HL,	$C09F	; load end of sprite map buffer
	ld	DE,	$FE9F	; load end of real sprite map
	ld	C,	$A0		; the number of bytes to clear
	ld	A,	$00		; the value to write
.loop:
	ld	[HL-],	A	; clear memory in sprite map buffer
	ld	[DE],	A	; clear memory in real sprite map
	dec	DE			; decrease pointer
	dec	C			; decrease counter
	jr	nz,	.loop	;  and loop if not done


;-------Clear Screen-----------------------------------------------------------;

iClearScreen:
	ld	HL,	$98FF	; load end of screen buffer 1
	ld	DE,	$99FF	; load end of screen buffer 2
	ld	B,	$00		; 256 bytes to write
	ld	A,	gEMPTY	; load empty tile
.loop:
	; grass hashing function
	;  ((address^(address>>4))*1.5)&16
	ld	A,	L
	swap	A
	xor	L
	ld	C,	A
	add	C
	add	C
	rra
	and	32
	add	32
	ld	[HL-],	A	; clear memory 
	ld	[DE],	A	; clear memory
	dec	DE			; decrease pointer
	dec	B			; decrease counter
	jr	nz,	.loop	;  and loop if not done


iMakeSplash:
	ld	HL,	$9A00	; load end of screen
	ld	DE,	$9B00	; load end of screen
	ld	BC,	gSplash1+256
.loop:
	ld	A,	[BC]	; load tile from splash
	ld	[HL],	A	; clear memory
	dec	BC			; decrease pointer

	; grass hashing function
	;  ((address^(address>>4))*1.5)&16
	ld	A,	L
	db	$CB,$37	
	xor	L
	ld	E,	A
	add	E
	add	E
	rra
	and	32
	add	32
	dec	L			; decrease pointer
	ld	E,	L		; copy pointer to pointer
	ld	[DE],	A	; clear memory
	jr	nz, .loop	; and loop


;-------Load Grafix------------------------------------------------------------;

iLoadGfx:
	ld	bc,	(gShapesEnd-gShapes) ; number of tiles to copy
	ld	hl,	gShapes		; address of tiles to copy
	ld	de,	$8000		; address to copy to
.loop:
	ld	a,	[hl+]		; load from ROM
	ld	[de],	a		; save to VRAM
	inc	de				; increase pointers
	dec	bc
	ld	a,	b			; if we have copied
	or	c				;  all tiles
	jr	nz,	.loop		;  then we don't loop


;-------Prepare Sprite DMA-----------------------------------------------------;

; copy the 10-byte sprite DMA routine to HRAM
iPrepOAMDMA:
	ld	C,	$80		; destination: v_oam
	ld	B,	10		; number of bytes: 10
	ld	HL,	vDMA	; source: vDMA
.loop:
	ld	A,	[HLI]	; load from source
	ld	[C], A		; put in destination HRAM
	inc	C			; increase destination pointer
	dec	B			; decrease counter
	jr	NZ,	.loop	;  and loop
    
;-------Prepare Colors---------------------------------------------------------;

iColors:
	ld	A,	$80		; load address
	ldh	[$FF68], A	;  to background palette
	ldh	[$FF6A], A	;  and OAM palette
	
	ld	B,	$40		; load number of colors
	ld	HL,	gColors	;  load source

.loop:	
	ld	A, [HL+]	; copy the same color
	ldh	[$FF69],A	;  to background palette
	ldh	[$FF6B],A	;  and OAM palette
	dec	B			; decrease counter
	jr	nz,	.loop	;  and loop
