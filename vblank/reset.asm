;--- Clear Screen -------------------------------------------------------------;

	ldh	A,	[a_appleadr]
	ld	L,	A
	ldh	A,	[a_appleadr+1]
	or	A,	$98
	ld	H,	A

	ld	A,	[HL]
	cp	A,	gAPPLE
	jp	NZ,	.noappleupd

	ld	A,	gEMPTY
	ld	[HL],	A

.noappleupd:
	ldh	A,	[h_head2adr]
	ld	L,	A
	ldh	A,	[h_head2adr+1]
	or	A,	$98
	ld	H,	A

	ld	A,	gEMPTY
	ld	[HL],	A

	ldh	A,	[a_appleadr]
	ld	L,	A
	ldh	A,	[a_appleadr+1]
	or	A,	$98
	ld	H,	A

	ld	A,	[HL]
	cp	A,	gAPPLE
	jp	NZ,	.noappleupd2
	ld	A,	gEMPTY
	ld	[HL],	A
.noappleupd2:

	ld	A,	H
	or	A,	$9A
	ld	H,	A

	ld	A,	[HL]
	cp	A,	gAPPLE
	jp	NZ,	.noappleupd3

	ld	A,	gEMPTY
	ld	[HL],	A
.noappleupd3:

	;give the tail a trail to follow
	ld	A,	$9		
	ld	[$98EA], A	;bank 0
	ld	[$9AEA], A	;bank 1
	ld	[$98E9], A	;bank 0
	ld	[$9AE9], A	;bank 1
