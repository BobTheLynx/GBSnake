;--- Look if the tail didn't die ----------------------------------------------;

tUpdSpr1:
	ldh	A,	[v_trail]
	cp	A,	12			;if the tail touched corpse
	jp	c,	.noapple	; then it wasn't an apple
	cp	A,	$20			;if it did touch an eaten apple
	jp	c,	.nodeath	; then it didn't die

	jp tDie				;else reset the game

.nodeath:				;if it ate apple
	ld	A,	$1			; then freeze it for a jiffy
	ldh	[t_freeze],	A	; as to make it grow
	jp	tUpdSpr1End

.noapple:				;else, no problem mate!

;--- Calculate Sprite Tail-1 --------------------------------------------------;

	ldh	A,	[v_trail]	;similary to how the tile for the corpse was (spr/16)%16
	and	A,	$F		; take care of the eggs
	swap	A			; the sprite for the first tail is trail*16
	or	A,	$8			; and of course we need to add the tail base address too
	ld	[v_tail1chr],	A	;save it back
tUpdSpr1End:
