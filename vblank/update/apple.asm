;-------Update Apple ----------------------------------------------------------;

	ldh	A,	[a_appleadr]
	ld	L,	A
	ldh	A,	[a_appleadr+1]
	or	A,	D
	ld	H,	A		;load the base address for the apple

	ld	A,	[HL]		;look what is in the place now
	cp	gEMPTY			; if it is empty...
	jp	Z,	.noapperror	; ... then no problem
	cp	gGRASS			; if it is grass...
	jp	Z,	.noapperror	; ... then no problem
	cp	gAPPLE			; if it is apple
	jp	Z,	.noapperror	; ... whatever

	ld	A,	42		;else signal an error
	jp	.enderror

.noapperror:
	ld	A,	1		;colorify
	ldh	[$FF4F],A	;Set vbank 1
	ld	A,	3
	ld	[HL],	A

	xor	A
	ldh	[$FF4F],A	;Set vbank 0

	ld	A,	gAPPLE	;load apple at address
	ld	[HL],	A

	xor	A		;signal no apple error
.enderror:
	ldh	[a_error],	A
