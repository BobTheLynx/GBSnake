    PUSHS


    SECTION	FRAGMENT "HighVariables",HRAM

v_corpse::	DS	1	;= 9	tile generated as corpse


    SECTION FRAGMENT "ResetVariables", ROM0

	ld	A,	9
	ldh	[v_corpse],	A


    POPS


;--- Draw Corpse --------------------------------------------------------------;

hDrawCorpse:
	ld	A,	[v_head2chr]	;the corpse is the head sprite
	swap	A				; /16
	and	$F					; %16
	ldh	[v_corpse],	A		;


	ldh	A,	[a_ateapple]	;if we didn't ate an apple
	cp	A,	gAPPLE
	jp	NZ,	.noapple		; then skip the next part

	ldh	A,	[v_corpse]		;load corpse tile
	or	A,	%00010000		; and set eggy bit
	ldh	[v_corpse],	A		; (i.e. the eaten tiles)

	xor	A
	ld	[a_ateapple],	A	;finally, confirm that we did eat that apple

.noapple:
