
.ischerry:
	ld	A,	$FC		;make it a basket
	ld	[o_bonuschr],	A
	ld	A,	$3
	ld	[o_bonusattr],	A

	ldh	A,	[RANDOM]	;randomnize the level at which the bonus appears
	and	A,	$3	; between 3 and 7
	add	A,	$3
	ld	[g_bonusniv],	A
	call	gIncScore
	call	gIncScore
	call	gIncScore
	call	gIncScore
	call	gIncScore
	
	INCLUDE "sound/cherry.asm"
