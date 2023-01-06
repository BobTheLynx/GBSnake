
;--- Calculate Sprite Head-2 --------------------------------------------------;
;TODO: transform this in a simple table lookup

hCalcSpr2:
	ldh	A,	[h_head2dirH]	;look if we were heading horizontally,
	cp	$0					; if not,
	jp	Z,	.goingverti		;  then this is the wrong place to be

	dec	A					;look if we were heading right
	jp	Z,	.goingright		; if so, execute the code for it

.goingleft:					;else, we are heading leftwards
	ldh	A,	[v_head1dirnum]	;now compare with the new head direction
	cp	A,	$00				; if they aren't the same...
	jp	NZ,	.left2verti		; ... then there is special code for them

	ld	A,	$80				;else, it is just tile $80
	jp	.endcalc			; so end this thing


.goingright:					;if we were heading right
	ldh	A,	[v_head1dirnum]	; compare with the new head direction
	cp	A,	$10				; if they aren't the same
	jp	NZ,	.right2verti	; then that is such a shame

	ld	A,	$90				;else, just load $90
	jp	.endcalc			; and it is OK


.goingverti:					;if we were heading vertically
	ldh	A,	[h_head2dirV]	; look if we are heading down
	dec	A
	jp	Z,	.goingdown		; if it is the case, go to the code specific for it

.goingup:					;else, we are heading upwards
	ldh	A,	[v_head1dirnum]	;now compare with the new head direction
	cp	A,	$20				; if they aren't the same...
	jp	NZ,	.up2hori		; ... then there is special code for them

	ld	A,	$A0				;else, just load $A0
	jp	.endcalc			; and lay it down


.goingdown:					;if we are heading down
	ldh	A,	[v_head1dirnum]	; compare with the new head direction
	cp	A,	$30				; if that isn't ok,
	jp	NZ,	.down2hori		; call the magic fixing machine

	ld	A,	$B0				;else, just load $B0
	jp	.endcalc			; and we are done


.left2verti:				;if we did go left, and now we go vertically
	or	A,	$20				; then do some secret bit-hackery on it
	jp	.endcalc			;  and guess what? the right tile!

.right2verti:				;if we did go right, and now we go vertically
	or	A,	$60				; then the magic bitmask is $60
	jp	.endcalc			; and we are fine

.down2hori:					;if we did go down, and now we flow to horizontal
	or	A,	$40				; then set the 6th bit of our byte
	jp	.endcalc			; and that's all

.up2hori:					;if we did go up, and now we fall down to horizontal
	;or	A,	$00				; then the magic bitmask... oh, fuck!
	;jp	.endcalc			; whatever

.endcalc:
	ld	[v_head2chr],	A	;finally, save the tile

dontUpdHead:				;end of our eventual skip
