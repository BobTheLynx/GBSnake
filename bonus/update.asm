;--- Update bonus-------------------------------------------------------------;
	;look if there is a bonus
	ld	A,	[o_bonusx]
	cp	A,	$0
	jp	Z,	.nobonus

    INCLUDE "bonus/clear.asm"
    
	;look if we need to repos the bonus
	ldh	A,	[g_bonuschr]
	cp	A,	gEMPTY
	jp	Z,	.notUpdbonus
	cp	A,	gGRASS
	jp	Z,	.notUpdbonus
	cp	A,	$FC
	jp	Z,	.notUpdbonus

	call	mPosbonus
.notUpdbonus:
.nobonus:
