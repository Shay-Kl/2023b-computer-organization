.global main


.section .data
  array1: .int 81,81,77,73,72,67,63,61,51,48,48,43,39,39,34,32,26,25,19,12,9,4,0
  array2: .int 81,81,71,66,59,57,53,52,52,51,50,48,44,27,23,21,19,19,16,14,10,9,8,2,0
  mergedArray: .zero 44


.section .text
main:

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

arr1_big_HW1:
	cmp %eax, -4(%edi)
	jz duplicate_arr1_HW1
	movl %eax, (%edi)	#*edi=eax(mArr=arr1)
	addl $4, %edi
duplicate_arr1_HW1:		
	addl $4, %ecx		#ecx=+4
	jmp loop_HW1

arr2_big_HW1:
	cmp $0, %ebx		#ebx-0
	jz exit_HW1		#ebx=eax=0
	cmp %ebx, -4(%edi)
	jz duplicate_arr2_HW1
	movl %ebx, (%edi)	#*edi=ebx(mArr=arr2)
	addl $4, %edi
duplicate_arr2_HW1:		
	addl $4, %edx
	jmp loop_HW1

equal_HW1:
	cmp %eax, -4(%edi)
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

