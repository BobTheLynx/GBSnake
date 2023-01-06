    PUSHS
    SECTION	FRAGMENT "HighVariables",HRAM
    
v_trail:	DS	1	;= 1	tile under trail


    SECTION FRAGMENT "ResetVariables1", ROM0
	ldh	[v_trail],	A
	

    POPS
    

;-------Update Trail----------------------------------------------------------;
	ldh	A,	[t_tail1adr+1]
	or	A,	D
	ld	H,	A
	ldh	A,	[t_tail1adr]
	ld	L,	A	;load tail address

	ld	A,	[HL]	;lookup what is underneath
	ldh	[v_trail],	A

	cp	A,	12		;look if we are digesting something
	jp	c,	.notailegg	; if not, no problem
	and	$F	; else replace it by a normal corpse
	ld	[HL],	A	;and store it in memory
.notailegg:

	ldh	A,	[t_tail2adr+1]	;then load address of tail
	or	A,	D
	ld	H,	A

	ldh	A,	[t_tail2adr]	; to clear it
	ld	L,	A

;Yvar's secret grass hatcher
	swap	A
	xor	L
	ld	C,	A
	add	C
	add	C
	rra
	and	32
	add	32

	ld	[HL],	A
