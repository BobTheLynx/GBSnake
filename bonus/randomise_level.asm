
    PUSHS
    
    SECTION	FRAGMENT "HighVariables", HRAM
    
g_bonusniv:	DS	1	;	the speed setting at which the bonus appears


    SECTION FRAGMENT "ResetVariables", ROM0
    
	ldh	A,	[RANDOM]	;randomnize the level at which the bonus appears
	and	A,	$3	; between 3 and 7
	add	A,	$3
	ld	[g_bonusniv],	A

    POPS


;-------Randomnize bonus level-----------------------------------------------;

	ldh	A,	[RANDOM]	;randomnize the level at which the bonus appears
	and	A,	$3	; between 3 and 7
	add	A,	$3
	ld	[g_bonusniv],	A
