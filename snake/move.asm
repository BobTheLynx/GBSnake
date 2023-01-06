    PUSHS
 
;-------Snake Move Routines-------------------------------------------------------;
    
    SECTION FRAGMENT "Routines", ROM0
    

;-------Go Left----------------------------------------------------------------;

gGoLeft:
	dec	A			;move left
	cp	A,	$FF		;if wrap-around
	jp	NZ,	.nowrap

	ld	A,	19		;come back at right of screen

.nowrap:
	ret


;-------Go Right---------------------------------------------------------------;

gGoRight:
	inc	A			;move right
	cp	20			;if wrap-around
	jp	c,	.nowrap

	ld	A,	$0		;come back at left of screen

.nowrap:
	ret


;-------Go Up------------------------------------------------------------------;

gGoUp:
	dec	A	;move up
	and	$F	;don't do complicated
	ret


;-------Go Down----------------------------------------------------------------;

gGoDown:
	inc	A	;move down
	and	$F	;don't do complicated
	ret
	
	
;-------End--------------------------------------------------------------------;
	
	POPS
