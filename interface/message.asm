    PUSHS
    

    SECTION	FRAGMENT "Highscore", WRAM0

g_message::	DS	8	; the current message (yes, that one in the window
					;  saying you just lost the game!)

 
;-------Draw Message-----------------------------------------------------------;
    
    SECTION FRAGMENT "Routines", ROM0
    

gDrawMessage:
	ld	HL,	g_message	;destination
	cp	A,	$0			;if 0,
	jp	Z,	drawEmpty	; then draw empty message
	dec	A
	sla	A
	sla	A
	sla	A
	add	$60				;message= (index-1)*8 + 60

drawMessage:
	ld	B,	$8			;number of bytes to copy
.loop:
	ld	[HL+],	A		;copy to destination
	inc	A				;increase char pointer
	dec	B				;decrease counter
	jp	NZ,	.loop		; and loop
	ret

drawEmpty:
	ld	A,	gEMPTY		;load the heir of nothingness
	ld	B,	$8			; and its 8 brothers
.loop:
	ld	[HL+],	A		;send them to outer space
	dec	B				;jump to another plane of existance
	jp	NZ,	.loop		; and fire again

	ret
	
;-------End--------------------------------------------------------------------;
	
	POPS
