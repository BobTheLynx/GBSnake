
    PUSHS


    SECTION	FRAGMENT "HighVariables",HRAM

t_tail1x:	DS	1	;= 8	horizontal position tail 1
t_tail1y:	DS	1	;= 7	vertical position tail 1
t_tail2x:	DS	1	;= 0	horizontal position tail 2
t_tail2y:	DS	1	; 		vertical position tail 1


    SECTION FRAGMENT "ResetVariables0", ROM0
    
	ldh	[t_tail2x],	A
	
	
    SECTION FRAGMENT "ResetVariables", ROM0
    
	ld	A,	7
	ldh	[t_tail1y],	A
	
	inc A   ;ld A, 8
	ldh	[t_tail1x],	A
	

    POPS
    

;=== Move tails ===============================================================;

;--- Set pos tail 2 to pos tail 1 ---------------------------------------------;

tUpdateTail:

	ldh	A,	[t_tail1x]	;now we moved the sprite positions
	ldh	[t_tail2x],	A	; move the tile positions in the same matter

	ldh	A,	[t_tail1y]	;the reason I do move both this way,
	ldh	[t_tail2y],	A	; is that it takes less code than to recalculate them

	
;--- Move Tail-1 --------------------------------------------------------------;

	ldh	A,	[v_trail]	;look up what is the corpse we picked up
	and	$3				; we are only interested in what direction it was going

;--- Tail Going left ----------------------------------------------------------;

	jr	NZ,	.notLeft	; if it was 0, it wasn't going left

	ldh	A,	[t_tail1x]	; if it is going left
	call gGoLeft		;  then move left
	ldh	[t_tail1x],	A	;  thanks to our magical routine
	jp	mEndMoveTail	;  and finish the stuff


;--- Tail Going Right ---------------------------------------------------------;

.notLeft:
	dec	A				; look if it was 1
	jr	NZ,	.notRight	;  else, it wasn't going right either

	ldh	A,	[t_tail1x]	; if it was going right
	call gGoRight		;  call our sublime routine
	ldh	[t_tail1x],	A	;  to move us right too
	jp	mEndMoveTail	;  and then we are done


;--- Tail Going Up ------------------------------------------------------------;

.notRight:
	dec	A				; look if it was 2
	jr	NZ,	.notUp		;  else, downwarDS is what it was going to go to

	ldh	A,	[t_tail1y]	; if it was going up
	call gGoUp			;  follow the leader
	ldh	[t_tail1y],	A	;  with our routine, as usual
	jp	mEndMoveTail	;  and wrap it up

;--- Tail Going Down ----------------------------------------------------------;

.notUp:
	dec	A				; look if it was 3
	jr NZ, mEndMoveTail	;  else, fuck it

	ldh	A,	[t_tail1y]	; if it was going down
	call gGoDown		;  go down ourself
	ldh	[t_tail1y],	A	;  and we are done

	;jp	mEndMoveTail	; we are done


mEndMoveTail:

;=== Addresses ================================================================;
;--- Set address Tail-2 to Tail-1 ---------------------------------------------;

mMoveTail2Address:
	ldh	A,	[t_tail1adr]	;the old story again
	ldh	[t_tail2adr],	A

	ldh	A,	[t_tail1adr+1]	;take one round
	ldh	[t_tail2adr+1],	A	; and spin it around

	jp	mUpdHead1adr	;a little twist....
						;if we need to digest a score, we need to continue here
						; so now perform a jump, so that someone else can digest
						; our score


    INCLUDE "sound/digest.asm"

	xor	A				;Finally, hide our tail-2 sprite
	ld	[o_tail2x],	A	; it will only bug anyway
