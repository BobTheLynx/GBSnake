;reset sound registers
	ld	A,$80
	ldh	[$ff26],A	; Turn all sound on

	ld	A,$ff
	ldh	[$ff25],A	; Route all sound everywhere

	ld	A,$77
	ldh	[$ff24],A	; Master volume = full
	
	xor	A
	ldh	[$10],A		; No sweep for ch1
	ldh	[$1c],A		; CH3 level

	ld	A,	$18		; CH4 parameters
	ldh	[$FF20],	A	;Lenght: 24

	ld	A,	$F3
	ldh	[$FF21],	A	;Enveloppe: start=F down len=3


	ld	A,$40		; 50% duty
	ldh	[$11],A
	ld	A,$80		; 50% duty
	ldh	[$16],A

	ld	A,$94		; Volume envelope
	ldh	[$12],A
	ldh	[$17],A


	xor	A
	ldh	[rIF],	A	;clear flags
	ld	A,	D
	ldh	[rIE],	A	;re-set old interrupt flag
