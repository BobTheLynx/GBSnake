;-------Update bonus----------------------------------------------------------;

	ldh	A,	[g_bonusadr]
	ld	L,	A
	ldh	A,	[g_bonusadr+1]
	or	A,	D
	ld	H,	A		
	ld	A,	[HL]
	ld	[g_bonuschr],	A
