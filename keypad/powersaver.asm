;-------Power Saving Pause-----------------------------------------------------;
mPause:
	di					;disable interrupts
	WaitForVBlank
	
drawPauseMessage:
	ld	A,	$68			; the start address in shapemap for our pause message
	ld	HL,	$9C26		; the address in video to write it to
	ld	B,	$8			; the number of bytes to write
.loop:
	ld	[HL+],	A		; write byte to VRAM
	inc	A				; increase char pointer
	dec	B				; decrease counter
	jp	NZ,	.loop		;  and loop

	
.pause:
	; wait for all keys to be released
	call	gGetKeyHeading
	ldh	A,	[b_prev]
	and	$F0
	jp	Z,	.pause

	; nuke all information we did keep about those keys
	xor	A
	ldh	[b_evH], A
	ldh	[b_evV], A
	ldh	[b_pressed],	A

	call	gWaitKey	; wait for any new keys to be pressed

	ldh	A,	[b_prev]	; if we did press the arrow buttons
	and	A,	$F0
	jp	Z,	.noReset	;  then don't restart the game

.restart:
	ld	A,	$FF
	ldh	[v_corpse],	A	;fire a restart

	;correct the sprites
	ld	A,	[v_head1chr]
	dec	A
	ld	[v_head1chr],	A

	ld	A,	[v_head2chr]
	dec	A
	ld	[v_head2chr],	A
	
.noReset:
	xor	A
	ldh	[rIF],	A		;clear the interrupt flag
	ei
	jp		mEndPause	; and end the pause
