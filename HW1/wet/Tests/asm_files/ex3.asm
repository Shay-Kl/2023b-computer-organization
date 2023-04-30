.global _start
.section .text
_start:

lea array1, %rcx		#rcx=arr1_add
lea array2, %rdx		#rdx=arr2_add
lea mergedArray, %rdi		#rdi=mArr_add

loop_HW1:
	mov (%rcx), %eax	#rax=*rcx=arr1_val
	mov (%rdx), %ebx	#rdx=*rdx=arr2_val
	test %eax, %eax		#eax-0
	jz arr2_big_HW1		#eax=0(arr1=0)
	cmp %eax, %ebx		#ebx-eax(arr1-arr2)
	jz equal_HW1		#eax=ebx
	jg arr2_big_HW1		#ebx>eax

arr1_big_HW1:
	cmp %eax, -4(%rdi)
	jz duplicate_arr1_HW1
	movl %eax, (%rdi)	#*rdi=eax(mArr=arr1)
	addq $4, %rdi
duplicate_arr1_HW1:		
	addq $4, %rcx		#rcx=+4
	jmp loop_HW1

arr2_big_HW1:
	cmp $0, %ebx		#ebx-0
	jz exit_HW1		#ebx=eax=0
	cmp %ebx, -4(%rdi)
	jz duplicate_arr2_HW1
	movl %ebx, (%edi)	#*rdi=ebx(mArr=arr2)
	addq $4, %rdi
duplicate_arr2_HW1:		
	addq $4, %rdx
	jmp loop_HW1

equal_HW1:
	cmp %eax, -4(%rdi)
	jz duplicate_equal_HW1
	movl %eax, (%rdi)	#*edi=eax(mArr=arr1)
duplicate_equal_HW1:
	addq $4, %rdi
duplicate_equal_repeat_HW1:
	addq $4, %rcx
	addq $4, %rdx
	mov (%rcx), %r8d
	mov (%rdx), %r9d
	cmp %r8d, %r9d
	jne loop_HW1
     mov -4(%rcx), %r8d
	cmp %r8d, %r9d
	jne loop_HW1
     jmp duplicate_equal_repeat_HW1
_end:
exit_HW1:
	movl $0, (%edi)

