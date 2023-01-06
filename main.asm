
INCLUDE "gbhw.inc"

;##############################################################################;
;###### GRAFIX ################################################################;
;##############################################################################;

;-------Background-------------------------------------------------------------;

gEMPTY	EQU	$20
gGRASS	EQU	$40


;-------Apple------------------------------------------------------------------;

gAPPLE	EQU	$0C


;-------Header-----------------------------------------------------------------;

gTIMER	EQU	$0D
gDEATH	EQU	$0E
gHIGH	EQU	$0F
gLVL1	EQU	$3B
gLVL2	EQU	$3C


;-------Hardware-----------------------------------------------------------------;

RANDOM EQU rDIV


;-------Macro's-------------------------------------------------------------------;

MACRO WaitForVBlank
:
	ldh	a,	[rLY]		; wait for
	cp	$90				;  vertical blank
	jr	nz,	:-
ENDM


;-------Variables-----------------------------------------------------------------;
	
SECTION	FRAGMENT "HighVariables",HRAM

m_prevtime:	DS	1	;= 0	the previous time
m_rstcnt:	DS	1	;= 3	the counter used for resetting the game correctly


SECTION	FRAGMENT "Sprites", WRAM0, ALIGN[8]
o_start:

;##############################################################################;
;###### HEADER ################################################################;
;##############################################################################;

;=======Interrupt Handler======================================================;

;-------Vertical Blank Interrupt-----------------------------------------------;

SECTION "Vblank",ROM0[$0040]

	jp	vBlank		; vertical blank handled elsewhere


;-------Joypad Interrupt-------------------------------------------------------;

SECTION	"Joypad interrupt",ROM0[$60]

	reti			; joypad interrupt not (really) handled
	
	
;=======ROM Header=============================================================;

SECTION "start",ROM0[$0100]	

;-------Boot Code--------------------------------------------------------------;
	nop				;first 3 bytes allowed for the init
	jp	start

;-------Nintendo Header--------------------------------------------------------;
	db	$CE,$ED,$66,$66,$CC,$0D,$00,$0B,$03,$73,$00,$83,$00,$0C,$00,$0D
	db	$00,$08,$11,$1F,$88,$89,$00,$0E,$DC,$CC,$6E,$E6,$DD,$DD,$D9,$99
	db	$BB,$BB,$67,$63,$6E,$0E,$EC,$CC,$DD,$DC,$99,$9F,$BB,$B9,$33,$3E

;-------Game Title (15 bytes)--------------------------------------------------;
	db	"Yvar's GB Snake"

;-------Color Compatibility----------------------------------------------------;
	db	$80	;	$00 = dmg	$80 = dmg+cgb	$B0 = cgb only

;-------Licencee Code----------------------------------------------------------;
	db	$00,$00	;$0000 = Homebrew

;-------SGB Support Code-------------------------------------------------------;
	db	$00	;No support

;-------Card Type--------------------------------------------------------------;
	db	$00	;No MBC
	db	$00	;32384 bytes ROM
	db	$00	;No RAM

;-------Destination Code-------------------------------------------------------;
	db	$01	;Outside Japan

;-------Old Licencee Code------------------------------------------------------;
	db	$00	;Unused

;-------Rom Version------------------------------------------------------------;
	db	$2D	;Version 0.2D

;-------Header Checksum--------------------------------------------------------;
	db	$00	;To be filled in later

;-------Game Checksum----------------------------------------------------------;
	db	$00	;To be filled in later
	db	$00	;To be filled in later


;##############################################################################;
;###### INIT ##################################################################;
;##############################################################################;

start:
	nop	
	di					; we don't want an interrupt during init


;-------Initialize Stack-------------------------------------------------------;

iIniStack:
	ld	sp,	$fffe		; stack points to top of the high ram

    INCLUDE "vblank/init.asm"
    
    jp iInitVariables_0
    
    
;-------Initialize Variables with 0--------------------------------------------;
    
    SECTION FRAGMENT "InitVariables0", ROM0
    
iInitVariables_0:
	xor	A			; load 0
	ldh	[m_prevtime],	A
	
	
;-------Initialize Variables with 1--------------------------------------------;
	
    SECTION FRAGMENT "InitVariables1", ROM0
    
iInitVariables_1:
	ld	A,	$1


;-------Initialize Variables with empty tile-----------------------------------;
	
    SECTION FRAGMENT "InitVariablesEmptyTile", ROM0
    
iInitVariables_emptyTile:
	ld	A,	gEMPTY
	
	
;-------Initialize Variables with video base-----------------------------------;
	
    SECTION FRAGMENT "InitVariablesVidbase", ROM0
	
iInitVariables_vidBase:
	ld	A,	$98

	
;-------Initialize Variables---------------------------------------------------;
	
    SECTION FRAGMENT "InitVariables", ROM0

iInitVariables:
	ld	A,	3
	ldh	[m_rstcnt],	A
    
    
;-------Initialize Everything Else---------------------------------------------;
    
    SECTION "init_other", ROM0
    
iInitOthers:

    INCLUDE "vblank/init/header.asm"

    INCLUDE "vblank/init/window.asm"

    INCLUDE "sound/init.asm"
	
    INCLUDE "vblank/init/palettes.asm"

    INCLUDE "vblank/splash.asm"

    INCLUDE "bonus/randomise_level.asm"

    INCLUDE "vblank/init/screen.asm"

    INCLUDE "vblank/init/header2.asm"


;-------Re-Enable Interrupts---------------------------------------------------;    

iEI:
iReset:
    
    jp iResetVariables_0
    
    
;-------Reset Variables with 0--------------------------------------------;
    
    SECTION FRAGMENT "ResetVariables0", ROM0
    
iResetVariables_0:
	xor	A			; load 0
	
	
;-------Reset Variables with 1--------------------------------------------;
	
    SECTION FRAGMENT "ResetVariables1", ROM0
    
iResetVariables_1:
	ld	A,	$1


;-------Reset Variables with empty tile-----------------------------------;
	
    SECTION FRAGMENT "ResetVariablesEmptyTile", ROM0
    
iResetVariables_emptyTile:
	ld	A,	gEMPTY
	
	
;-------Reset Variables with video base-----------------------------------;
	
    SECTION FRAGMENT "ResetVariablesVidbase", ROM0
	
iResetVariables_vidBase:
	ld	A,	$98

	
;-------Reset Variables---------------------------------------------------;
	
    SECTION FRAGMENT "ResetVariables", ROM0

iResetVariables:
	ld	A,	3
    ld  [m_rstcnt], A


;-------Round off---------------------------------------------------------;

    SECTION "main", ROM0
    

iResetDone:

	xor	a
	ldh	[rIF],	a		; clear interrupt flags; too dangerous elsewise

	ld	a,	IEF_VBLANK
	ldh	[rIE],	a		; enable VBlank interrupt flag


	ei					; ahhh... enable interrupts

	jp	mHotRestart		;  and immediately perform a step


;##############################################################################;
;###### MAIN ##################################################################;
;##############################################################################;


mMain:
	call	gGetKeyHeading	;Keypad Input

	ldh	A,	[v_time]		;Check if new step
	ld	B,	A
	ldh	A,	[m_prevtime]
	xor	B
	and	$80
	jr	z,	noMainStep		; if not, sleep in again

	;test if not blocking pause
	ldh	A,	[m_rstcnt]		;If we are still buzy resetting
	cp	A,	$FF	
	jp	nz,	noPause			; don't allow any pause to occur

	ldh	A,	[v_corpse]		;If we just die
	cp	$FF
	jp	Z,	noPause			; don't allow it eighter

	ldh	A,	[b_prev]		;Finally, if we did press any "button-style" button
	and	$F0
	jp	NZ,	mPause			; then, and only then, pause the game

noPause:
mEndPause:
	call	sPlayMusic1		;Step the music
	jp	mMainStep			; and step the game

;-------Sleep in the machine---------------------------------------------------;
noMainStep:
mMainStepEnd:
	ldh	A,	[v_time]
	ldh	[m_prevtime],	A

.wait:
	ld	a,	IEF_VBLANK
	ldh	[rIE],	a		; enable VBlank interrupt flag... just to be sure

	halt		;Halt the system clock.
				;Return from HALT mode 
				; if an interrupt is generated.
	nop			;Used to avoid bugs in the rare case 
				; that the instruction after the HALT 
				; is not executed

;-------Test for VBlank Interrupt----------------------------------------------;

	ldh	A,	[v_flag]
	and	A			;Generate a V-blank interrupt?
	jr	Z,	.wait	;Jump if a non-V-blank interrupt
 
	xor	A		
	ldh	[v_flag], A	;Clear the V-Blank Flag
 
	jr	mMain		; and restart that damn main


    INCLUDE "keypad/powersaver.asm"


;##############################################################################;
;###### PERFORM STEP ##########################################################;
;##############################################################################;

mMainStep:
	ld	A,	$1		;signal a new frame
	ld	[v_newframe],	A


    INCLUDE "keypad/update.asm"


;=== Addresses ================================================================;

    INCLUDE "snake/head2adr.asm"

mHotRestart:
;=== Tiles ====================================================================;

	xor	A
	ldh	[t_freeze],	A		;clear tail freeze; for if we did eat an apple last turn

    INCLUDE "snake/killcheck.asm"
    
	INCLUDE "snake/apple.asm"

;--- Don't update head if killed ----------------------------------------------;

	ldh	A,	[v_corpse]	;check if we are killed
	cp	$FF				; if so
	jp	Z,	dontUpdHead	;  we do a big leap forward


    INCLUDE "snake/update/head.asm"

    INCLUDE "snake/update/body.asm"

    INCLUDE "snake/update/head2.asm"

    INCLUDE "snake/update/apple.asm"

    INCLUDE "snake/update/tail2.asm"

	INCLUDE "snake/update/tail.asm"

    INCLUDE "snake/update/directions.asm"	

    INCLUDE "snake/update/sprites.asm"

    INCLUDE "snake/update/move_tail.asm"

    INCLUDE "snake/update/display_addresses.asm"

    INCLUDE "snake/update/frame_time.asm"

    INCLUDE "bonus/update.asm"

    INCLUDE "interface/timer1.asm"

    INCLUDE "interface/timer2.asm"

    INCLUDE "interface/post_reset.asm"



;##############################################################################;
;###### SOFT RESET ############################################################;
;##############################################################################;



errTrail:
stopTail:
tDie:
	di

	ld	A,	$3
	call	gDrawMessage

    WaitForVBlank

    INCLUDE "vblank/reset.asm"

;--- Restart ------------------------------------------------------------------;
mRestaerd:

	WaitForVBlank

	INCLUDE "vblank/restart.asm"
    
 
;##############################################################################;
;###### GENERIC ROUTINES ######################################################;
;##############################################################################;

    INCLUDE "keypad/routines.asm"
    INCLUDE "snake/routines.asm"
    INCLUDE "interface/routines.asm"
    INCLUDE "vblank/routines.asm"
    INCLUDE "sound/routines.asm"
    
    
;End of sections
    
    SECTION FRAGMENT "InitVariables0", ROM0
    jp iInitVariables_1
	
    SECTION FRAGMENT "InitVariables1", ROM0
    jp iInitVariables_emptyTile

    SECTION FRAGMENT "InitVariablesEmptyTile", ROM0
    jp iInitVariables_vidBase
	
    SECTION FRAGMENT "InitVariablesVidbase", ROM0
    jp iInitVariables
	
    SECTION FRAGMENT "InitVariables", ROM0
    jp iInitOthers

    
    SECTION FRAGMENT "ResetVariables0", ROM0
    jp iResetVariables_1
	
    SECTION FRAGMENT "ResetVariables1", ROM0
    jp iResetVariables_emptyTile

    SECTION FRAGMENT "ResetVariablesEmptyTile", ROM0
    jp iResetVariables_vidBase
	
    SECTION FRAGMENT "ResetVariablesVidbase", ROM0
    jp iResetVariables
	
    SECTION FRAGMENT "ResetVariables", ROM0
    jp iResetDone

;Data

    INCLUDE "data.asm"
