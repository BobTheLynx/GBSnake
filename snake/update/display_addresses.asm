;--- Update Head-1 ; decode address -------------------------------------------;

mUpdHead1adr:

	;convert Head-1 pos to display address for VBlank routine
	ldh	A,	[h_head1y]		; get row
	swap	A				; *16
	rlc	A					; *32
	ld	C,	A				; save result for later
	and	$03					; calc MSB VRAM row start
	ldh	[h_head1adr+1],	A	; set MSB of VRAL ptr
	ld	A,	$E0				; LSB VRAM row start mask
	and	C					; calc LSB VRAM row start
	ld	C,	A				; save LSB VRAM row start
	ldh	A,	[h_head1x]		; get column
	add	A,	C				; add LSB VRAM row start
	ldh	[h_head1adr],	A	; set MSB of VRAL ptr


;--- Update Tail-1 ; decode address -------------------------------------------;

	;convert Tail-1 pos to display address for VBlank routine
	ldh	A,	[t_tail1y]		; get row
	swap	A				; *16
	rlc	A					; *32
	ld	C,	A				; save result for later
	and	$03					; calc MSB VRAM row start
	ldh	[t_tail1adr+1],	A	; set MSB of VRAL ptr
	ld	E,	A
	ld	A,	$E0				; LSB VRAM row start mask
	and	C					; calc LSB VRAM row start
	ld	C,	A				; save LSB VRAM row start
	ldh	A,	[t_tail1x]		; get column
	add	A,	C				; add LSB VRAM row start
	ldh	[t_tail1adr],	A	; set MSB of VRAL ptr
