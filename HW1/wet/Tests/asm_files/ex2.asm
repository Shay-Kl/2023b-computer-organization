.global _start
.section .data
.section .text
_start:
	movl num, %eax	#eax = num
	movl num, %eax 		#eax = num
	cmp $0, %eax 		#eax==0
	jg memove_HW1 		#jump if eax>0
	movl %eax, (destination)#dest = eax = num
	jmp exit_HW1

memove_HW1:
	movq $source, %rbx 	#rbx=*src
	movq $destination, %rdx	#rdx=*dest
	cmp %rdx, %rbx
	jl reverse_copy_HW1
	movq $0, %rsi
copy_loop_HW1: #do
	movb (%rbx, %rsi), %cl
	movb %cl, (%rdx, %rsi)
	inc %rsi
	cmp %eax, %esi		#esi==eax(num)
	jl copy_loop_HW1 	#while(ecx<eax),while(cnt<num)
	jmp exit_HW1

reverse_copy_HW1:
	movl (num), %esi
reverse_copy_loop_HW1:
	dec %rsi
	movb (%rbx, %rsi, 1), %cl	#cl=*rbx(last byte in src)
	movb %cl, (%rdx, %rsi, 1)	#*rdx(last byte in dest)=cl
	testq %rsi, %rsi
	jne reverse_copy_loop_HW1

exit_HW1:
