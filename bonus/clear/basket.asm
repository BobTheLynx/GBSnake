	ldh	A,	[RANDOM]	;dispence a random load of apples
	and	A,	$3
	add	A,	$3
	ld	[a_dispencer],	A
	ld	A,	$4
	ld	[o_bonusattr],	A
	ld	A,	$FD		;make it a cherry
	ld	[o_bonuschr],	A

	ldh	A,	[RANDOM]	;randomnize the level at which the bonus appears
	and	A,	$1	; between 8 and 9
	add	A,	$8
	ld	[g_bonusniv],	A
