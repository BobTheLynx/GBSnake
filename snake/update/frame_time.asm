    PUSHS
    
    
    SECTION	FRAGMENT "HighVariables",HRAM
v_time::	DS	1	;= 0	current time
    
    
    SECTION FRAGMENT "ResetVariables0", ROM0
	ldh	[v_time],	A
	
    
    POPS


;--- Update Sprite Frametime -----------------------------------------------------------;

	ldh	A,	[v_time]	;put in the right time
	swap	A
	and	7
	ld	B,	A	;to update the sprites with
	call gUpdSprites	; and make sure the sprite chars are now right
