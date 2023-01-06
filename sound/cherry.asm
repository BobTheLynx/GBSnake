
	ld	A,	$0C			;play the cherry sound
	ldh	[$FF22],	A	;Freq=0x0D
	ld	A,	$F8
	ldh	[$FF21],	A	;Enveloppe: start=F up
	ld	A,	24		
	ldh	[$FF20],	A	;Lenght: 24
	ld	A,	$C0
	ldh	[$FF23],	A	;Fire single
