;-------Animate Window---------------------------------------------------------;

	ldh	A,	[rWY]
	cp	129
	jp	c,	.dontscroll
	dec	A
	ldh	[rWY],	A
.dontscroll:

	call gUpdSprites
