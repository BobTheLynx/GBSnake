    PUSHS

    SECTION	FRAGMENT "HighVariables",HRAM

b_evH:		DS	1	;= 0	next: going left/right
b_evV:		DS	1	;= 0	next: going up/down
 
 
    SECTION FRAGMENT "ResetVariables0", ROM0
    
	ldh	[b_evH],	A
	ldh	[b_evV],	A
 
;-------Calculate new direction------------------------------------------------;

    SECTION FRAGMENT "Routines", ROM0
    

gGetKeyHeading:
	call	gRdKeypad		;read keypad info

;test if we are pressing rightwards
	ldh	A,	[b_pressed]		
	rrc	A				;(little secret: right is the first bit of the pack)
	jp	NC,	.noRight	;if not right pressed, then check next

; we are pressing rightwards
	ld	B,	A			;save button test state

	ldh	A,	[b_evH]
	or	A,	$01			;fire horizontal button event, put it on RIGHTwards
	ld	[b_evH],	A

	ld	A,	B			;restore button test state
.noRight:

;test if we are pressing leftwards
	rrc	A				;(and left is the second bit of the pack... hihi)
	jp	NC,	.noLeft		;if not left pressed, then check next

	ld	B,	A			;save button test state

	ldh	A,	[b_evH]
	or	A,	$FF			;fire horizontal button event, put it on LEFTwards
	ld	[b_evH],	A

	ld	A,	B			;restore button test state
.noLeft:

;test if we are pressing upwards
	rrc	A				;(then comes up... well, up)
	jp	NC,	.noUp		;if not up pressed, then check next

	ld	B,	A			;save button test state

	ldh	A,	[b_evV]
	or	A,	$FF			;fire vertical button event, put it on UPwards
	ld	[b_evV],	A

	ld	A,	B			;restore button test state
.noUp:

;test if we are pressing downwards
	rrc	A				;(and finally, down might be down)
	jp	NC,	.noDown		;if not down pressed, then wrap it up

	ldh	A,	[b_evV]
	or	A,	$01			;fire vertical button event, put it on DOWNwards
	ld	[b_evV],	A
.noDown:

;and return where we left
	ret
	
;-------End--------------------------------------------------------------------;
	
	POPS
