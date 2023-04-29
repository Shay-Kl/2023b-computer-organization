.global _start
/*
.section .data
num: .int 0x00000004
source_value: .int 0xA1234567
destination_value: .int 0xABCDEF98
source: .quad source_value
destination: .quad destination_value

.section .bss
*/
.section .text
_start:
	movl num, %eax 		#eax = num
	cmp $0, %eax 		#eax==0
	jg memove_HW1 		#jump if eax>0
	movl %eax, (destination)#dest = eax = num
	jmp exit_HW1

memove_HW1:
	movq source, %rbx 	#rbx=*src
	movq destination, %rdx	#edx=*dest
	lea (%rbx, %rax), %rdi	#rdi=*(rbx+rax)=*(src+num)
	cmp %rdx, %rdi		#rdi-rdx=*(src+num)-*dest
	jg overlap_copy_HW1

	movq %rdx, %rbp		#rbp=rdx=*dest
	movq %rbx, %rdi		#rdi=rbx=*src
	movl $0, %esi
copy_loop_HW1: #do
	movb (%rbx), %cl	#cl=*eax(first byte in src)
	movb %cl, (%rdx)	#*ebx(first byte in dest)=cl
	inc %rsi 		#esi++(counter)
	leaq (%rdi, %rsi, 1), %rbx
	leaq (%rbp, %rsi, 1), %rdx	
	cmp %eax, %esi		#esi==eax(num)
	jl copy_loop_HW1 	#while(ecx<eax),while(cnt<num)
	jmp exit_HW1

overlap_copy_HW1:
	movq %rdi, %rbx 	#rbx=rbi=*(src+num)
	lea (%rdx, %rax), %rbp	#rbp=*(rbx+rax)=*(dest+num)
	movq %rbp, %rdx		#rdx=rbp=*(dest+num)
overlap_copy_loop_HW1:
	movb (%rbx), %cl	#cl=*rbx(last byte in src)
	movb %cl, (%rdx)	#*rdx(last byte in dest)=cl
	dec %rsi
	leaq (%rdi, %rsi, 1), %rbx
	leaq (%rbp, %rsi, 1), %rdx	
	addq %rsi, %rax
	cmp $0, %rax
	jnz overlap_copy_loop_HW1
exit_HW1:
/*
mov $60, %rax
syscall*/
