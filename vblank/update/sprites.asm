    PUSHS
 
;-------Update sprites---------------------------------------------------------;
    
    SECTION FRAGMENT "Routines", ROM0
    
    
    
gUpdSprites:
;-------Increase Sprites for Head----------------------------------------------;

vIHead:

	ldh	A,	[v_corpse]
	cp	$FF
	jp	Z,	.freezehead	;if head is frozen, don't update it

	ldh	A,	[v_eating]	;look if we ain't eating something
	cp	A,	gEMPTY
	jp	Z,	.updhead1normally
	cp	A,	gGRASS
	jp	Z,	.updhead1normally ; because then we update it normally

	ldh	A,	[v_head1chr]	;look if we are heading upwards
	and	A,	$20
	jp	NZ,	.updhead1normally

	ldh	A,	[v_head1chr]	;load normal head
	and	A,	$10		; look what direction we are looking
	
	sra	A			; divide by 2
	ld	H,	A		;store it temporary

	ld	A,	B		;look at the time
	or	A,	H		;add the head dir
	ld	[o_head1chr],	A	;and store it as the head
	xor	A
	ld	[o_head1attr],	A	;but store 0 as the head attributes
	jp	.vIHead1End		; and end

.updhead1normally:

	ld	H,	$40

	ld	A,	[v_head1chr]	;increase char for head-1...
	and	A,	$F8
	or	A,	B
	ld	L,	A
	ld	A,	[HL]
	ld	[o_head1chr],	A
	inc	H
	ld	A,	[HL]
	ld	[o_head1attr],	A

.vIHead1End:
	ld	A,	[h_eated]	;look if we did just eat air
	cp	A,	gEMPTY
	jp	Z,	.updhead2normally
	cp	A,	gGRASS
	jp	Z,	.updhead2normally ; because then we update it normally
	
	ld	A,	B
	and	A,	$4	;look if we are too early
	jp	Z,	.updhead2normally

	ld	HL,	g_mapeaten

	ld	A,	[v_head2chr]	;load head 2 char
	and	A,	$F0
	swap	A
	ld	L,	A	;lookup table

	ld	A,	[HL]	;load from table
	ld	L,	A

	ld	A,	B	;add time
	dec	A
	sra	A		;/2
	and	A,	$1	;&1
	or	A,	L	;add head

	ld	[o_head2chr],	A	;and store it as the head
	xor	A
	ld	[o_head2attr],	A	;but store 0 as the head attributes
	jp	.vIHead2End		; and end

.updhead2normally:

	ld	H,	$40

	ld	A,	[v_head2chr]	;... and for head-2
	and	A,	$F8
	or	A,	B
	ld	L,	A
	ld	A,	[HL]
	ld	[o_head2chr],	A
	inc	H
	ld	A,	[HL]
	ld	[o_head2attr],	A
.vIHead2End:
.freezehead:
.vIHeadEnd:


;-------Increase Sprites for Tail----------------------------------------------;

vITail:
	ldh	A, [t_freeze]
	cp	$0
	jr	nz, .vTailEnd	;if tail is frozen, don't update it

	ld	H,	$40

	ld	A,	[v_tail1chr]
	and	A,	$F8
	or	A,	B
	ld	L,	A
	ld	A,	[HL]
	ld	[o_tail1chr],	A
	inc	H
	ld	A,	[HL]
	ld	[o_tail1attr],	A

	ld	H,	$40

	ld	A,	[v_tail2chr]
	and	A,	$F8
	or	A,	B
	ld	L,	A
	ld	A,	[HL]
	ld	[o_tail2chr],	A
	inc	H
	ld	A,	[HL]
	ld	[o_tail2attr],	A

.vTailEnd:
	ret
	
;-------End--------------------------------------------------------------------;
	
	POPS
