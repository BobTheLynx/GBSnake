    PUSHS
    
    SECTION	FRAGMENT "Highscore",WRAM0[$C100]

s_scores::	DS	24	; the highscore

    SECTION	FRAGMENT "HighVariables",HRAM

v_desty:	DS	1	;= 0	the destination scroll (x00 for even levels, x80 for odd levels and title screen)
g_level:	DS	1	;= 0	the current level


    SECTION FRAGMENT "InitVariables0", ROM0
	ldh	[v_desty],	A
	ldh	[g_level],	A
	

    POPS


;--- Save Scores --------------------------------------------------------------;
	ldh	A,	[g_level]
	ld	L,	A
	add	A,	L
	add	A,	L
	ld	HL,	s_scores
	add	A,	L
	ld	L,	A

	ld	A,	[$9C30]
	cp	A,	gLVL1
	jp	Z,	.ignoreScore

	ld	[HL+],	A
	ld	A,	[$9C31]
	ld	[HL+],	A
	ld	A,	[$9C32]
	ld	[HL+],	A

.ignoreScore:

;--- Increase Level ------------------------------------------------------------;

	ldh	A,	[g_level]
	inc	A
	and	$7
	ldh	[g_level],	A


;--- Reload Scores ------------------------------------------------------------;
	ldh	A,	[g_level]
	ld	L,	A
	add	A,	L
	add	A,	L
	ld	HL,	s_scores
	add	A,	L
	ld	L,	A

	ld	A,	[HL+]
	ld	[$9C30],	A
	ld	A,	[HL+]
	ld	[$9C31],	A
	ld	A,	[HL+]
	ld	[$9C32],	A

	ldh	A,	[v_desty]
	cp	$0
	jp	nz,	.otherone
	ld	A,	$9A
	ldh	[g_vidBase],	A

	ld	A,	$80
	jp	.endone

.otherone:
	ld	A,	$98
	ldh	[g_vidBase],	A

	ld	A,	$00

.endone:
	ldh	[v_desty],	A
