    PUSHS
    

    SECTION	FRAGMENT "HighVariables",HRAM

h_head2dirH:	DS	1	;= 1	horizontal direction head 2
h_head2dirV:	DS	1	;= 0	vertical direction head 2


    SECTION FRAGMENT "ResetVariables0", ROM0
	ldh	[h_head2dirV],	A
	

    SECTION FRAGMENT "ResetVariables1", ROM0
	ldh	[h_head2dirH],	A
	
	
    POPS
    
    
;=== Directions ===============================================================;

upddir:					;update the directions
	ldh	A,	[h_head1dirH]	;do you want me to explain this too?
	ldh	[h_head2dirH],	A

	ldh	A,	[h_head1dirV]
	ldh	[h_head2dirV],	A
