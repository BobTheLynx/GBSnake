;-------Score------------------------------------------------------------------;

	;finally, update score
	ldh	A,	[m_rstcnt]
	cp	A,	$FF
	jp	NZ,	.noupdscore	;if resetting, don't update score

	ldh	A,	[s_score]	;else, update score
	ld	[$9C21],	A
	ldh	A,	[s_score+1]
	ld	[$9C22],	A
	ldh	A,	[s_score+2]
	ld	[$9C23],	A

.noupdscore:
