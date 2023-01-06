    PUSHS
 
;-------Inc Score--------------------------------------------------------------;
    
    SECTION FRAGMENT "Routines", ROM0
    
	

gIncScore:
	ldh	A,	[s_score+2]		;load lowest digit of score
	inc	A					; increase it
	ldh	[s_score+2],	A	; and save it back again
	cp	$3A					;look if it has gone bigger that 10
	jp	c,	.nocarry		; if not, then we are done

	ld	A,	$30				; if it is, load back "0"
	ldh	[s_score+2],	A

	ldh	A,	[s_score+1]		; and increase the middle digit of score
	inc	A
	ldh	[s_score+1],	A
	cp	$3A					;look if this has gone bigger than 10
	jp	c,	.nocarry		; if not, then we are done

	ld	A,	$30				; if it is, load back "0"
	ldh	[s_score+1],	A

	ldh	A,	[s_score+0]		; and open the highest digit of score
	cp	A,	$30				; look if there is still the icon of "score" inside
	jp	nc,	.toolow			;  if not, we can play
	ld	A,	$30				;  else, we need to simulate a 0 instead

.toolow:
	inc	A					;increase the highest digit of score
	ldh	[s_score+0],	A

.nocarry:
	ret						; and fuck for the carry
	
;-------End--------------------------------------------------------------------;
	
	POPS
