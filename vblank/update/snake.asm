    PUSHS
 
;-------Animate Snake----------------------------------------------------------;
    
    SECTION FRAGMENT "Routines", ROM0
    

snkAnim:
	cp	0			;if it is 0
	jr	nz,	.is1
	jp	gSnkAnim1
.is1:
	dec	A			;if it is 1
	jr	nz,	.is2
	jp	gSnkAnim2
.is2:
	dec	A
	jr	nz,	.is3
	jp	gSnkAnim3
.is3:
	dec	A
	jr	nz,	.is4
	jp	gSnkAnim4
.is4:
	dec	A
	jr	nz,	.is5
	jp	gSnkAnim5
.is5:
	dec	A
	jr	nz,	.is6
	jp	gSnkAnim6
.is6:
	dec	A
	jr	nz,	.is7
	jp	gSnkAnim7
.is7:
	dec	A
	jr	nz,	.is8
	jp	gSnkAnim8
.is8:
	ret
							
	
;-------End--------------------------------------------------------------------;
	
	POPS
