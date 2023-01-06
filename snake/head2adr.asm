;--- Update Head-2 ; decode address -------------------------------------------;
hUpd2Adr:
	;convert position to address
	ldh	A,	[h_head2y]		; get row
	swap	A				; *16
	rlc	A					; *32
	ld	C,	A				; save result for later
	and	$03					; calc MSB VRAM row start
	ldh	[h_head2adr+1],	A	; set MSB of VRAL ptr
	ld	A,	$E0				; LSB VRAM row start mask
	and	C					; calc LSB VRAM row start
	ld	C,	A				; save LSB VRAM row start
	ldh	A,	[h_head2x]		; get column
	add	A,	C				; add LSB VRAM row start
	ldh	[h_head2adr],	A	; set MSB of VRAL ptr
