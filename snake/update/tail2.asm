;--- Calculate Sprite Tail-2 --------------------------------------------------;
; TODO: fix bug with tail sprite heading in wrong direction when wrapping around

tUpdSpr2:
	ldh	A,	[t_tail2x]	;look if the second bit of tail
	ld	B,	A			; is futher left or right 
	ldh	A,	[t_tail1x]	; then the first bit of tail
	sub	A,	B			;if it ain't the case
	jp	Z,	.goingverti	; we are probably going vertical

	cp	A,	$FF			;if we are going left
	jp	Z,	.goingleft	; then go to the routine for it
	cp	A,	19			;if we are going left and wrapping around
	jp	Z,	.goingleft	; then go to the routine for it

.goingright:				;else we are going right
	ld	A,	$D8			; so load $D8 as sprite
	jp	.endcalclr		; and we are done

.goingleft:				;if we are going left
	ld	A,	$C8			; load $C8 as sprite

.endcalclr:				;and end the calculation
	jp	.endcalc


.goingverti:				;if we are going vertically
	ldh	A,	[t_tail2y]	; look if the second bit of tail
	ld	B,	A			; is futher down
	ldh	A,	[t_tail1y]	; then the first but of tail
	sub	A,	B			;if it is the case
	cp	A,	$FF			; then we are probably
	jp	Z,	.goingup	; heading upwards
	cp	A,	15			; if we wrap around take that
	jp	Z,	.goingup	; in account too

	ld	A,	$F8			;else, $F8 is the tile
	jp	.endcalc		; so now end the calc

.goingup:				;if we are going up
	ld	A,	$E8			; $E8 is the tile

.endcalc:
	ld	[v_tail2chr],	A	;save it as the char for our sprite
	
