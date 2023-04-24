.global _start

.section .data
num: .quad 0xFFFFAAAA0000AAAA

.section .bss
.lcomm bool, 1

.section .text
_start:
	movb 64, %cl #cl = 63
	xorq %r9, %r9 #r9 = 0
loop_HW1:
	decb %cl #cl--
	movq (num), %r8 # r8 = num
	shlq %cl, %r8 #r8<<cl
	shrq 63, %r8 #r8>>63
	addb %r8b, %r9b #r9b+=r8b
	test %cl, %cl
	jnz loop_HW1
	movb %r9b, (bool)
	
	
	
	