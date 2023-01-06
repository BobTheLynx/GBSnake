;##############################################################################;
;###### POST RESET ############################################################;
;##############################################################################;
; start of ugliness
; this stuff is executed the first step after a reset, to show the "START" message
; it also (weirdly) scrolls the screen if needed
; TODO: just make this nicer

	ldh	A,	[m_rstcnt]	;look if we have to reset yet
	cp	A,	$FF			; if not, then head on
	jp	Z,	noFreeze	;

	dec	A				;decrease counter
	ldh	[m_rstcnt],	A	; store it back
	jp	NZ,	noFreeze	; and if it isn't yet our time, head back again
	
	
	INCLUDE "vblank/post_reset.asm"
	

	ld	A,	gAPPLE		;then, show score rightly
	ldh	[s_score],	A

	ld	A,	$30
	ldh	[s_score+1],	A
	ldh	[s_score+2],	A

	ldh	A,	[b_prev]	;look if he wants to switch level
	and	A,	$F0
	cp	$0
	jp	NZ,	gSwitchLevel	;if so, then switch the level
	;else, he is going to play
	

drawEmptyTimer:	;draw the starting text for the time
	ld	HL,	gMessageTimer
	ld	DE,	g_message
	ld	B,	8
.loop:
	ld	A,	[HL+]
	ld	[DE],	A
	inc	DE
	dec	B
	jp	NZ,	.loop

	xor	a	;clear the interrupts
	ldh	[rIF],	a
	ei	;enable them again

noFreeze:
	jp	mMainStepEnd	;and restart

;--- End of Stepping ----------------------------------------------------------;


    INCLUDE "interface/switch_level.asm"
