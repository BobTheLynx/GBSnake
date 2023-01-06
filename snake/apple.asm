    PUSHS
    
    SECTION	FRAGMENT "HighVariables",HRAM

a_applex:	    DS	1	; 		x position apple
a_appley:	    DS	1	; 		y position apple
a_ateapple:	    DS	1	;=0 	did I just eat an apple?
a_dispencer:	DS	1	;=0 	dispence a load of apples


    SECTION FRAGMENT "ResetVariables0", ROM0
    
	ldh	[a_ateapple],	A
	ldh	[a_dispencer],	A
	

    POPS



    ldh	A,	[a_error]	; check if the apple failed to position
	cp	A,	$0			; if it is the case,
	jp	NZ,	.moveapple	;  then move it

	ldh	A,	[h_eated]		;update the food buffer
	ldh	[a_ateapple],	A

	cp	A,	gAPPLE		;look if we did eat an apple
	jp	NZ,	.noapple


    INCLUDE "sound/apple.asm"


;-------Increase the score-----------------------------------------------------;

	call	gIncScore	;increase our score


;-------Check if this is the good apple----------------------------------------;

	ld	A,	[a_appleadr]
	ld	B,	A
	ld	A,	[h_head2adr]
	cp	A,	B
	jp	NZ,	.noapple

	ld	A,	[a_appleadr+1]
	ld	B,	A
	ld	A,	[h_head2adr+1]
	cp	A,	B
	jp	NZ,	.noapple


;-------Move Apple-------------------------------------------------------------;

.moveapple:
	ldh	A,	[RANDOM]		;get random number (sorta of) from timer
	ld	B,	A			; save it temp
.modulo:
	cp	A,	19			;perform a lazy modulo 20
	jp	c,	.noproblem	; while it is larger than 20
	sub	A,	$14			;  substract 20
	jp .modulo

.noproblem:
	ldh	[a_applex],	A	;and save it as the X position for the apple

	ld	A,	B			;load our old random number
	swap	A			; do the swap
	and	$0F				; perform an efficient modulo 16
	ldh	[a_appley],	A	; and save it as the Y position for the apple

	xor	A
	ldh	[a_error],	A	; and clear the apple error
	jp	.endapple

.noapple:
	ld	A,	[a_dispencer]
	cp	A,	$0
	jp	Z,	.endapple
	dec	A
	ld	[a_dispencer],	A
	
	INCLUDE "sound/basket.asm"

	jp	.moveapple

.endapple:
	ldh	A,	[v_eating]	;finally, update our eating buffer
	ldh	[h_eated],	A

