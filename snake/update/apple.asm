;--- Update Apple ; decode address --------------------------------------------;
	;magic routine to convert X,Y into address

	ldh	A,	[a_appley]		; get row
	swap	A				; *16
	rlc	A					; *32
	ld	C,	A				; save result for later
	and	$03					; calc MSB VRAM row start
	ldh	[a_appleadr+1],	A	; set MSB of VRAL ptr
	ld	A,	$E0				; LSB VRAM row start mask
	and	C					; calc LSB VRAM row start
	ld	C,	A				; save LSB VRAM row start
	ldh	A,	[a_applex]		; get column
	add	A,	C				; add LSB VRAM row start
	ldh	[a_appleadr],	A	; set MSB of VRAL ptr
