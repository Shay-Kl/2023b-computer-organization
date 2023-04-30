.global _start
/*
.section .data
  array1: .int 98,96,94,94,93,85,85,85,81,76,75,74,73,71,68,64,59,58,52,39,38,31,28,26,24,24,23,22,21,21,18,14,11,0
  array2: .int 98,94,68,62,61,58,34,34,31,28,16,6,0
  mergedArray: .zero 34

*/
.section .text
_start:

lea array1, %ecx		#ecx=arr1_add
lea array2, %edx		#edx=arr2_add
lea mergedArray, %edi		#edi=mArr_add

loop_HW1:
	mov (%ecx), %eax	#eax=*ecx=arr1_val
	mov (%edx), %ebx	#edx=*edx=arr2_val
	cmp $0, %eax		#eax-0
	jz arr2_big_HW1		#eax=0(arr1=0)
	cmp %eax, %ebx		#ebx-eax(arr1-arr2)
	jz equal_HW1		#eax=ebx
	jg arr2_big_HW1		#ebx>eax

#arr1big:
	cmp %eax, (%edi)
	jz duplicate_arr1_HW1
	movl %eax, (%edi)	#*edi=eax(mArr=arr1)
	addl $4, %edi
duplicate_arr1_HW1:		
	addl $4, %ecx		#ecx=+4
	jmp loop_HW1

arr2_big_HW1:
	cmp $0, %ebx		#ebx-0
	jz exit_HW1		#ebx=eax=0
	cmp %ebx, (%edi)
	jz duplicate_arr2_HW1
	movl %ebx, (%edi)	#*edi=ebx(mArr=arr2)
	addl $4, %edi
duplicate_arr2_HW1:		
	addl $4, %edx
	jmp loop_HW1

equal_HW1:
	cmp %eax, (%edi)
	jz duplicate_equal_HW1
	movl %eax, (%edi)	#*edi=eax(mArr=arr1)
duplicate_equal_HW1:
	addl $4, %ecx
	addl $4, %edx
	addl $4, %edi
	jmp loop_HW1
_end:
exit_HW1:
	movl $0, (%edi)
/*
mov $60, %rax
syscall*/

