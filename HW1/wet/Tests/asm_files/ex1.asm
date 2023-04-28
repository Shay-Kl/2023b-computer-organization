#cl - index of the bit being checked, goes from 64 to 0
#r9b - counter for Bool
#r8 - where num gets manipulated

.global _start
.section .text
_start:
	movb $64, %cl #cl = 64
	xorb %r9b, %r9b #r9 = 0
loop_HW1: #do {
	decb %cl #cl--
	movq num, %r8 # r8 = num
	shlq %cl, %r8 #r8<<cl
	shrq $63, %r8 #r8>>63
	addb %r8b, %r9b #r9b+=r8b
	testb %cl, %cl
	jnz loop_HW1 #} while(cl!=0)
	movb %r9b, Bool #Bool = r9b
exit_HW1:
	
	
	