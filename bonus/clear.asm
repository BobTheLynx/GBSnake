	;look if we need to clear the bonus
	ldh	A,	[h_head2adr]
	ld	B,	A
	ld	A,	[g_bonusadr]
	cp	A,	B
	jp	NZ,	.notClearbonus

	ldh	A,	[h_head2adr+1]
	ld	B,	A
	ld	A,	[g_bonusadr+1]
	cp	A,	B
	jp	NZ,	.notClearbonus

	xor	A	;clear bonus
	ld	[o_bonusx],	A	; by positioning it offscreen
	ld	A,	$98
	ld	[g_bonusadr],	A
	ld	[g_bonusadr+1],	A

	;check if it is a basket or a cherry
	ld	A,	[o_bonuschr]
	cp	A,	$FC	
	jp	Z,	.isbasket
	
	INCLUDE "bonus/clear/cherry.asm"
	
	jp	.endbasket
				
.isbasket:			;if it is a basket
    INCLUDE "bonus/clear/basket.asm"
    
.endbasket:

.notClearbonus:
