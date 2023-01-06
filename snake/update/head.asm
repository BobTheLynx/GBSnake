    PUSHS

    SECTION	FRAGMENT "HighVariables",HRAM

;-------Head Related-----------------------------------------------------------;

h_head1x:	DS	1	;=10	horizontal position head 1
h_head1y:	DS	1	;= 7	vertical position head 1
h_head2x:	DS	1	; 		horizontal position head 2
h_head2y:	DS	1	; 		vertical position head 2
v_head1dirnum:	DS	1	; a temporary variable
	
    SECTION FRAGMENT "ResetVariables", ROM0

	ld	A,	7
	ldh	[h_head1y],	A
	

	ld	A,	10
	ldh	[h_head1x],	A
	

    POPS
    

;--- Set pos head 2 to pos head 1 ---------------------------------------------;

tUpdateHead:
	ldh	A,	[h_head1x]	;pretty straightforward
	ldh	[h_head2x],	A	; now, do you want me to talk about møøze?

	ldh	A,	[h_head1y]	;come take a holiday
	ldh	[h_head2y],	A	; I know that you need it! 


;--- Calculate Sprite and Position Head-1 -------------------------------------;

hCalcSpr1:
	ldh	A,	[h_head1dirH]	;look if we are going horizontal-wards
	ld	B,	A
	cp	$0
	jp	Z,	.goingverti		; if not, perform code for vertical movement instead

	dec	A					;look if we are going rightwards
	jp	Z,	.goingright		; if so, go rightwards

	ldh	A,	[h_head1x]		;else, update head position
	call gGoLeft			; using an external function
	ldh	[h_head1x],	A		; and store it back

	ld	A,	$00				;save $00 as our direction number
	ldh	[v_head1dirnum],	A

	ld	A,	$C0				;and $C0 as our sprite number
	jp	.endcalc


.goingright:					;if we are going rightwarDS indeed,
	ldh	A,	[h_head1x]		; then update head position
	call gGoRight			; using an external function
	ldh	[h_head1x],	A		; and store it back

	ld	A,	$10				;save $10 as our direction number
	ldh	[v_head1dirnum],	A

	ld	A,	$D0				;and $D0 as our sprite number
	jp	.endcalc


.goingverti:				;if we are going vertical-wards
	ldh	A,	[h_head1dirV]	; look if we are going down
	ld	C,	A
	dec	A					;if this is the case
	jp	Z,	.goingdown		; then just do that

	ldh	A,	[h_head1y]		;else we are going up
	call gGoUp				; thanks to an external function
	ldh	[h_head1y],	A		;

	ld	A,	$20				;save $20 as our direction number
	ldh	[v_head1dirnum],	A

	ld	A,	$E0				;and $E0 as our sprite number
	jp	.endcalc


.goingdown:					;if we are going downwards
	ldh	A,	[h_head1y]		; then update the head position
	call gGoDown			; thanks to some external magic
	ldh	[h_head1y],	A		;

	ld	A,	$30				;save $30 as our direction number
	ldh	[v_head1dirnum],	A

	ld	A,	$F0				;and $F0 as our sprite number
	jp	.endcalc


.endcalc:
	ld	[v_head1chr],	A	;save our sprite number
