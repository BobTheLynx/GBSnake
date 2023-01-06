    ld	A,	$0B			;play the powerup sound
	ldh	[$FF22],	A	;Freq=0x0B
	
	ld	A,	$F8
	ldh	[$FF21],	A	;Enveloppe: start=F up
	
	ld	A,	32		
	ldh	[$FF20],	A	;Lenght: 32
	
	ld	A,	$C0
	ldh	[$FF23],	A	;Fire single
