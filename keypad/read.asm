    PUSHS


    SECTION	FRAGMENT "HighVariables",HRAM

;-------Button Related---------------------------------------------------------;

b_hold:		DS	1	; 		buttons currently hold
b_prev:		DS	1	;= 0	buttons previously hold
b_pressed:	DS	1	; 		buttons pressed this frame
b_released:	DS	1	; 		buttons released this frame
    
;-------Init-------------------------------------------------------------------;

    SECTION FRAGMENT "ResetVariables0", ROM0
    
	ldh	[b_prev],	A
	ldh	[b_pressed],	A
	
    
;-------Read the keypad--------------------------------------------------------;
;    04                b  a    ;
; 02  + 01    se st    20 10   ;
;    08       40 80            ;
;------------------------------;

    
    SECTION FRAGMENT "Routines", ROM0
	

gRdKeypad:
        ld      a,$20               ; Load bit 5
        ldio    [$ff00],a           ; Send to probe buttons (P15)
        ldio    a,[$ff00]           ; Get return value...
        ldio    a,[$ff00]           ; Wait for post-oscillation to go away...
        ldio    a,[$ff00]
        ldio    a,[$ff00]           ; ... stabilized!
        cpl                         ; Invert a to make pressed keys 1
        and     $0f                 ; Pass lower nibble
        ld      b,a                 ; Store in b


        ld      a,$10                ; Load bit 5
        ldio    [$ff00],a           ; Send to probe +-pad (P15)
        ldio    a,[$ff00]           ; Get return value...
        ldio    a,[$ff00]           ; Wait for post-oscillation to go away...
        ldio    a,[$ff00]
        ldio    a,[$ff00]           ; ... stabilized!
        cpl                         ; Invert a to make pressed keys 1
        and     $0f                 ; Pass lower nibble
        swap    a                   ; swap nibbles, to give space in lowe nibble
        or      b                   ; Combine values
        ld      b,a                 ; Copy a to b
;       ld      [b_hold],a   		; Store new joypad info
        ld      a,[b_prev]       	; Load old joypad value...
        xor     b                   ; Toggle
        and     b                   ;
        ld      [b_pressed],a   	; Store new joypad info
		xor		b
        ld      [b_released],a   	; Store new joypad info
        ld      a,b                 ;
        ld      [b_prev],a      	; Store old joypad info
        ld      a,$30               ;
        ldio     [$ff00],a          ; De-activate
        ret
        

;-------End--------------------------------------------------------------------;
	
	POPS
