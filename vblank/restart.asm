    ld	A,	$09	
	ld	[$98E9], A

	ld	HL,	o_start
	ld	B,	16
	ld	A,	0
.clearOAM:
	ld	[HL+],	A
	dec	B
	jp	NZ,	.clearOAM

	ld	A,	$FF
	ldh	[t_tail2adr],	A

	xor	a
	ldh	[rIF],	a

	ei
	jp	iReset
