    PUSHS

    SECTION	FRAGMENT "Sprites", WRAM0, ALIGN[2]

;-------Head Sprites-----------------------------------------------------------;

o_head1y:	    DS 1	; head1 Y position
o_head1x:	    DS 1	; head1 X position
o_head1chr::    DS 1	; head1 chr
o_head1attr::	DS 1	; head1 attributes

o_head2y:	    DS 1	; head2 Y position
o_head2x:	    DS 1	; head2 X position
o_head2chr::    DS 1	; head2 chr
o_head2attr::	DS 1	; head2 attributes

;-------Tail Sprites-----------------------------------------------------------;

o_tail1y:   	DS 1	; tail1 Y position
o_tail1x:   	DS 1	; tail1 X position
o_tail1chr::	DS 1	; tail1 chr
o_tail1attr::	DS 1	; tail1 attributes

o_tail2y:   	DS 1	; tail2 Y position
o_tail2x:   	DS 1	; tail2 X position
o_tail2chr:: 	DS 1	; tail2 chr
o_tail2attr::	DS 1	; tail2 attributes


;------------------------------------------------------------------------------;

    POPS
    
;------------------------------------------------------------------------------;

;=== Sprite Positions =========================================================;

	ldh	A,	[v_corpse]		;If the head is frozen,
	cp	$FF					; then don't update it
	jp	Z,	dontUpdHead2


;--- Update Head-2 ; just copy from Head-1 ------------------------------------;

vUpdPosH2:
	ld	A,	[o_head1x]		;get the old position from the Head-1
	ld	[o_head2x],	A		; and make it now the new position for the Head-2

	ld	A,	[o_head1y]		;ditto with the vertical position
	ld	[o_head2y],	A


;--- Update Head-1 ; *8+8 from Address ----------------------------------------;

vUpdPosH1:
	ldh	A,	[h_head1x]		;get the horizontal tile position for the head
	rla
	inc	A
	rla
	rla						; multiply it with 8, and add the sprite base offset
	ld	[o_head1x],	A		; and save it back

	ldh	A,	[h_head1y]		;ditto with the vertical tile position
	inc	A
	inc	A
	rla
	rla
	rla
	ld	[o_head1y],	A


dontUpdHead2:				;if the head is OK
	ldh	A,	[t_freeze]		; does that means that the tail is OK too?
	cp	$0
	jp	NZ,	mDigestScore	; if no, then it shouldn't move


;--- Update Tail-2 ; just copy from Tail-1 ------------------------------------;

	ld	A,	[o_tail1x]		;remember the Head-2 positions?
	ld	[o_tail2x],	A		; this is basically the same routine

	ld	A,	[o_tail1y]		;you just take the old one for the first
	ld	[o_tail2y],	A		; and put it down as the new one for the second


;--- Update Tail-1 ; *8+8 from Address ----------------------------------------;

	ldh	A,	[t_tail1x]		;get the horizontal tile position for the tail
	inc	A
	rla
	rla
	rla						; multiply it with 8, and add the sprite base offset
	ld	[o_tail1x],	A		; and save it back

	ldh	A,	[t_tail1y]		;ditto with the vertical tile position
	inc	A
	inc	A
	rla
	rla
	rla
	ld	[o_tail1y],	A
