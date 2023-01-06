    PUSHS
 
;-------Wait for Key-----------------------------------------------------------;
    
    SECTION FRAGMENT "Routines", ROM0
    

;use this routine instead for emulators... there is nothing like the real
gWaitKeyOld:
	call	gGetKeyHeading	;while there
	ldh	A,	[b_pressed]		; is no
	cp	$0					; key down
	jp	Z,	gWaitKeyOld		;burn useless battery life!
	ret

;does not work on some emulators
gWaitKey:
	ldh	A,	[rIE]		; save the interrupt enable register state
	ld	D,	A
        
	ld      a,$0       
	ldio    [$ff00],a 	; look for all buttons
	

;wait for all keys to be released
.waitAllUp:
	ldio    a,[$ff00]
	and	A,	$0F
	cp	A,	$0F
	jp	NZ,	.waitAllUp

	xor	A				;remove all interrupts
	ldh	[rIF],	A
	ldh	[rAUDENA],	a	; write 0 to sound enable register

	ld	A,	IEF_HILO	;wait only for HILO (keypad) interrupt
	ldh	[rIE],	A

	ei					;enable interrupts

	halt				;sleep down so badly, only keys can wake us up
	nop				

	di					;re-disable interrupts

	ld      a,$30       
	ldio    [$ff00],a	;re-disable keys
        
.waitAllDown:
	call	gGetKeyHeading	;update key events to treat our new info
	ldh	A,	[b_prev]	;look if any pressed
	cp	$0			; if not...
	jp	Z,	.waitAllDown	; ... then keep on waiting
	
	
;reset sound registers
	INCLUDE "sound/reset.asm"
	
	ret
	
;-------End--------------------------------------------------------------------;
	
	POPS
