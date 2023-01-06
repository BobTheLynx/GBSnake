;-------Show Splash------------------------------------------------------------;
		
iShowSplash:
	ld	A,	124			; position the screen at the splash location
	ldh	[rSCY],	A

	ld	A,	4			;  and a bit off-center for the fun of it
	ldh	[rSCX],	a 		

	ld	a,	%11100001	; LCD on + BG on + BG $8000 + WIN on + WIN $9C00
	ldh	[rLCDC],a		; enable LCD

	call	gWaitKey	; wait for user to press key to quit the splashscreen

iEndSplash:
	WaitForVBlank
