    PUSHS
    

    SECTION	FRAGMENT "HighVariables",HRAM

;-------Head Related-----------------------------------------------------------;

h_head1dirH:	DS	1	;= 1	horizontal direction head 1
h_head1dirV:	DS	1	;= 0	vertical direction head 1


    SECTION FRAGMENT "ResetVariables0", ROM0
    
	ldh	[h_head1dirV],	A
	
	
    SECTION FRAGMENT "ResetVariables1", ROM0
    
	ldh	[h_head1dirH],	A
	

    POPS
    

;=== Keys =====================================================================;
; TODO:	if you release the key you are heading in, and you hold another key,
;  go in the direction of the key you hold. This way, the game reacts the right
;  way if you like to hold your keys

mUpdKeys:
	ldh	A,	[h_head1dirH]	;look if we were going horizontal
	cp	$0					; if not...
	jp	Z,	.goingVertiNow	; ... then go vertical

	ldh	A,	[b_evV]			;check if any of all those vertical keys were pressed
	cp	A,	$00				; if nothing...
	jp	Z,	.noHoriEvent	; ...then damn it

	ldh	[h_head1dirV],	A	;load the new vertical direction as our new direction
	xor	A
	ldh	[h_head1dirH],	A	; and clear our old horizontal direction
	ldh	[b_evV],	A		; as well as the vertical key event

	jp	mUpdKeysEnd			; and then we are done

.noHoriEvent:				;if no vertical keys were pressed
	xor	A	
	ldh	[b_evH],	A		; then clear the horizontal keys too
	jp	mUpdKeysEnd			; and then we are done


.goingVertiNow: 			;we are now going vertical
	ldh	A,	[b_evH]			;check if any of those crazy horizontal keys were pressed
	cp	A,	$00				; if nothing...
	jp	Z,	.noVertiEvent	; ...well, don't give a fuck, actually

	ldh	[h_head1dirH],	A	;load the new horizontal direction as our new direction
	xor	A
	ldh	[h_head1dirV],	A	; and clear our old vertical direction
	ldh	[b_evH],	A		; as well as the horizontal key event

	jp	mUpdKeysEnd			; and we are done
	
.noVertiEvent:				;if no horizontal keys were pressed
	xor	A					
	ldh	[b_evV],	A		; then clear the vertical keys too

mUpdKeysEnd:					; and we are done
