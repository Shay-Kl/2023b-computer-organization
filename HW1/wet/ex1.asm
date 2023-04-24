.global _start

.section .data
num: .quad 0xFFFFAAAA0000AAAA

.section .bss
.lcomm bool, 1

.section .text
_start:
	movb $64, %cl #cl = 63
	xorb %r9b, %r9b #r9 = 0
	movq (num), %r10 #r10 = num
loop_HW1: #do {
	decb %cl #cl--
	movq %r10, %r8 # r8 = num
	shlq %cl, %r8 #r8<<cl
	shrq $63, %r8 #r8>>63
	addb %r8b, %r9b #r9b+=r8b
	testb %cl, %cl
	jnz loop_HW1 #} while(cl!=0)	
	movb %r9b, (bool) #bool = r9b
exit_HW1:
	
	
	