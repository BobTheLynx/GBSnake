	ld	A,	$56			;play the basket falling sound
	ldh	[$FF22],	A	;Freq=0x56
	ld	A,	$F8
	ldh	[$FF21],	A	;Enveloppe: start=F up
	ld	A,	32		
	ldh	[$FF20],	A	;Lenght: 32
	ld	A,	$C0
	ldh	[$FF23],	A	;Fire single
