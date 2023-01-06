    PUSHS
    

    SECTION	FRAGMENT "HighVariables",HRAM
    
g_justStart:	DS	1	;= 0	did we just left off from the title screen


    SECTION FRAGMENT "InitVariables0", ROM0
	ldh	[g_justStart],	A
	

    POPS
    

	di					;disable the interrupts; I'm to scared of some VBlank Interrupt happening
	WaitForVBlank

	;put some fake tiles in to prevent short bursts of grafic corruption
	ld	A,	$E2			
	ld	[$98E9], A
	ld	A,	$09	
	ld	[$98EA], A
	ld	[$98EB], A
	ld	A,	$E1	
	ld	[$98EC], A

	;look if we did just start... else we can't put the tiles for the second bank in
	ld	A,	[g_justStart]
	cp	A,	$0
	jp	Z,	.notJustStart

	ld	A,	$E2	
	ld	[$9AE9], A
	ld	A,	$09	
	ld	[$9AEA], A
	ld	[$9AEB], A
	ld	A,	$E1	
	ld	[$9AEC], A

.notJustStart:
	ld	A,	$1	;in each case, notify we did the just start
	ld	[g_justStart],	A

	;change the display method
	ld	a,	%11100001	; LCD on + BG on + BG $8000 + WIN on + WIN $9C00
	ldh	[rLCDC],	A

	ldh	A,	[v_desty]	;if we didn't change the level
	ld	B,	A
	ldh	A,	[rSCY]
	cp	B
	jp	Z,	saveHighscore	;don't copy a new level in

copyLevel1:		;copy first row of the leve
	xor	A
	call	gCopyLevel
	ld	A,	$1
	call	gCopyLevel
	ld	A,	$2
	call	gCopyLevel
copyLevel2:

	WaitForVBlank

	ld	A,	$3
	call	gCopyLevel
	ld	A,	$4
	call	gCopyLevel

saveHighscore:
	WaitForVBlank

	ld	A,	[$9C21]
	cp	A,	gLVL1
	jp	Z,	.noHigh		; look if we have a new highscore

	call	gUpdHigh	; if so, update it

.noHigh:
	ld	A,	gLVL1		; put in the string "LVL"+our level number
	ld	[$9C21],	A

	ld	A,	gLVL2
	ld	[$9C22],	A

	ld	A,	[g_level]
	add	A,	$31
	ld	[$9C23],	A

	call	gSnkAnim1

scroll2pos:
.wait:
	ldh	a,	[rLY]		; wait for
	cp	$0				;  outside vertical blank
	jr	nz,	.wait
	
	WaitForVBlank

	ldh	A,	[v_desty]	; look if we need to scroll the screen
	ld	B,	A
	ldh	A,	[rSCY]
	cp	B
	jp	Z,	.endscroll	;  else, pass
	inc	A				; increase scroll
	ldh	[rSCY],	A		;  store it back

	add	A,	$4			; add some (for first row)

	call	gCopyLevel	; and copy our level

	ld	A,	$E9			;finally, redraw our snake
	ld	L,	A
	ldh	A,	[g_vidBase]
	ld	H,	A

	ld	A,	$E2	
	ld	[HL+], A
	ld	A,	$09
	ld	[HL+], A
	ld	[HL+], A
	ld	A,	$E1	
	ld	[HL+], A

	jp	scroll2pos		;and continue our animation


.endscroll:
	ldh	A,	[rSCX]		;scroll horizontally after
	cp	$0				; if needed, of course
	jp	Z,	.nohscroll
	dec	A
	ldh	[rSCX],	A
	jp	scroll2pos

.nohscroll:
	ld	A,	gEMPTY		;clear our snake
	ld	[$98E9], A		;because we are going to enable our sprites
	ld	[$98EB], A
	ld	[$98EC], A
	ld	[$9AE9], A
	ld	[$9AEB], A
	ld	[$9AEC], A

	;put the sprites on again
	ld	a,	%11100011	; LCD on + BG on + BG $8000 + WIN on + WIN $9C00 + OBJ on
	ldh	[rLCDC],	A
	xor	A
	ldh	[rSCX],	a 		;clear scroll in case of

	call	gWaitKey	;now, we are done, so wait for user to press key
	; warning: we are now heading out of VBlank... but okay, the remainder is 
	;  buffered data
