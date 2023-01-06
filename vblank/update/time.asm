;-------Update Time------------------------------------------------------------;


	ldh	A,	[v_time]
	ld	D,	A
	ldh	A,	[v_speed]
	add	A,	D
	ldh	[v_time],	A
