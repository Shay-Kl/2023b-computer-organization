.globl my_ili_handler

.text
.align 4, 0x90
my_ili_handler:
	push %rax
	push %rdi
  	movq 16(%rsp), %rdi
	push %rbx
	push %rcx
	push %rdx
	push %rbp
	push %rsi
	push %r8
	push %r9
	push %r10
	push %r11
	push %r12
	push %r13
	push %r14
	push %r15
	mov (%rdi), %rcx
	cmpb $0x0f, %cl
	je two_bytes
one_byte:
	mov %rcx, %rdi
	call what_to_do
	
  	test %rax, %rax
  	jz normal_handler
	pop %r15
	pop %r14
	pop %r13
	pop %r12
	pop %r11
	pop %r10
	pop %r9
	pop %r8
	pop %rsi
	pop %rbp
	pop %rdx
	pop %rcx
	pop %rbx
	pop %rdi
	mov %rax, %rdi
	pop %rax
	addq $1, (%rsp)
	iretq
  
  
two_bytes:
	mov 1(%rdi), %rdi
  	call what_to_do
  	test %rax, %rax
  	jz normal_handler
	pop %r15
	pop %r14
	pop %r13
	pop %r12
	pop %r11
	pop %r10
	pop %r9
	pop %r8
	pop %rsi
	pop %rbp
	pop %rdx
	pop %rcx
	pop %rbx
	pop %rdi
	mov %rax, %rdi
	pop %rax
	addq $2, (%rsp)
	iretq
  
normal_handler:
	pop %r15
	pop %r14
	pop %r13
	pop %r12
	pop %r11
	pop %r10
	pop %r9
	pop %r8
	pop %rsi
	pop %rbp
	pop %rdx
	pop %rcx
	pop %rbx
	pop %rdi
	pop %rax
	jmp * old_ili_handler
	
