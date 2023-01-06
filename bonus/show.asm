
	;--- check if we need to show an bonus ---
	ld	A,	[HL]
	inc	A
	ld	B,	A
	ld	A,	[g_bonusniv]
	or	A,	$30
	cp	A,	B
	jp	nz,	.dontUpdbonus

	INCLUDE "sound/powerup.asm"

	call	mPosbonus
	jp	mUpdTimer2

.dontUpdbonus:
    INCLUDE "sound/speedup.asm"

    INCLUDE "bonus/disable.asm"
