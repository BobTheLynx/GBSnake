;-------Play an Apple Eating Sound---------------------------------------------;

	ld	A,	$55
	ldh	[$FF22],	A	;Freq=0x55
	ld	A,	$F2
	ldh	[$FF21],	A	;Enveloppe: start=F down len=3
	ld	A,	$18		;
	ldh	[$FF20],	A	;Lenght: 24
	ld	A,	$C0
	ldh	[$FF23],	A	;Start single
