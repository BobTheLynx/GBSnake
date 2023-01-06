    PUSHS
 
;-------Update Highscore-------------------------------------------------------;
    
    SECTION FRAGMENT "Routines", ROM0
    

; update in VBlank, pls

gUpdHigh:
	ldh	A,	[s_score+0]		;load highest digit of score
	cp	A,	gLVL1			;if we did just load a level
	jp	Z,	.endUpd			; then ignore the update

	ld	B,	A
	ld	A,	[$9C30]			;load highest digit of highscore
	cp	A,	gHIGH			;if it isn't a icon of "score"
	jp	NZ,	.noStrangeSign	; then we don't need to
	ld	A,	gAPPLE			; replace it with an apple
.noStrangeSign:
	cp	A,	B				;if those are equal
	jp	Z,	.notup1			; then check the next digit
	jp	NC,	.endUpd			;if the latter is bigger, 
							; then we don't need to update anything
	ld	A,	B				;if the former is bigger
	ld	[$9C30],	A		; put the former into the latter
	jp	.upd2				; and update the second digit

.notup1:
	ldh	A,	[s_score+1]		;load middle digit of score
	ld	B,	A				; and compare it with
	ld	A,	[$9C31]			; the middle digit of highscore
	cp	A,	B				;if those are equal
	jp	Z,	.notup2			; then check the next digit
	jp	NC,	.endUpd			;if the latter is bigger, 
							; then we don't need to update anything
.upd2:
	ld	A,	B				;if the former is bigger
	ld	[$9C31],	A		; put the former into the latter
	jp	.upd3				; and update the first digit

.notup2:
	ldh	A,	[s_score+2]		;load lowest digit of score
	ld	B,	A				; and compare it with
	ld	A,	[$9C32]			; the lowest digit of highscore
	cp	A,	B				;if those are equal
	jp	Z,	.notup3			; then damn it, you are good
	jp	NC,	.endUpd			;if the latter is bigger, 
							; you are just a loser
.upd3:
	ldh	A,	[s_score+2]		;if the latter is bigger,
	ld	[$9C32],	A		; you won by a small margin

.notup3:
.endUpd:
	ret						;pfft... why are they so happy about it?
							;It are just numbers!
							
	
;-------End--------------------------------------------------------------------;
	
	POPS
