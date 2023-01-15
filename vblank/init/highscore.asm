	ld  A,  $0A
	ld  [EXTRAM_WRENABLE], A  ;enable external ram
	
    ;clear ram if invalid
	ld  A, [Verification]
	and A, $0F
	cp  A, $C
	jp  Z, :+
	
	ld A, $F
	ld [ScoreDigit1], A
	xor A
	ld [ScoreDigit2], A
	ld [ScoreDigit3], A
	
	ld A, $C
	ld [Verification], A
:

	ld	A,	[ScoreDigit1]
	and A, $0F
	add A, $30
	cp A, $3F
	jp NZ, :+
	ld A, gHIGH
:
	ld	[$9C30],	A

	ld	A,	[ScoreDigit2]
	and A, $0F
	add A, $30
	ld	[$9C31],	A

	ld	A,	[ScoreDigit3]
	and A, $0F
	add A, $30
	ld	[$9C32],	A
	
    xor A
	ld  [EXTRAM_WRENABLE], A ;disable external ram
