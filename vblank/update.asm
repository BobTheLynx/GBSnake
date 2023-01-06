    PUSHS
    
    
    SECTION	FRAGMENT "HighVariables",HRAM
    
g_vidBase:	DS	1	;=$98	where in memory is based the video
					; $98	for even levels,	$9A for odd levels

v_flag::	DS	1	;= 0 	flag to notify that a vblank occured
v_newframe: DS	1	;	    if this is a new frame after a step


h_head1adr::	DS	2	;       address head 1
v_head1chr::	DS 	1	;       head1 chr

h_head2adr::   	DS	2	;=$9898	address head 2
v_head2chr::	DS 	1	;       head2 chr

t_tail1adr::	DS	2	;=$9898	address tail 1
v_tail1chr::	DS 	1	;       tail1 chr
t_tail2adr::	DS	2	;		address tail 2
v_tail2chr::	DS 	1	;       tail2 chr
    

v_eating::	    DS	1	;= gEMPTY	whatever shit we are eating
h_eated::   	DS	1	;           whatever shit we did eat

t_freeze::	    DS	1	; 		    freeze snake tail to make it grow  1=freeze


a_appleadr::	DS	2	; 		tile address apple
a_error::	    DS	1	;= 7	was there something blocking me from putting my apple?

g_bonusadr:	DS	2	    ;=$98	the address for the bonus
g_bonuschr:	DS	1	;=gEMPTY	the char under the bonus


s_score:	DS	3	;= LVL1 LVL2 "0"	the current score

;-------init-------------------------------------------------------------------;

    SECTION FRAGMENT "ResetVariables0", ROM0
    
	ldh	[v_flag],	A
	
	
    SECTION FRAGMENT "InitVariables1", ROM0
    
	ldh	[v_newframe],	A
	
	
    SECTION FRAGMENT "ResetVariablesEmptyTile", ROM0
    
	ldh	[v_eating],	A
	ldh	[g_bonuschr],	A
	
	
    SECTION FRAGMENT "ResetVariablesVidbase", ROM0
    
	ldh	[g_vidBase],	A
	ldh	[h_head2adr],	A
	ldh	[h_head2adr+1],	A
	ldh	[t_tail1adr],	A
	ldh	[t_tail1adr+1],	A
	ldh	[g_bonusadr],	A
	ldh	[g_bonusadr+1],A
	

    SECTION FRAGMENT "ResetVariables", ROM0
    
	ld	A,	3
	ldh	[a_error],	A
	

    SECTION FRAGMENT "InitVariables", ROM0

	ld	A,	gLVL1
	ldh	[s_score],	A

	ld	A,	gLVL2
	ldh	[s_score+1],	A

	ld	A,	$31
	ldh	[s_score+2],	A
	
 
;-------VBLANK Interrupt-------------------------------------------------------;
    
    SECTION FRAGMENT "Routines", ROM0
    
    
vBlank:


;-------Save Registers---------------------------------------------------------;
	push	AF	;Save registers
	push	BC
	push	DE
	push	HL

 
    INCLUDE "vblank/update/tiles.asm"

    INCLUDE "vblank/update/time.asm"

	ld	A,	[v_newframe]
	cp	$0		            ;look if we wanna update them all
	jp	Z,	.dontupdcorp	;if not, than skip a big part


	ld	A,	$0
	ld	[v_newframe],	A

	ld	A,	[g_vidBase]	;load the base adress of our video
	ld	D,	A
	

    INCLUDE "vblank/update/apple.asm"

    INCLUDE "vblank/update/bonus.asm"

    INCLUDE "vblank/update/corpse.asm"

    INCLUDE "vblank/update/trail.asm"
    
.dontupdcorp:
    INCLUDE "vblank/update/scores.asm"

;-------Copy OAM---------------------------------------------------------------;

	call	v_oam


    INCLUDE "vblank/update/window.asm"

 
;-------Notify of a VBlank Update----------------------------------------------;

	ld	A,	1		;notify a vblank just happened
	ldh	[v_flag],	A

	ld	A,	0		;clear interrupt flag
	ldh	[rIF],	A

 
;-------Restore Registers------------------------------------------------------;

	pop	HL	;restore registers
	pop	DE
	pop	BC
	pop	AF

	reti		;and return
							
	
;-------End--------------------------------------------------------------------;
	
	POPS
