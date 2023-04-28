.global _start
#register usage in loops
#rax - pointer to pointer to current_node
#rcx - pointer to current node
#%r8 - value, later source
#%r9 - current_node's value

.section .text
_start:
    movl Value, %r8d
    movq $head, %rax
findValueLoop_HW1:
    movq (%rax), %rcx
    testq %rcx, %rcx
    jz end_HW1
    movl (%rcx), %r9d
    cmpl %r8d, %r9d
    je intermission_HW1
    leaq 4(%rcx), %rax
    jmp findValueLoop_HW1

intermission_HW1:
	movq %rax, %r10
	movq %rcx, %r11
	movq $head, %rax
	movq Source, %r8
findSourceLoop_HW1:
	movq (%rax), %rcx
    testq %rcx, %rcx
	jz end_HW1
    cmpq %r8, %rcx
	je replace_HW1
	leaq 4(%rcx), %rax
	jmp findSourceLoop_HW1

#At this point the registers are holding the following values:
#rax - pointer to pointer to source
#rcx - pointer to source
#r10 - pointer to pointer to node with value
#r11 - pointer to node with value
#rdx,rdi - temp registers for swapping
replace_HW1:
	
	movq (%rax), %rdx
	movq (%r10), %rdi
	movq %rdx, (%r10)
	movq %rdi, (%rax)
	
	movq 4(%rcx), %rdx
	movq 4(%r11), %rdi
	movq %rdx, 4(%r11)
	movq %rdi, 4(%rcx)
	
end_HW1:
    