;-------Update Corpse----------------------------------------------------------;

	ldh	A,	[h_head1adr]
	ld	L,	A
	ldh	A,	[h_head1adr+1]
	or	A,	D
	ld	H,	A	;load address Head-1

	ld	A,	[HL]	;lookup what we are eating
	ldh	[v_eating],	A

	ldh	A,	[h_head2adr]
	ld	L,	A
	ldh	A,	[h_head2adr+1]
	or	A,	D
	ld	H,	A	;load address Head-2


	ld	A,	1	;colorify
	ldh	[$FF4F],A	;Set vbank 1

	xor	A
	ld	[HL],	A
	ldh	[$FF4F],A	;Set vbank 0

	ldh	A,	[v_corpse]	;load our corpse
	ld	[HL],	A	;...at that address

.freezecorpse:
