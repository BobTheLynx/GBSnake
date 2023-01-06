mUpdTimer2:					;increase our second timer by one
.loop:
	ld	A,	[HL]			;load the old digit
	cp	gTIMER				;if we overflew the low part
	jp	Z,	.increaseSpeed		; speed it up a bit
	cp	gEMPTY
	jp	NZ,	.notempty		;if empty, then replace with 0
	ld	A,	$30
.notempty:
	cp	$3A					;if it is not in the range "0"-"9"
	jp	NC,	endUpdTimer	; then there is some other message in the display
	cp	$30					; so skip the update
	jp	C,	endUpdTimer	; else it will scramble the message
	inc	A					;increase the digit
	ld	[HL],	A			; store it back again
	cp	A,	$3A				;if it isn't larger than "9" now
	jp	NZ,	endUpdTimer	; then we are done
	ld	A,	$30				;else correct our ":" with a "0"
	ld	[HL-],	A			; store it back, decrease the pointer
	jp	.loop				; and update the next digit
.increaseSpeed:


endUpdTimer:
