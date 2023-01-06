;-------Initialize Palettes----------------------------------------------------;

iIniPal:

	ld	a,	%11100100	; palette colors from darker to
						;  lighter, 00 01 10 11
	ldh 	[rBGP],	a		; write this at the background palette register
	ldh	[rOBP0],a		;  and at the sprites palette register
	ldh	[rOBP1],a		;

