    PUSHS
    
    
    SECTION	FRAGMENT "VOAM",HRAM[$FF80]

v_oam:		DS	10	; 		routine to copy OAM's

 
;-------Sprite (OAM) DMA-------------------------------------------------------;
    
    
    SECTION FRAGMENT "Routines", ROM0

vDMA:
	db	$3E,$C0,$E0,$46,$3E,$28,$3D,$20,$FD,$C9
	
;-------End--------------------------------------------------------------------;
	
	POPS
