
;-------Initialize Window------------------------------------------------------;

	ld	A,	128				;position the window at line 128
	ldh	[rWY],	A
	ld	A,	7				; and at the start of the screen
	ldh	[rWX],	A
