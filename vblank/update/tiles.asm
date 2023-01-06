;-------Update Animated Tiles--------------------------------------------------;

	ld	DE,	$9000	;Tile base address
	ldh	A,	[v_time]	;look to the time
	swap	A
	and	7
	ld	B,	A	;Save time
	call	snkAnim		;Animate snake

	ld	D,	$9C	;Load base address destination message
	ld	HL,	g_message

	ld	A,	B	;Load tile indicated by time
	add	A,	$26	;to address + $9C26
	ld	E,	A

	ld	A,	B
	add	A,	L	;Source= [message+time]
	ld	L,	A

	ld	A,	[HL]	;Load from source...
	ld	[DE],	A	;... to destination
