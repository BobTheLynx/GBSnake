;-------Init Screen-----------------------------------------------------------;

	;give the tail a trail to follow
	ld	A,	$9	
	ld	[$98E9], A

	;give the window a nice roll-up animation
	ld	A,	144
	ldh	[rWY],	A
