    PUSHS
    
    
    SECTION	FRAGMENT "HighVariables", HRAM
    
s_songpos:	DS	1	;=$1E	the position in the song


    SECTION FRAGMENT "ResetVariables", ROM0

	ld	A,	$7E
	ldh	[s_songpos],	A
 
 
;##############################################################################;
;###### Music ##################################################################;
;##############################################################################;
    
    
    SECTION FRAGMENT "Routines", ROM0
    

sPlayMusic1:
	ldh	A,	[s_songpos]	;load songpos
	inc	A
	and	A,	$7F		;song is 64 steps long
	ldh	[s_songpos],	A
	dec	A

	ld	HL,	sNotes1		;load note table
	ld	DE,	sSong1		;load song position
	add	A,	E		;add song time
	ld	E,	A		;...and save as song position
	jp	NC,	.nocarry	;perform carry if needed
	inc	D
.nocarry:

	ld	A,	[DE]	;load current notes in song
	ld	D,	A	;save temporary
	and	$0F		;16 different notes on left channel
	cp	$0		;look if note is silent
	jp	Z,	.noNote	;if so, don't play it
	dec	A		;else, start at 1
	sla	A		;2 bytes per note in the notetable
	add	A,	L	;add base address of notetable 1
	ld	L,	A	

	ld	A,	[HL+]	;load low frequency from notetable 1...
	ldh	[$FF13],	A	;... in left channel
	ld	A,	[HL+]	;load high frequency from notetable 1...
	or	A,	$80	;... make it trigger ...
	ldh	[$FF14],	A	;... in left channel

.noNote:
	ld	HL,	sNotes2	;load notetable 2
	ld	A,	D	;load current notes
	swap	A		;look at high nibble
	and	$0F		;16 different notes on right channel
	cp	$0		;look if note is silent
	jp	Z,	.noNote2	; if so, then don't play it
	dec	A		;else, start at 1
	sla	A		;2 bytes per note in the notetable
	add	A,	L	;add base address of notetable 2
	ld	L,	A

	ld	A,	[HL+]	;load low frequency from notetable 2
	ldh	[$FF18],	A	;... in right channel
	ld	A,	[HL+]	;load high frequency from notetable 2...
	or	A,	$80	;... make it trigger ...
	ldh	[$FF19],	A	;... in right channel

.noNote2:
	ret	;end of song routine
	
;-------End--------------------------------------------------------------------;
	
	POPS
