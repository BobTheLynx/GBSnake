
	ld	A,	$0A			;play the speed-up sound
	ldh	[$FF22],	A	;Freq=0x0B
	
	ld	A,	$F8
	ldh	[$FF21],	A	;Enveloppe: start=F up
	
	ld	A,	12		
	ldh	[$FF20],	A	;Lenght: 12
	
	ld	A,	$C0
	ldh	[$FF23],	A	;Fire single
