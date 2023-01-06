    PUSHS

    SECTION	FRAGMENT "Sprites", WRAM0, ALIGN[2]

;-------bonus Sprites---------------------------------------------------------;

o_bonusy::   	DS 1	; bonus y position
o_bonusx::   	DS 1	; bonus x position... 0 is disable
o_bonuschr::	DS 1	;=FC
o_bonusattr::   DS 1	;=0


    SECTION FRAGMENT "ResetVariables0", ROM0
    
	ld	[o_bonusy],	A
	ld	[o_bonusx],	A
	
	
    SECTION FRAGMENT "ResetVariables", ROM0

	ld	A,	$FC
	ld	[o_bonuschr],	A
    
	ld	A,	3
	ld	[o_bonusattr],	A
	
 
;---- position bonus ------------------------------------------------------;
    
    SECTION FRAGMENT "Routines", ROM0
        

mPosbonus:

	ldh	A,	[RANDOM]	;position it at a random position
	ld	B,	A
	and	A,	$F
	add	A,	$2

	ld	D,	A

	inc	A
	rla
	rla
	rla		
	ld	[o_bonusx],	A

	ld	A,	B
	swap	A
	and	A,	$F
	ld	E,	A
	inc	A
	inc	A
	rla
	rla
	rla
	ld	[o_bonusy],	A
	

	;convert bonus pos to display address
	ld	A,	E			; get row
	swap	A				; *16
	rlc	A				; *32
	ld	C,	A			; save result for later
	and	$03				; calc MSB VRAM row start
	ldh	[g_bonusadr+1],	A	; set MSB of VRAL ptr
	ld	E,	A
	ld	A,	$E0			; LSB VRAM row start mask
	and	C				; calc LSB VRAM row start
	ld	C,	A			; save LSB VRAM row start
	ld	A,	D			; get column
	add	A,	C			; add LSB VRAM row start
	ldh	[g_bonusadr],	A	; set MSB of VRAL ptr

	ret
							
	
;-------End--------------------------------------------------------------------;
	
	POPS
