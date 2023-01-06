
    PUSHS
    
    SECTION	FRAGMENT "HighVariables", HRAM

v_speed:	DS	1	;=16	the game speed


    SECTION FRAGMENT "ResetVariables", ROM0

	ld	A,	13
	ld	[v_speed],	A
	

    POPS
    

;--- Update Timer -------------------------------------------------------------;

mUpdTimer:					;increase our timer by one
	ld	HL,	g_message+7		;start with the last digit
.loop:
	ld	A,	[HL]			;load the old digit
	cp	gTIMER				;if we overflew the low part
	jp	Z,	.increaseSpeed		; speed it up a bit
	cp	gEMPTY
	jp	NZ,	.notempty		;if empty, then replace with 0
	ld	A,	$30
.notempty:
	cp	$3A					;if it is not in the range "0"-"9"
	jp	NC,	endUpdTimer	; then there is some other message in the display
	cp	$30					; so skip the update
	jp	C,	endUpdTimer	; else it will scramble the message
	dec	A					;increase the digit
	ld	[HL],	A			; store it back again
	cp	A,	$2F				;if it isn't larger than "9" now
	jp	NZ,	endUpdTimer	; then we are done
	ld	A,	$39				;else correct our ":" with a "0"
	ld	[HL-],	A			; store it back, decrease the pointer
	jp	.loop				; and update the next digit
.increaseSpeed:
	ld	A,	[v_speed]	;load the game speed
	inc	A			; and increase it
	cp	A,	$0		;speed should never go to 0
	jp	Z,	tDie		; else we kill it
	ld	[v_speed],	A

	dec	HL
	dec	HL
	
	INCLUDE "bonus/show.asm"
