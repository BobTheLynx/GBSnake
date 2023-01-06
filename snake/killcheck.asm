;--- Kill head if neaded ------------------------------------------------------;

	ldh	A,	[v_corpse]		;if head is already death
	cp	$FF					; then leave it alone
	jp	Z,	.nokill

	ldh	A,	[v_eating]		;if we are eating an apple
	cp	gAPPLE				; then don't poison ourself
	jp	Z,	.nokill
	cp	gEMPTY				;if we eat the terrain
	jp	Z,	.nokill			; then there is nothing wrong
	cp	gGRASS				;if we eat grass
	jp	Z,	.nokill			; we won't get sick

.dokill:						;if we did kill ourself
	ld	A,	$FF				; then sign our death contract
	ld	[v_corpse],	A

	ld	A,	[v_head1chr]	;clean our sprites
	dec	A
	ld	[v_head1chr],	A

	ld	A,	[v_head2chr]	;mummify our corpses
	dec	A
	ld	[v_head2chr],	A

;-------Play Dying Sound-------------------------------------------------------;

	INCLUDE "sound/die.asm"

	ld	A,	$1			; and draw our RIP
	call	gDrawMessage

	ld	A,	[v_speed]	;Speed up the rolldown
	ld	B,	A
	add	B
	add	B
	srl	A			;*1.5
	cp	A,	$0		;speed should never go to 0
	jp	Z,	.noupdspeed
	ld	[v_speed],	A
.noupdspeed:

;-------Digest what we did eat-------------------------------------------------;

.nokill:
