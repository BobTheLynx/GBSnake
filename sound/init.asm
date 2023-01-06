;-------Initialize Sound-------------------------------------------------------;
iSound:
	xor	A
	ldh	[$ff26],A	; Turn all sound on
	nop				;  wait for it to damn stabilize
	nop
	nop
	nop
	
	ld	A,$80
	ldh	[$ff26],A	; Turn all sound on

	ld	A,$ff
	ldh	[$ff25],A	; Route all sound everywhere

	ld	A,$77
	ldh	[$ff24],A	; Master volume = full
	
	xor	A
	ldh	[$10],A		; No sweep for ch1
	ldh	[$1c],A		; CH3 level off

	ld	A,$40		; 25% duty
	ldh	[$11],A		;  for CH1
	ld	A,$80		; 50% duty
	ldh	[$16],A		;  for CH2

	ld	A,$94		; Volume envelope
	ldh	[$12],A		;  for CH1
	ldh	[$17],A		;  for CH2
